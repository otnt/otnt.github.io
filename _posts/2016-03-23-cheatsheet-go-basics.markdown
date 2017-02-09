---
layout:     post
title:      "A cheatsheet on basic of Go language"
subtitle:   ""
post-date:       2016-03-23 16:09 
update-date:       2016-03-23 16:09 
tags:
    - Go
---

- Quoted from:
 1. [Getting Started](https://golang.org/doc/install)
 2. [A Tour of Go](https://tour.golang.org/welcome/1)
 3. [How to Write Go Code](https://golang.org/doc/code.html)

## Cheatsheet

**0.Entry point**

Go program starts from package main.

**1.Export**

Capitalized function is exported. Non-capitalized function isn’t exported.

**2.Variable type is at end of declaration.**

```go
var a int = 3
a int := 3
```

**3.Basic types.**

```go
bool, string
int  int8  int16  int32  int64
uint uint8 uint16 uint32 uint64 uintptr
byte // alias for uint8
rune // alias for int32, represents a Unicode code point
float32 float64
complex64 complex128
```

**4.Output type of a variable.**

```go
printf("%T", variable)
```

**5.Type conversion/casting.**

```go
new_type(variable)
```

**6.const**

```go
const name = value
```

**7.Group of definition or import.**

```go
var/const (
  x = 1
  y = 2
)
import (
  "package 1"
  "package 2"
)
```

**8.Function with multiple return value.**

```go
func name(x int, y int) (int, int) {
  return 1, 2
}
```

**9.Switch 1**

Switch use ``fallthrough`` as key word to let two consecutive cases run sequentially. In Go, we don't use ``break`` key word to terminate switch cases, they stop automatically.

**10.Switch 2**

Value of switch case could be any type, even function value is okay. Using switch without a condition is okay, then the switch case takes some boolean value, this is useful for concise if-else combination.

**11.Defer**

The deferred call's arguments are evaluated immediately, but the function call is not executed until the surrounding function returns. When there are multiple defer functions, they are stacked in a FILO pattern.

**12.Pointer**

Pointer is like c-style, but do not support pointer arithmetic.

**13.Struct**

```go
type Name struct {
  x int
  y int
}
name := Name{x:1, y:2}
name.x
p = &name
p.x is okay!
```

**14.Array**

```go
var name [10]int
name := [3]int{1,2,3}
name := […]int{1,2,3} //same effect as previous statement
len(name)
cap(name) //capacity
```

**15.Slice**

Slice is similar to array, but more flexible! Array is fixed sized, while size of slice could be modified. It is built on top of array, which is very similar to list in Java.

Internal of slice is a pointer to a position in an array, the length, the capacity.

Slice could be create by make

```go
name := make([]int, length)
name := make([]int, length, capacity)
name := make([]int, 0, 5) //an array with capacity 5 and length 0, initialized all value 0
```

or by slicing an array or slice

```go
name[1:3] //have value at position 1,2. name could be an array or slice
name[1:]
```

When creating slice by slicing, the data is not copied! just modify the pointer

And notice, when slicing, the length is determined by slice range, but the capacity is determined by maximum range which is from slice range begin to end of underlying array.

Notice, this may cause problem because we may only need part of the array, but we are keeping the whole array in memory. So sometimes it would be better to copy that part, or other method such as append part of array to a ``nil`` array, to let garbage collector reclaim those memory.

https://blog.golang.org/go-slices-usage-and-internals

**16.Slice is initialized as nil**

```go
var name []int
name == nil //true
len(name) //0
cap(name) //0
```

**17.Slice copy/append**
Slice could be copied between different lengthy,  or even underlying overlapped slices.

```go
copy(destination, source)
```
this will copy elements of smaller number in ``source`` and ``destination``.

```go
var name = []int{1,2,3}
append(name, 1, 2, 3)

var name2= []int{4,5,6}
append(name, name2…) //could append another slice. notice the … would unwrap the second slice
```

**18.Array/slice range**

A convenient way to iterate element in array and slice.

```go
for index, value := range arrayName {
  //notice value is a copy of the element
}
```

Could skip the value, then

```go
for index := range arrayName {}
```

Or could skip index, then

```go
for _, v := range array {}
```

**19.Map**

Map must be created using make.

```go
var name = make(map[key_type] value_type)
var map = make(map[string] int)
```

Or could be initialized like JSON.

```go
var map = make(map[string] int) {
  "key1":10,
  "key2":20, //notice the commas is necessary!
}
```

Map operation is usual.

```go
map[key] = value
value, ok = map[key] //ok is true if key exist
delete(map, key)

for key, value := map {
  //iterate map
}
```

**20.Function as first class**

Could pass function as a parameter.

```go
func name(fn func(x, y int) int) int {}
```
Notice all function argument is value copy. Not reference.

Also, function has closure.

**21.Class**

Go doesn't have built-in class. But we could use function to help variable to act like a class.

We should assign a *receiver* type to a function, then any variable of this receiver type could call this function. So it looks like the receiver type is a class, variable is an object, and the function is a member function.

```go
var (f MyFloat) Abs() float64 {}//MyFloat is receiver type
var Abs(f MyFloat) float64{} //function-wise same
```

But receiver could only be type defined in the same package. So could not set receiver as built-in type, including ``int``, ``float`` etc.

Receiver could be pointer. This does not require the variable calling this function to be a pointer. It means the value of receiver is not copied to the function, instead a reference is given so that the function could modify the value of receiver. Though use a pointer as receiver variable to call function is recommended!

```go
var (f *MyFloat) Abs() {} //now Abs could directly modify f in its body
```

All methods on a given type should have either value or pointer receivers, but not a mixture of both. (This is a design matter)

**22.Interface**

```go
type name interface {
  functionName(argument) return_type
}
```

``name x`` could be any type that support the function.

Empty interface acts like ``void*`` in C language.

```go
var i interface{} //empty interface, i is nil after created
i = “aa"
i = 43 //both are correct
```

Because the interface could be assigned to any concrete variable, sometimes we want to know what’s underlying concrete type.

```go
var i interface{} = "hello"
s := i.string //s will be “hello"
f := i.float64 //run time error
f, ok := i.float64 //no error, ok would be false
```

**23.Switch 3**

Switch could be used to switch types.

```go
switch v:= i.(type) {
case T:
case S:
default:
}
```

**24.Stringer interface**

A built-in interface, similar to ``toString()`` in Java.

```go
type Stringer interface {
  String() string
}
```

**25.Error**

Every built-in function return an error as last parameter.

```go
return_value, err = function_name()
if err == nil {} else {}
```

**26.IO Reader**

Reader is an input stream.

```go
import {
  "io"
  "strings"
}
r := strings.NewReader("Hello, Reader!")
b := make([]byte, 8)
n, err := r.Read(b)
if err == io.EOF {
  break
}
```

**27. Routine**

Routine is like thread in other languages. You run a function in another thread.

```go
go fun_name(parameters)
```

This starts a new goroutine/ light-weight thread. The parameters are evaluated when executing this line, i.e. current goroutine, but execution of the function is happen in the new goroutine, i.e. in the future.

These go routines run in same address space, so that access to shared memory need synchronized.

**28.Rendezvous channel**

Rendezvous means synchronized. A rendezvous channel is a channel without defining size, so that the sender and receiver would be synchronized all the time.

```go
var channel = make(chan int)
channel <- v  //offer v into channel, block until v is taken from receiver
v := <- channel //take v from channel, block until sender offer a value into channel
```

**29.Buffered channel**

Buffered channel is channel with a defined capacity. So the sender and receiver could act like producer consumer model, where the channel acts like a queue with fixed size.

```go
var channel = make(chan int, capacity)
channel <- v //sender be blocked when channel full
v := <- channel //receiver blocked when channel empty
cap(channel) //capacity
```

**30.Channel close and check**
Sender *could*  and only sender *should* close channel 

```go
close(channel)
```

Receiver could check whether channel is closed by

```go
v, ok := <- channel
```

A channel could be iterated using range.

```go
for i:= range(channel) {
  //i is element in channel
}
```

when channel is closed, this iteration will stop.

**31.Select**
Select a random executable statement to run. Notice each case statement should interact with a channel.

```go
select {
  case c <- x://executable when channel is not full
  case <- c: //executable when channel is not empty
  default ://executable when channel is neither full nor empty
}
```

**32.sync.Mutex**

Go provide built-in mutex acting as lock. Though it suggests design pattern to do concurrency without locks.

```go
mux sync.Mutex
mux.Lock()
//do something
mux.Unlock()
```

**33.Share memory by communicating**

> Don't communicate by sharing memory; share memory by communicating.

[Go blog: shareemem codewalk](https://golang.org/doc/codewalk/sharemem/)

A naive interpretation: Do not use lock and shared memory, as a method to communicate among threads. Instead, use channel as communication tool, and share data among threads without lock.

**34.Go syntax**

> A good post talking about why's the similarity and difference between Go syntax and C syntax.

[Go blog: Go's declaration syntax](https://blog.golang.org/gos-declaration-syntax)

**35.Defer, panic, recover**

> A defer statement pushes a function call onto a list. The list of saved calls is executed after the surrounding function returns. Defer is commonly used to simplify functions that perform various clean-up actions.
> 
> 1. A deferred function's arguments are evaluated when the defer statement is evaluated.
> 
> 2. Deferred function calls are executed in Last In First Out order after the surrounding function returns.
> 
> 3. Deferred functions may read and assign to the returning function's named return values.
> 
> This is convenient for modifying the error return value of a function
> 
> <br>
> 
> Panic is a built-in function that stops the ordinary flow of control and begins panicking. When the function F calls panic, execution of F stops, any deferred functions in F are executed normally, and then F returns to its caller. To the caller, F then behaves like a call to panic. The process continues up the stack until all functions in the current goroutine have returned, at which point the program crashes. Panics can be initiated by invoking panic directly. They can also be caused by runtime errors, such as out-of-bounds array accesses.
> 
> <br>
> 
> Recover is a built-in function that regains control of a panicking goroutine. Recover is only useful inside deferred functions. During normal execution, a call to recover will return nil and have no other effect. If the current goroutine is panicking, a call to recover will capture the value given to panic and resume normal execution.

[Go blog: defer panic and recover](https://blog.golang.org/defer-panic-and-recover)

**36.Test**

Go provides a built-in test platform.

The convention is:

1. Within the package, have a go file named XXX__test.go
2. Within this go file, have functions named TestXXX.go
3. The test function should have format as
  
  ```go
  func TestXXX(t *testing.T) {}
  ```
  
4. Import package ```"testing"```
5. Use [test functions](https://golang.org/pkg/testing/) to indicate error. This including

```go
t.Error
t.Errorf
t.Fail
```
