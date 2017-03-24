import os

cdef int _save_cgocheck = -1

cdef int cgocheck():
	global _save_cgocheck
	if _save_cgocheck == -1:
		_save_cgocheck = _get_cgocheck()
		print 'cgocheck=', _save_cgocheck
	return _save_cgocheck

cdef int _get_cgocheck():
	cdef str godebug = os.getenv('GODEBUG', '')
	for sp in godebug.split(' ')[::-1]:
		if not sp.startswith('cgocheck='): continue 
		
		return int(sp[9:])
	# cgocheck not found, by default it's 1
	return 1

