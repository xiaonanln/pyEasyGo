
import ctypes
from ctypes import CDLL
from ctypes import cdll

from GoHeader cimport GoHeader
from GoHeader cimport GoFuncDecl
from GoHeader cimport GoType

cdef class _FuncCaller:
	cdef object func
	cdef GoFuncDecl decl

	def __cinit__(self, object func, GoFuncDecl decl):
		self.func = func
		self.decl = decl

	def __call__(self, *args):
		args = self.decl.convertArgs(args)
		return self.func( *args )

cdef class GoModule:

	cdef object clib
	cdef str filePath
	cdef GoHeader header

	def __cinit__(self, str soFilePath):
		self.filePath = soFilePath
		assert self.filePath.endswith('.so'), self.filePath
		self.clib = cdll.LoadLibrary(soFilePath)
		self.header = GoHeader(self.filePath[:-3] + '.h')
		print soFilePath, "==>", self.clib, self.header
	
	def __str__(self):
		return "GoModule<%s>" % self.filePath

	def __getattr__(self, funcName):
		print '__getattr__', funcName
		func = getattr(self.clib, funcName)
		funcDecl = self.header.getFuncDecl(funcName)
		return _FuncCaller(func, funcDecl)

