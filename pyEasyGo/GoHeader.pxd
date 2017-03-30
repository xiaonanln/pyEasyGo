from GoModule cimport GoModule

cdef class GoType:
	cdef str s
	cdef restype(self)
	cdef convert(self, object pv)
	cdef restore(self, GoModule module, object gv)
	cdef bint containsGoPointer(self)

cdef class GoFuncDecl:
	cdef GoType retType
	cdef str funcName
	cdef tuple argList

	cdef list convertArgs(self, tuple args)
	cdef object restoreReturnVal(self, GoModule module, object ret)
	cdef getResType(self)

	cdef validate(self)

cdef class GoHeader:
	cdef str path
	cdef dict funcDecls 
	cdef GoFuncDecl getFuncDecl(self, str funcName)
	cdef validate(self)
