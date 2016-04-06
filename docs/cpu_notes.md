# Optimizations based on CPU Micro Architecture
## Introduction

Although we are writing C/C++ or higher language code, we are in fact specifing the instruction sequences a processor/computer should do. Therefore to improve the performance, we need to make our instruction sequences run as fast as it could.

For this page, we only focus on Instruction Level Parallel, which basically based on the single core/micro-architecture of the processor to improve the performance, while for other level of performance improvement,  there will be several different pages/posts for them.

To improve the performance, the CPU designers trys to improve the CPU microarchitecture for decades, not only by increase the frequency of the processor, but also by increasing the ILP (Instruction Level Parallel).

We need to optimize our code ( the instruction sequences) to take advantage of the underlying CPU's ILP support.


## The design of CPU architecture

### A simplest CPU design
Typically, The program should run like the following way in a CPU:

1. Load the executable file into main memory
2. Set the `$PC` register to the start address of the `.text` section in the memory
3. While `$PC` != end address of `.text` section
 1. Load the data from memory address in `$PC` to CPU 
 2. Decode the instruction, figure out the registers which the instruction will use/def, and also the immediate numbers or memory locations in the instruction if necessary
 3. Execute the instruction operation
 4. write the result back to the register/ memory
 5. Add `$PC` by 4 (usually)

Our simplest CPU at least should support:

1. Instruction Fetch
2. Instruction Decoding
3. Instruction Execution
4. Instruction WriteBack
5. Update `$PC` register when necessary.

For a single instruction it should run through the following graph.

![Instruction execution steps](https://upload.wikimedia.org/wikipedia/commons/9/9e/Pipeline_MIPS.png)

###  The importance of Instruction Pipeline
For each instruction, we need all the above 5 steps, while only step 3 is the execution, and only step 4 could reflect the whole processor's state since only at this point we could get the values updated.

If each step takes 1 cycle to finsh, the whole instruction execution will take 5 cycles.


### The evolution of Intel X86 Micro Architecture


### The evolution of ARM Cortex Micro Architecture

## Why we need optimization based on the architecture?


## The Memory Hierarchy of the Computer Architecture

### Cache

### Memory

### Hard Disk


### Why we need optimization based on the memory hierarchy


## The normal Operation cost supported by CPU
Following is the table based on the X86 CPU.
- Typical Latency:  how many cycles the instruction will takes
- Typical Reciprocal Throught: The reciprocal of how many same instructions could be run simutanously if there is no dependence among them.
 

Operation | Typical latency  | Typical reciprocal throughput
--------- | ---------------- | ------------------------------
Int move | 1 | 0.33 - 0.5
Int add | 1 | 0.33 - 0.5
Int Boolean | 1 | 0.33 - 1
Int shift | 1 | 0.33 - 1
Int Mul | 3 - 10 | 1 - 2 
Int Div | 20 - 80 | 20 - 40
FP add | 3 - 6 | 1
FP Mul | 4 - 8 | 1 - 2
FP Div | 20 - 45 | 20 - 45
SIMD int add | 1 - 2 | 0.5 - 2
SIMD int Mul | 3 - 7 | 1 - 2
SIMD FP add | 3 - 5 | 1 - 2
SIMD FP Mul | 4 - 7 | 1 - 2
SIMD FP Div | 20 - 60 | 20 - 60
Mem read (cached) | 3 - 4 | 0.5 - 1
Mem write (cached) | 3 - 4 | 1
Jump or call | 0 | 1 - 2


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
Oprofile could not only tell you the hot function, but also a lot of performance counter values which are very useful to find out why the program runs slowly.

- [Performance Counters which oprofile can tell you on ARM Cortex-A7](http://oprofile.sourceforge.net/docs/armv7-ca7-events.php)
- [Performance Counters which oprofile can tell you on Intel Broadwell](oprofile.sourceforge.net/docs/intel-broadwell-events.php)
- [A list of CPUs Oprofile currently support](http://oprofile.sourceforge.net/docs/)

The performance counters are usually the counters supported by the microarchitecture. Different microarchitecture might have different performance counters, but usually the following counters are useful on most of the platform.
- L1/L2/L3 Cache Hit/Miss/Refill/Access
- TLB refill
- Branch predictable run/ Branch miss predicated
- CPU clock
- etc

Oprofile have a rich support on X86 platform, but on ARM Linux, especially Android, the support is very limited. But it is also very helpful to get an idea about the performance feature of the program.

### Assembly analysis
Basically, no matter what kind of platform you are try to run your program, assembly is the most straight forward way to know how your program will run on the platform. And for C/C++ language and embeded assembly, compiler will turn all the code in your program into assembly code at first before your program could be run.

assembly is the instruction sequence of your code. It is the intermediate level of your code to understand how your program will run on the platform. Therefore, you are highly recommanded to figure out the assembly code of your code especially the hot function while tunning performance.

`objdump -S` and `gcc -S` are two ways to get the assembly. The difference between these two tools is that:
 - `objdump -S` directly analyse the binary (executable or object) file, and get the instruction sequences which will be executed.
 - `gcc -S` generated assembly by the `gcc` compiler. `gcc` compiler analyse the C code, and based on the C code and the target architecture to generate assembly.
 - `as` eats the compiler generated assembly, and then generate object file which could be used by `objdump -S`. Sometimes, on some architecture, `as` might automatically expand assembly macro into multiple instructions, or combine several instructions into an assembly macro. We could treat `objdump -S` generated assembly as the final assembly.

### Compiler Options

## Reference
- [Oprofile](http://oprofile.sourceforge.net/news/)
- [Gprof](https://users.cs.duke.edu/~ola/courses/programming/gprof.html)
- [Optimizing subroutines in assembly language An optimization guide for x86 platforms By Agner Fog](www.agner.org/optimize/optimizing_assembly.pdf)
