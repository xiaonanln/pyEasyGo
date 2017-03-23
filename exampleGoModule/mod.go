package main

import (
	"fmt"
	"unsafe"
)

import "C"

//export TestVoid
func TestVoid() {
	fmt.Println("GO: TestVoid!")
}

//export TestInt
func TestInt(a int) {
	fmt.Println("GO: TestInt!", a)
}

//export TestString
func TestString(a string) {
	fmt.Println("GO: TestString!", a)
}

//export TestReturnString
func TestReturnString(s string, n int) string {
	ss := ""
	for i := 0; i < n; i++ {
		ss += s
	}
	fmt.Println("GO: TestReturnString", ss[3:10])
	return ss[3:10]
}

//export TestReturnVal
func TestReturnVal(_s *C.char, n int) *C.char {
	s := C.GoString(_s)
	ss := ""
	for i := 0; i < n; i++ {
		ss += s
	}
	fmt.Println("GO: TestReturnVal", ss)
	return C.CString(ss)
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
