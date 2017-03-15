
all: exampleGoModule.so

exampleGoModule.so: mod.go
	go build -buildmode=c-shared -o $@ $+

