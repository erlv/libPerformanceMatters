# Optimization based on CPU Architecture Notes
## The code of the software
虽然写的是C代码，但是程序员实际是在指定处理器要执行的指令序列. 为了提升性能，CPU设计工程师几十年来都在调优CPU架构，提升频率，增加指令级并行。

我们需要优化我们的C代码（确切的说是在处理器上执行的指令序列），使得它能充分利用底层CPU提供的指令集并行支持，缩短我们代码的运行时间，提升程序性能。

## The design of CPU architecture

### The importance of Instruction Pipeline

 CPU X86 I7， ARM Cortex-A7微架构

## Why we need optimization based on the architecture?
硬件已经确定，软件代码可以频繁修改。


## The Memory Hierarchy of the Computer Architecture

### Cache

### Memory

### Hard Disk


### Why we need optimization based on the memory hierarchy


## The normal Operation cost supported by CPU




## How to Optimize the code

### Instruction Level Parallelism
#### Out-of-Order VS Very Long Instruction Word
Out-of-Order(OoO) relys on hardware support in CPU to improve ILP. While Very Long Instruction Word(VLIW) relies more on compiler dependence analysis to figure out the instructions which do not have dependece and could run simutaniously. 

OoO consumes more power while running, VLIW needs a powerful compiler which is hard to implement and maintain.

#### General Optimizations for ILP


### Data-Level Parallelism
CPU SIMD Instruction Extension
- ARM Neon
 - 128bit SIMD register. 
  - 2-way 64bit double/int64_t
  - 4-way 32bit float/int32_t
  - 8-way 16bit int16_t
  - 16-way 8bit int8_t
 - Designed like DSP instruction set.
 - Additional compiler type check based on the vector types
- Intel SSE/AVX/AVX512
 -  128bit SIMD SSE register/256bit SIMD AVX register/ 512bit SIMD AVX512 register
  - 128bit/256bit integer
  - 128bit/256bit 4-way/8-way float
  - 128bit/256bit 2-way/4-way double
 - Designed like register operation instruction set.
 - The type checking only based on the whole register type.
 
#### C Intrinsic VS Embeded Assembly

 C Intrinsics could generally get the same performance improvement if we write the code correctly, since most of the time we are optimizing hot functions and loops. In most of the case we rely on SIMD extensions to optimize the code, and compiler already have intrinsic/type support for such kind of extension.

 compiler could also help to do type checking, register allocation, instruction scheduling based on the C code as well. Usually the ABI could be handled correctly as well. While if we use assembly, we need to maintain the ABI by ourselves.
 
 Since the compiler is used to generate assembly finaly, and meanwhile compiler have limitations about program analysis and optimization, hand tuned assembly could have better performance sometimes.
 


### Thread-Level Parallelism



## Performance Tuning Tools
Let's take the following code as an example.

```c++
#include <stdio.h>
#include <stdlib.h>

int a(void) {
  int i=0,g=0;
  while(i++<100000) {
     g+=i;
  }
  return g;
}
int b(void) {
  int i=0,g=0;
  while(i++<400000) {
    g+=i;
  }
  return g;
}

int main(int argc, char** argv) {
   int iterations;
   iterations = 50000; 
   printf("No of iterations = %d\n", iterations);
   while(iterations--) {
      a();
      b();
   }
}
```

### gprof
Gprof provide an easy way to quickly find out the hot function in your program. It works on both X86 and ARM platform. Gprof will increase your program run time by around 30%.

```bash
$ gcc -pg hello.c -o hello.o
$ gcc -pg hello.o -o hello.exe
$ ./hello.exe # A new gmon.out file will be generated here.
$ gprof hello.exe > hello.exe.log
```
gprof is a good tool to get the hot function while the program is running. It is done by:
- compile and link with `-pg` option to make your program support gprof
- Compiler Inserts code at the head and tail of each function in your program.
- Linker will also try to link the standard library with `-pg` support.

`gmon.out` file contain the timing information. `gprof` command will read the `gmon.out` file automatically, and get the information about hot functions.

### Oprofile


### Compiler Options

### Assembly analysis

