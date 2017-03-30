.PHONY: all test clean

all: exampleGoModule.so

exampleGoModule.so: $(wildcard *.go)
	go build -buildmode=c-shared -o $@

clean:
	rm -rf *.h *.so

test: exampleGoModule.so
	python test.py

