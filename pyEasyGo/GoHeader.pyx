from ctypes import *
import re

cdef class GoType:
	def __cinit__(self, str s):
		self.s = s
	
	def __str__(self):
		return self.s

cdef class GoVoidType(GoType):
	cpdef restore(self, object gv):
		return None

cdef class GoIntType(GoType): 
	cpdef convert(self, long pv):
		return c_long(pv)

class GoStringHeader(Structure):
	_fields_ = [ ('p', c_char_p),  ('n', c_long) ]

cdef class GoStringType(GoType):
	cpdef convert(self, object pv):
		if isinstance(pv, str):
			return GoStringHeader(c_char_p(pv), len(pv))
		elif isinstance(pv, unicode):
			pv = pv.encode('utf-8')
			return GoStringHeader(c_char_p(pv), len(pv))
		else:
			raise TypeError("str or unicode is required, got %s" % type(pv).__name__)

cdef class GoInterfaceType(GoType):  pass
cdef class GoCharType(GoType): pass

cdef class GoCharPtrType(GoType): 
	cpdef convert(self, object pv):
		if isinstance(pv, str):
			return c_char_p(pv)
		elif isinstance(pv, unicode):
			pv = pv.encode('utf-8')
			return c_char_p(pv)
		else:
			raise TypeError("str or unicode is required, got %s" % type(pv).__name__)

	cpdef restore(self, long gv):
		return c_char_p(gv).value

cdef class GoPointerType(GoType):
	cdef GoType subType 

	def __cinit__(self, str s):
		cdef str subTypeStr = s[:-1]
		self.subType = makeGoType(subTypeStr)


cdef GoType makeGoType(typeStr):
	if typeStr == 'void':
		return GoVoidType(typeStr)
	elif typeStr == 'GoInt':
		return GoIntType(typeStr)
	elif typeStr == 'GoString':
		return GoStringType(typeStr)
	elif typeStr == 'GoInterface':
		return GoInterfaceType(typeStr)
	elif typeStr == 'char':
		return GoCharType(typeStr)
	elif typeStr.endswith('*'):
		if typeStr[:-1].strip() == 'char':
			return GoCharPtrType(typeStr)

		return GoPointerType(typeStr)

	assert False, 'unknown go type: %s' % typeStr

cdef class GoFuncDecl:
	def __cinit__(self, retType, funcName, argList):
		self.retType = makeGoType(retType)
		self.funcName = funcName
		self.argList = tuple(makeGoType(s.split(' ')[0]) for s in argList.split(', ')) if argList else ()

	def __str__(self):
		return "%s %s(%s)" % (self.retType, self.funcName, ", ".join(map(str, self.argList)))

	cdef getResType(self):
		return self.retType.restore

	cdef tuple convertArgs(self, tuple args):
		if len(args) != len(self.argList):
			raise TypeError("%s takes %s arguments (%d given)" % (self, len(self.argList), len(args)) )
	
		return tuple(argType.convert(args[i]) for i, argType in enumerate(self.argList))

	cdef object restoreReturnVal(self, object ret):
		return self.retType.restore(ret)

cdef class GoHeader:

	PROLOGUE_END = re.compile(r'/\*\s*End of boilerplate cgo prologue.\s*\*/\s*')
	FUNC_PATTERN = re.compile(r'extern (\S+) (\S+)\((.*)\);\s*')

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

	def __str__(self):
		return "<%s>" % self.path

	cdef GoFuncDecl getFuncDecl(self, str funcName):
		return self.funcDecls[funcName]
