
import os
import sys
import ctypes
from ctypes import CDLL
from ctypes import cdll

from GoHeader cimport GoHeader
from GoHeader cimport GoFuncDecl
from GoHeader cimport GoType
from cgocheck cimport cgocheck

from errors import GolangError

cdef class _FuncCaller:
	cdef GoModule owner
	cdef object func
	cdef GoFuncDecl decl

	def __cinit__(self, GoModule owner, object func, GoFuncDecl decl):
		self.owner = owner
		self.func = func
		self.decl = decl
		restype = decl.getResType()
		if restype is not None:
			func.restype = restype

		if decl.retType.containsGoPointer() and cgocheck() != 0:
			raise GolangError("return value contains Go pointer and cgocheck=%d" % cgocheck())

	def __call__(self, *_args):
		cdef list args = self.decl.convertArgs(_args)
		ret = self.func( *args )
		return self.decl.restoreReturnVal(self.owner, ret)

cdef class GoModule:

	def __cinit__(self, str soFilePath):
		self.filePath = soFilePath
		assert self.filePath.endswith('.so'), self.filePath
		self.clib = cdll.LoadLibrary(soFilePath)
		self.header = GoHeader(self.filePath[:-3] + '.h')
		try:
			self.__SavePtr = self.clib.__SavePtr
			self.__FreePtr = self.clib.__FreePtr
		except AttributeError:
			print >>sys.stderr, 'ERROR: __SavePtr not exported in Go shared library, please add pyEasyGoPatch.go to your go package'
			raise 

		print soFilePath, "==>", self.clib, self.header, self.__SavePtr, self.__FreePtr
	
	def __str__(self):
		return "GoModule<%s>" % self.filePath

	def __getattr__(self, funcName):
		func = getattr(self.clib, funcName)
		funcDecl = self.header.getFuncDecl(funcName)
		funcCaller = _FuncCaller(self, func, funcDecl)
		# setattr(self, funcName, funcCaller)
		return funcCaller

