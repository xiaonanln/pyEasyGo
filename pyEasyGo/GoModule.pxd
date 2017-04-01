
from GoHeader cimport GoHeader

cdef class GoModule:
	cdef object clib
	cdef str filePath
	cdef GoHeader header
	cdef object __SavePtr
	cdef object __FreePtr
	cdef object __GC
	cdef dict pointerRefCounts
	cdef bint patched

	cdef savePtr(self, unsigned long ptr)
	cdef freePtr(self, unsigned long ptr)
	cpdef void GC(self)


