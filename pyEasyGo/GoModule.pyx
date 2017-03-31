
import os
import sys
import ctypes
from ctypes import CDLL
from ctypes import cdll
from ctypes import c_void_p

from GoHeader cimport GoHeader
from GoHeader cimport GoFuncDecl
from GoHeader cimport GoType
from cgocheck cimport cgocheck

from errors import GolangError, GoModuleNotPatchedError

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
		self.pointerRefCounts = {}
		self.clib = cdll.LoadLibrary(soFilePath)
		self.header = GoHeader(self.filePath[:-3] + '.h')
		try:
			self.__SavePtr = self.clib.__SavePtr
			self.__FreePtr = self.clib.__FreePtr
			self.patched = True
		except AttributeError:
			print >>sys.stderr, 'WARNING: %s is not patched, please add pyEasyGoPatch.go to your go package and rebuild to enable full functionalities' % self.filePath

		# print soFilePath, "==>", self.clib, self.header, self.__SavePtr, self.__FreePtr
	
	def __str__(self):
		return "GoModule<%s>" % self.filePath

	def __getattr__(self, funcName):
		func = getattr(self.clib, funcName)
		funcDecl = self.header.getFuncDecl(funcName)
		funcCaller = _FuncCaller(self, func, funcDecl)
		# setattr(self, funcName, funcCaller)
		return funcCaller

	cdef savePtr(self, unsigned long ptr):
		if not self.patched:
			raise GoModuleNotPatchedError()
		
		cdef int refs
		refs = self.pointerRefCounts[ptr] = self.pointerRefCounts.get(ptr, 0) + 1
		if refs == 1:
			self.__SavePtr(c_void_p(ptr))

	cdef freePtr(self, unsigned long ptr):
		if not self.patched:
			raise GoModuleNotPatchedError()

		cdef int refs
		refs = self.pointerRefCounts[ptr] = self.pointerRefCounts.get(ptr, 0) - 1
		if refs == 0:
			self.__FreePtr(c_void_p(ptr))
		elif refs < 0:
			print >>sys.stderr, 'ERROR: reference count of pointer %s = %d' % (ptr, refs)

