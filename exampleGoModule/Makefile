.PHONY: all test

all: exampleGoModule.so

exampleGoModule.so: mod.go
	go build -buildmode=c-shared -o $@ $+

test: exampleGoModule.so
	python test.py

