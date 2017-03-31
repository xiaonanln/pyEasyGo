package main

import (
	"fmt"
	"runtime"
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

//export TestFloat32
func TestFloat32(f float32) float32 {
	return f * f
}

//export TestFloat64
func TestFloat64(f float64) float64 {
	return f * f
}

//export TestComplex64
func TestComplex64(comp complex64) complex64 {
	fmt.Printf("GO: TestComplex64 %v => %v\n", comp, comp*comp)
	return comp * comp
}

//export TestComplex128
func TestComplex128(comp complex128) complex128 {
	fmt.Printf("GO: TestComplex128 %v => %v\n", comp, comp+comp)
	return comp + comp
}

//export TestCString
func TestCString(s *C.char) *C.char {
	gos := C.GoString(s)
	gos = gos + gos
	fmt.Println("GO: TestCString!", gos)
	return C.CString(gos)
}

//export RunGC
func RunGC() {
	fmt.Println("GO: GC ...")
	runtime.GC()
}

//export TestVoidPtr
func TestVoidPtr(i int) unsafe.Pointer {
	p := unsafe.Pointer(&i)
	// safePtrs[p] = true
	return p
}

//export TestWriteVoidPtr
func TestWriteVoidPtr(p unsafe.Pointer, v int) {
	pi := (*int)(p)
	oldv := *pi
	*pi = v
	fmt.Println("Write VoidPtr", pi, oldv, v)
}

//export TestCopyVoidPtr
func TestCopyVoidPtr(p unsafe.Pointer) unsafe.Pointer {
	return p
}

//export TestSetMap
func TestSetMap(a map[int]int, k, v int) map[int]int {
	a[k] = v
	return a
}

//export TestGetMap
func TestGetMap(a map[int]int, k int) int {
	return a[k]
}

//export TestPrintMap
func TestPrintMap(m map[int]int) {
	fmt.Printf("TestPrintMap %v\n", m)
}

//export TestNewMap
func TestNewMap(n int) map[int]int {
	m := map[int]int{}
	for i := 0; i < n; i++ {
		m[i] = i * i
	}
	return m
}

//export TestNewChan
func TestNewChan(cap int) chan int {
	ch := make(chan int, cap)
	return ch
}

//export TestPushChan
func TestPushChan(ch chan int, v int) {
	ch <- v
}

//export TestPopChan
func TestPopChan(ch chan int) int {
	return <-ch
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

//export UsingAllTypes
func UsingAllTypes(byte, int, rune, uint8, int8, uint16, int16, uint32, int32, uint64, int64, uint, uintptr, float32, float64, complex64, complex128, string, map[int]int, chan int, interface{}, []int) (r1 byte, r2 int, r3 rune, r4 uint8, r5 int8, r6 uint16, r7 int16, r8 uint32, r9 int32, r10 uint64, r11 int64, r12 uint, r13 uintptr, r14 float32, r15 float64, r16 complex64, r17 complex128, r18 string, r19 map[int]int, r20 chan int, r21 interface{}, r22 []int) {
	return
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
