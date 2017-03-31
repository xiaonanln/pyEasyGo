from GoModule cimport GoModule

cdef class GoPointer:
	cdef GoModule module
	cdef unsigned long ptr
