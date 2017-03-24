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
try:gmod.TestInt(0x7fffffffffffffff+1); assert False
except OverflowError: pass
try: gmod.TestInt(-0x7fffffffffffffff-2); assert False
except OverflowError: pass

gmod.TestString("abcd")
gmod.TestString(u'hoho')
try: gmod.TestString(1); assert False
except TypeError: pass 

# test return values
retVal = gmod.TestReturnVal('world', 5)
print 'ReturnVal', repr(retVal)

retVal = gmod.TestReturnString('hello', 3)
print 'TestReturnString ==>', retVal

try: gmod.UsingAllTypes(); assert False
except TypeError: pass
