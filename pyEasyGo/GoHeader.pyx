import re
import os
import sys
from ctypes import *
from cgocheck cimport cgocheck

cdef class GoType:
	def __cinit__(self, str s):
		self.s = s
	
	def __str__(self):
		return self.s

	cdef restype(self):
		return None

	cdef convert(self, object pv):
		return pv

	cdef restore(self, object gv):
		return gv

	cdef bint containsGoPointer(self):
		return False
	
cdef class GoVoidType(GoType):
	cdef restore(self, object gv):
		return None

cdef class GoUint8Type(GoType):
	cdef restore(self, object gv):
		return c_uint8(gv)

cdef class GoInt8Type(GoType):
	cdef restore(self, object gv):
		return c_int8(gv)

cdef class GoUint16Type(GoType):
	cdef restore(self, object gv):
		return c_uint16(gv)

cdef class GoInt16Type(GoType):
	cdef restore(self, object gv):
		return c_int16(gv)

cdef class GoUint32Type(GoType):
	cdef restore(self, object gv):
		return c_uint32(gv)

cdef class GoInt32Type(GoType):
	cdef restore(self, object gv):
		return c_int32(gv)

cdef class GoInt64Type(GoType):
	cdef restore(self, object gv):
		return c_int64(gv)

cdef class GoUint64Type(GoType):
	cdef restore(self, object gv):
		return c_uint64(gv)

cdef class GoIntType(GoType): 
	cdef convert(self, object pv):
		if not isinstance(pv, (int, long)):
			raise TypeError("int required, but got %s" % type(pv).__name__)
		if pv > 0x7fffffffffffffff or pv < -0x7fffffffffffffff-1:
			raise OverflowError(pv)

		return c_long(pv)

cdef class GoUintType(GoType):
	cdef restore(self, object gv):
		return c_uint(gv)

cdef class GoUintptrType(GoType):
	pass

cdef class GoFloat32Type(GoType):
	cdef restype(self): return c_float
	cdef convert(self, object pv):
		return c_float(pv)

cdef class GoFloat64Type(GoType):
	pass

cdef class GoComplex64Type(GoType):
	pass

cdef class GoComplex128Type(GoType):
	pass

cdef class GoMapType(GoType):
	pass

cdef class GoChanType(GoType):
	pass

cdef class GoSliceType(GoType):
	pass

class GoStringHeader(Structure):
	_fields_ = [ ('p', c_char_p),  ('n', c_long) ]

cdef class GoStringType(GoType):
	cdef convert(self, object pv):
		if isinstance(pv, str):
			return GoStringHeader(c_char_p(pv), len(pv))
		elif isinstance(pv, unicode):
			pv = pv.encode('utf-8')
			return GoStringHeader(c_char_p(pv), len(pv))
		else:
			raise TypeError("str or unicode is required, got %s" % type(pv).__name__)

	cdef restype(self):
		return GoStringHeader
	
	cdef restore(self, object gv):
		return gv.p[:gv.n]

	cdef bint containsGoPointer(self):
		return True

cdef class GoInterfaceType(GoType):  pass
cdef class GoCharType(GoType): pass

cdef class GoCharPtrType(GoType): 
	cdef convert(self, object pv):
		if isinstance(pv, str):
			return c_char_p(pv)
		elif isinstance(pv, unicode):
			pv = pv.encode('utf-8')
			return c_char_p(pv)
		else:
			raise TypeError("str or unicode is required, got %s" % type(pv).__name__)

	cdef restype(self):
		return c_char_p

cdef class GoStructureType(GoType): pass

cdef class GoPointerType(GoType):
	cdef GoType subType 

	def __cinit__(self, str s):
		cdef str subTypeStr = s[:-1]
		self.subType = makeGoType(subTypeStr)

cdef dict goTypeMap = {
	'void': GoVoidType, 
	'GoString': GoStringType, 
	'char': GoCharType, 
	'GoInt': GoIntType, 
	'GoUint': GoUintType, 
	'GoInt8': GoInt8Type, 
	'GoUint8': GoUint8Type, 
	'GoInt16': GoInt16Type, 
	'GoUint16': GoUint16Type,
	'GoInt32': GoInt32Type, 
	'GoUint32': GoUint32Type,
	'GoInt64': GoInt64Type, 
	'GoUint64': GoUint64Type,
	'GoUintptr': GoUintptrType, 
	'GoFloat32': GoFloat32Type, 
	'GoFloat64': GoFloat64Type, 
	'GoComplex64': GoComplex64Type, 
	'GoComplex128': GoComplex128Type,
	'GoInterface': GoInterfaceType, 
	'GoMap': GoMapType, 
	'GoChan': GoChanType, 
	'GoSlice': GoSliceType,
}

cdef GoType makeGoType(str typeStr):
	if typeStr in goTypeMap:
		return goTypeMap[typeStr](typeStr)

	if typeStr.endswith('*'):
		if typeStr[:-1].strip() == 'char':
			return GoCharPtrType(typeStr)

		return GoPointerType(typeStr)
	elif typeStr.startswith('struct '):
		return GoStructureType(typeStr)

	assert False, 'unknown go type: %s' % typeStr

cdef class GoFuncDecl:
	def __cinit__(self, retType, funcName, argList):
		self.retType = makeGoType(retType)
		self.funcName = funcName
		self.argList = tuple(makeGoType(s.split(' ')[0]) for s in argList.split(', ')) if argList else ()

	def __str__(self):
		return "%s %s(%s)" % (self.retType, self.funcName, ", ".join(map(str, self.argList)))

	cdef getResType(self):
		return self.retType.restype()

	cdef list convertArgs(self, tuple args):
		if len(args) != len(self.argList):
			raise TypeError("%s takes %s arguments (%d given)" % (self, len(self.argList), len(args)) )
		
		cdef GoType argType
		cdef list convertedArgs = []
		for i, _argType in enumerate(self.argList):
			argType = _argType
			convertedArgs.append(argType.convert(args[i]))

		return convertedArgs

	cdef object restoreReturnVal(self, object ret):
		return self.retType.restore(ret)

	cdef validate(self):
		# check if returnType contains GoPointer
		if self.retType.containsGoPointer():
			if cgocheck() != 0:
				print >>sys.stderr, 'WARNING: Go function "%s" returns Go pointer and cgocheck!=0. Will panic when called.' % self

cdef class GoHeader:

	PROLOGUE_END = re.compile(r'/\*\s*End of boilerplate cgo prologue.\s*\*/\s*')
	FUNC_PATTERN = re.compile(r'extern (.*) (\S+)\((.*)\);\s*')

	def __cinit__(self, headerPath):
		self.path = headerPath

		cdef bint prologueEnded = False
		self.funcDecls = {}
		with open(self.path) as fd:
			for line in fd:
				if not prologueEnded:
					if self.PROLOGUE_END.match(line):
						prologueEnded = True
				else:
					m = self.FUNC_PATTERN.match(line)
					if m:
						# found extern function
						retType, funcName, argList = m.groups()
						self.funcDecls[funcName] = GoFuncDecl(retType, funcName, argList)
						# print 'parseExternFunc', retType, funcName, argList, "=>", self.funcDecls[funcName]
					# else: 
					# 	print 'ignore', line,

		self.validate()

	def __str__(self):
		return "<%s>" % self.path

	cdef GoFuncDecl getFuncDecl(self, str funcName):
		return self.funcDecls[funcName]

	cdef validate(self):
		cdef GoFuncDecl decl
		for decl in self.funcDecls.itervalues():
			decl.validate()

