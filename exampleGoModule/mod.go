package main

import (
	"fmt"
	"unsafe"
)

import "C"

//export Test1
func Test1() {
	fmt.Println("GO: Test!")
}

type T struct {
}

//export NewObject
func NewObject() interface{} {
	fmt.Println("GO: NewObject")
	return &T{}
}

//export NewObject2
func NewObject2() unsafe.Pointer {
	fmt.Println("GO: NewObject2")
	return unsafe.Pointer(&T{})
}

func (t *T) Method1() {
	fmt.Println("GO: Method1")
}

func init() {
	fmt.Println("GO: init")
}

func main() {
	fmt.Println("GO: main")
}
