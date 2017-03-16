.PHONY: all test clean

lib=pyEasyGo

all:
	python setup.py build_ext --inplace

test: all
	python test.py

clean:
	rm -rf build
	rm -rf *.so
	rm -rf *~ $(lib)/*~
	rm -rf $(patsubst %.pyx,%.c,$(wildcard $(lib)/*.pyx))
	rm -rf $(lib)/*.so $(lib)/*.pyc exampleGoModule/*~ exampleGoModule/*.h exampleGoModule/*.so

