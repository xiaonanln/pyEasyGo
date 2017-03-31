from GoModule cimport GoModule

cdef class GoPointer:
	cdef GoModule module
	cdef unsigned long ptr

cdef class GoMap:
	cdef GoModule module
	cdef unsigned long ptr

cdef class GoChan:
	cdef GoModule module
	cdef unsigned long ptr
