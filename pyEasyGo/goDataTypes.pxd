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

cdef class GoInterface:
	cdef GoModule module
	cdef unsigned long t
	cdef unsigned long v

cdef class GoSlice:
	cdef GoModule module 
	cdef unsigned long data
	cdef long len
	cdef long cap

