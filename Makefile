.PHONY: all test clean pyEasyGo exampleGoModule install

lib=pyEasyGo

all: exampleGoModule pyEasyGo
	
exampleGoModule:
	cd exampleGoModule; make

pyEasyGo:
	python setup.py build_ext --inplace

test: all
	python test.py

perf: all
	python perf.py

clean:
	python setup.py clean
	rm -rf build
	rm -rf *.so
	rm -rf *~ $(lib)/*~
	rm -rf $(patsubst %.pyx,%.c,$(wildcard $(lib)/*.pyx))
	rm -rf $(lib)/*.so $(lib)/*.pyc exampleGoModule/*~ exampleGoModule/*.h exampleGoModule/*.so

install:
	python setup.py install
