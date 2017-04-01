import sys
import time
from traceback import print_exc
import pyEasyGo as ego

gmod = ego.GoModule("exampleGoModule/exampleGoModule.so")
gomap = gmod.NewMapIntInt(0)
pymap = {}

def testPerf(m, N):
	t0 = time.time()
	for i in xrange(N):
		m[i] = i
	
	for i in xrange(N):
		del m[i]
	print 'takes', time.time() - t0


N = 100000
testPerf(gomap, N)
testPerf(pymap, N)

