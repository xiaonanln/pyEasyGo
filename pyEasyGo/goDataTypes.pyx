
import sys

cdef class GoPointer:

	def __cinit__(self, GoModule module, unsigned long p):
		self.module = module
		self.ptr =  p
		self.module.savePtr(p)

	def __dealloc__(self):
		self.module.freePtr(self.ptr)

cdef class GoMap:

	def __cinit__(self, GoModule module, unsigned long p):
		self.module = module
		self.ptr =  p
		self.module.savePtr(p)

	def __dealloc__(self):
		self.module.freePtr(self.ptr)

cdef class GoChan:

	def __cinit__(self, GoModule module, unsigned long p):
		self.module = module
		self.ptr =  p
		self.module.savePtr(p)

	def __dealloc__(self):
		self.module.freePtr(self.ptr)

cdef class GoInterface:
	def __cinit__(self, GoModule module, unsigned long t, unsigned long v):
		self.module = module
		self.t = t
		self.v = v
		self.module.savePtr(v)

	def __dealloc__(self):
		self.module.freePtr(self.v)

cdef class GoSlice:
	def __cinit__(self, GoModule module, unsigned long data, long len, long cap):
		self.module = module
		self.data = data
		self.len = len
		self.cap = cap
		self.module.savePtr(data)

	def __dealloc__(self):
		self.module.freePtr(self.data)

