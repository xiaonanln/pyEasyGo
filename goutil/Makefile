.PHONY: all

all: goutil.so

goutil.so: goutil.go
	go build -buildmode=c-shared -o $@ $+

