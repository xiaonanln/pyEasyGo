
import ctypes
from ctypes import CDLL
from ctypes import cdll

cdef class _FuncCaller:
	cdef object func

	def __cinit__(self, object func):
		self.func = func

	def __call__(self, *args):
		return self.func( *args )

cdef class GoModule:

	cdef object clib
	cdef str filePath

	def __cinit__(self, str soFilePath):
		self.filePath = soFilePath
		self.clib = cdll.LoadLibrary(soFilePath)
		print soFilePath, "==>", self.clib
	
	def __str__(self):
		return "GoModule<%s>" % self.filePath

	def __getattr__(self, funcName):
		print '__getattr__', funcName
		func = getattr(self.clib, funcName)
		return _FuncCaller(func)

