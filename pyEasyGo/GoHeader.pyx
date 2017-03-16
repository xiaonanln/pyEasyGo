
import re

cdef class GoType:
	def __cinit__(self, s):
		self.s = s
	
	def __str__(self):
		return self.s

cdef class GoFuncDecl:
	def __cinit__(self, retType, funcName, argList):
		self.retType = GoType(retType)
		self.funcName = funcName
		self.argList = tuple(GoType(s.split(' ')[0]) for s in argList.split(', ')) if argList else ()

	def __str__(self):
		return "%s %s(%s)" % (self.retType, self.funcName, ", ".join(map(str, self.argList)))

	cdef tuple convertArgs(self, tuple args):
		print 'ARGS %s => %s' % (args, map(str, self.argList))
		if len(args) != len(self.argList):
			raise TypeError("%s takes %s arguments (%d given)" % (self, len(self.argList), len(args)) )
	
		return tuple(argType.convert(args[i]) for i, argType in enumerate(self.argList))

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
						print 'parseExternFunc', retType, funcName, argList, "=>", self.funcDecls[funcName]

	def __str__(self):
		return "<%s>" % self.path

	cdef GoFuncDecl getFuncDecl(self, str funcName):
		return self.funcDecls[funcName]
