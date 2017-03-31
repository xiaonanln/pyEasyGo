
import sys

cdef class GoPointer:

	def __cinit__(self, GoModule module, unsigned long p):
		self.module = module
		self.ptr =  p
		self.module.savePtr(p)

	def __dealloc__(self):
		self.module.freePtr(self.ptr)
