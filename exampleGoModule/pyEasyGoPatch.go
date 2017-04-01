package main

import (
	"runtime"
	"unsafe"
)

import "C"

var (
	__savedPtrs = map[unsafe.Pointer]bool{}
)

//export __SavePtr
func __SavePtr(ptr unsafe.Pointer) {
	__savedPtrs[ptr] = true
}

//export __FreePtr
func __FreePtr(ptr unsafe.Pointer) {
	delete(__savedPtrs, ptr)
}

//export __GC
func __GC() {
	runtime.GC()
}

// implement map[int]int

//export __NewMapIntInt
func __NewMapIntInt(cap int) map[int]int {
	return make(map[int]int, cap)
}

//export __SetMapIntInt
func __SetMapIntInt(m map[int]int, k, v int) {
	m[k] = v
}

//export __GetMapIntInt
func __GetMapIntInt(m map[int]int, k int) (v int) {
	v = m[k]
	return
}

//export __DeleteMapIntInt
func __DeleteMapIntInt(m map[int]int, k int) {
	delete(m, k)
}

//export __GetLenMapIntInt
func __GetLenMapIntInt(m map[int]int) int {
	return len(m)
}
