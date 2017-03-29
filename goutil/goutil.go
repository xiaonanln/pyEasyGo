package main

import (
	"fmt"
	"log"
	"runtime"
	"unsafe"
)

import "C"

var (
	savedPtrs = map[unsafe.Pointer]bool{}
)

func init() {
	log.Println("Loading goutil ...")
}

//export GC
func GC() {
	runtime.GC()
}

//export SavePtr
func SavePtr(ptr unsafe.Pointer) {
	log.Println("Saving Go pointer", ptr, "...")
	savedPtrs[ptr] = true
}

func main() {
	fmt.Println("vim-go")
}
