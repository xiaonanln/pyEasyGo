import cProfile
import sys
import time
from traceback import print_exc
import pyEasyGo as ego
import gc
import random

gmod = ego.GoModule("exampleGoModule/exampleGoModule.so")
gomap = gmod.NewMapIntInt(0)
pymap = {}

def profilePyMap(n):
	m = {}
	for i in xrange(n):
		m[i] = random.randint(0, i)
	
	for i in xrange(n):
		del m[i]

def main():
	n = 100
	while True:
		t0 = time.time()
		profilePyMap(n)
		t1 = time.time()
		gmod.ProfileMap(n)
		t2 = time.time()
		print >>sys.stderr, 'PYTHON: %f, GO: %f' % (t1 - t0, t2 - t1)
		n *= 2
		gmod.GC()
		gc.collect()

main()

