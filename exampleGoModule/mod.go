package main

import (
	"fmt"
	"unsafe"
)

import "C"

//export Test1
func Test1() {
	fmt.Println("GO: Test1!")
}

//export Test2
func Test2(a int) {
	fmt.Println("GO: Test2!", a)
}

//export Test3
func Test3(a string) {
	fmt.Println("GO: Test3!", a)
}

//export Test4
func Test4(a interface{}) {
	fmt.Println("GO: Test4!", a)
}

//export Test5
func Test5(a **int, b int) **int {
	fmt.Println("GO: Test5!", a, *a)
	return a
}

//export TestCString
func TestCString(s *C.char) *C.char {
	fmt.Println("GO: TestCString!", C.GoString(s))
	return s
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
