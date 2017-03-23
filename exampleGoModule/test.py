import ctypes
from ctypes import *
import sys

so = cdll.LoadLibrary('exampleGoModule.so')
print >>sys.stderr, 'loaded', so

class _GoString(Structure):
	_fields_ = [("p", c_char_p), ("n", c_long)]

def GoString(s):
	return _GoString(s, len(s))
	
so.TestVoid()
so.TestInt(12345)
so.TestString(GoString("abc"))
so.TestString(GoString("123"))
so.TestCString(c_char_p("hello"))
so.TestReturnString(GoString("world"),2)
