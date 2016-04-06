# Code Optimizations
This page focus on how to modify/write our C/C++ or embedded assembly code to improve performance.

Why we need to know code optimization and do it manually even we already have advanced optimization compiler? 
Since the compiler could only do the code transformation when it can sure that the transformation is safe and benificial.
It is hard for it to ensure this for many circumstance, and then failed to optimize the code.


## How to do quantitive analysis on optimizations
Use speedup factor to show the performance changes.

`Speedup = Old_RunTime / New_RunTime`


## Only optimize your hotest code first
It is very important to firstly find out what part of the code takes most of the runtime, and do not forget to make sure the code is only CPU-intensive or memory-intensive otherthan network-intensive or disk-intensive. Amdahl's Law shows that when we speed up one part of a system, the effect on the overall system performance depends on both how significant this part was and how much it sped up.

Currently libPerformanceMatters only cares about CPU-intensive and Memory-intensive applications.

[Performance Tuning Tools](https://github.com/erlv/libPerformanceMatters/blob/master/docs/3_performance_tuning_tools.md) are the good start to findout the hotest code.




## Get rid of redundant operations
Is there any computations inside the loop redudant? Or could be moved outside of the loop?

```c++
void foo(int32_t *a, int32_t *b, uint32_t len, uint32_t offset) {
    int i;
    for(i=0; i < offset; i++) {
        b[i] = a[i+offset+2];
    }
    return 0;
}

void foo_opt(int32_t *a, int32_t *b, uint32_t len, uint32_t offset) {
    int i;
    int temp = offset+2;
    for(i=0; i < offset; i++) {
        b[i] = a[i+temp];
    }
    return 0;
}

void foo2(int32_t *a, uint32_t len, int32_t *sum) {
    int i =0;
    *sum = 0;
    for (i=0; i < len; i++) {
        *sum += a[i]; // additional load/store is needed for sum.
    }
}

void foo2_opt(int32_t *a, uint32_t len, int32_t *sum) {
    int i =0;
    *sum = 0;
    int temp = *sum;
    for (i=0; i < len; i++) {
        temp += a[i]; // No additional load/store anymore
    }
    *sum = temp;
}
```
 

### Increasing DLP

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


## C Intrinsic VS Embeded Assembly

 C Intrinsics could generally get the same performance improvement if we write the code correctly, since most of the time we are optimizing hot functions and loops. In most of the case we rely on SIMD extensions to optimize the code, and compiler already have intrinsic/type support for such kind of extension.

 compiler could also help to do type checking, register allocation, instruction scheduling based on the C code as well. Usually the ABI could be handled correctly as well. While if we use assembly, we need to maintain the ABI by ourselves.
 
 Since the compiler is used to generate assembly finaly, and meanwhile compiler have limitations about program analysis and optimization, hand tuned assembly could have better performance sometimes.


### Function Inlining to improve ILP and instruction scheduling
 

### Optimizations for branch and jmp instructions

#### use conditional move instead of if-then-else

For the following code, the function body of `min_opt` usually will be transformed into conditional move instructions.

For the function body of `min`, if turned on higher level optimizations, usually compiler could automatially turn into
conditional move instruction as well, but defaultly conditional branch instruction should be generated here.

```c++
int32_t min( int32_t a, int32_t b) {
    if (a < b) 
        return a;
    else
        return b;
}

int32_t min_opt( int32_t a, int32_t b) {
    return a < b? a : b; //conditional move will be used here instead of conditional branch instructions
}

```

#### Traps: Do not overly concerned about predicable branches
Usually the advanced branch prediction logic could make the correct guess about the branch. And even it is mispredicated,
usually the percentage is not very high. But once it hurts the performance, the instruction will be flushed, it will waste
tens of cycles.


### Loop unrolling to improve ILP on OoO processor


### Loop Tiling for memory access optimizations

### Other loop optimizations

#### Software Pipeline

#### Loop interchange

#### Loop Fussion/Fission/Spilt

### Code Size Optimizations


### Optimizations for VLIW Processor (DSP)

#### Instruction Bundling

#### Advanced Software Pipeline

