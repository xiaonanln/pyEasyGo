import ctypes
from ctypes import *
import sys

so = cdll.LoadLibrary('exampleGoModule.so')
print >>sys.stderr, 'loaded', so

class _GoString(Structure):
	_fields_ = [("p", c_char_p), ("n", c_long)]

def GoString(s):
	return _GoString(s, len(s))
	
so.Test1()
so.Test2(12345)
so.Test3(GoString("abc"))
so.Test3(GoString("123"))
so.TestCString(c_char_p("hello"))
