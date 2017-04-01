import sys
import time
from traceback import print_exc
import pyEasyGo as ego

gmod = ego.GoModule("exampleGoModule/exampleGoModule.so")
print gmod
gmod.TestVoid()
gmod.TestInt(1234)
#try: gmod.TestInt(1234.54); assert False
#except TypeError: pass
try: gmod.TestInt("abc"); assert False
except TypeError: pass

gmod.TestInt(0x7fffffff)
gmod.TestInt(0x7fffffff+1)
gmod.TestInt(0x7fffffffffffffff)
gmod.TestInt(-0x7fffffffffffffff-1)
try:gmod.TestInt(0x7fffffffffffffff+1)
except OverflowError: pass
try: gmod.TestInt(-0x7fffffffffffffff-2)
except OverflowError: pass

gmod.TestString("abcd")
gmod.TestString(u'hoho')
try: gmod.TestString(1); assert False
except TypeError: pass 

ret = gmod.TestCString("abc")
print >>sys.stderr, 'TestCString', ret

# test return values
retVal = gmod.TestReturnVal('world', 5)
print >>sys.stderr, 'ReturnVal', repr(retVal)

retVal = gmod.TestReturnString('hello', 3)
print >>sys.stderr, 'TestReturnString ==>', retVal

try: gmod.UsingAllTypes(); assert False
except TypeError: pass

print >>sys.stderr, 'TestFloat32', gmod.TestFloat32(3.0)
print >>sys.stderr, 'TestFloat64', gmod.TestFloat64(1000000000000.1111111111111111111111111)
print >>sys.stderr, 'TestComplex64', gmod.TestComplex64(1.1)
print >>sys.stderr, 'TestComplex128', gmod.TestComplex128(1.2)

ptrs = []
for _ in xrange(10):
	vptr = gmod.TestVoidPtr(100)
	print >>sys.stderr, 'TestVoidPtr', vptr, repr(vptr), type(vptr)
	# gmod.__SavePtr(vptr)
	gmod.RunGC()
	gmod.TestWriteVoidPtr(vptr, 200)
	copyPtr = gmod.TestCopyVoidPtr(vptr)
	ptrs.append(copyPtr)
ptrs = []

########################################### test map ######################################

m = gmod.TestNewMap(3)
gmod.TestPrintMap(m)
gmod.TestSetMap(m, 100, 100)
gmod.TestPrintMap(m)

######################################### TEST CHAN #######################################

N = 3
ch = gmod.TestNewChan(N)
for i in xrange(N):
	gmod.TestPushChan(ch, i)
for i in xrange(N):
	print >>sys.stderr, 'pop', gmod.TestPopChan(ch)

########### TEST INTERFACE ####
ints = []
for _ in xrange(10):
	i = gmod.TestNewInterface()
	gmod.TestSetInterface(i, 100)
	gmod.TestSetInterface(i, 200)
	gmod.TestGetInterface(i)
	ints.append(i)
	gmod.RunGC()

ints = []





