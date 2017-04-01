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
