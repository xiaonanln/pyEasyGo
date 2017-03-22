
cdef class GoType:
	cdef str s

cdef class GoFuncDecl:
	cdef GoType retType
	cdef str funcName
	cdef tuple argList

	cdef tuple convertArgs(self, tuple args)
	cdef object restoreReturnVal(self, object ret)
	cdef getResType(self)

cdef class GoHeader:
	cdef str path
	cdef dict funcDecls 
	cdef GoFuncDecl getFuncDecl(self, str funcName)
