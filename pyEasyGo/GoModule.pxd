
from GoHeader cimport GoHeader
from goDataTypes cimport GoMapIntInt

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
	cpdef GoMapIntInt NewMapIntInt(self, long cap)


