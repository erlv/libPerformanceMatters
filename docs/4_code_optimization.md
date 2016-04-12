# Code Optimizations
This page focus on how to modify/write our C/C++ or embedded assembly code to improve performance.

Why we need to know code optimization and do it manually even we already have advanced optimization compiler?
Since the compiler could only do the code transformation when it can sure that the transformation is safe and benificial.
It is hard for it to ensure this for many circumstance, and then failed to optimize the code.

## Warning
Please firstly think about whether it is possible to improve your code from
the algorithm's side,  spend one or two days to find out the more efficient algorithm is better than spend one or two days simply tune your code only to take advantage of the underlying hardware.

## How to do quantitive analysis on optimizations
Use speedup factor to show the performance changes.

`Speedup = Old_RunTime / New_RunTime`


## Only optimize your hotest code first
It is very important to firstly find out what part of the code takes most of the runtime, and do not forget to make sure the code is only CPU-intensive or memory-intensive otherthan network-intensive or disk-intensive. Amdahl's Law shows that when we speed up one part of a system, the effect on the overall system performance depends on both how significant this part was and how much it sped up.

Currently libPerformanceMatters only cares about CPU-intensive and Memory-intensive applications.

[Performance Tuning Tools](https://github.com/erlv/libPerformanceMatters/blob/master/docs/3_performance_tuning_tools.md) are the good start to findout the hotest code.




## General Optimization Topics

### Get rid of redundant operations
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

### Loop Vectorization


#### Traps for Loop vectorization

##### Check the types for all the loop operations
```c++
char a[20];
int b[20];
void foo() {}
  int i=0;
  for(; i < 20; i++) {
    b[i] = a [i];
  }
}
```
When we say vectorize the loop by 4, it means the smallest type in the loop will be
run in 4-way parallelly. Since the CPU SIMD reigsters have fixed width, for wider types
in the loop, we need to split it into several SIMD variables, Otherwise there will be
correctness issues.

##### Be careful of unaligned memory access

```c++
int a[20];
int b[30];
void foo() {}
  int i=0;
  for(; i < 20; i++) {
    b[i+3] = a [i];
  }
}
```

Basically, aligned memory access is most efficient. For processor without unaligned
memory access support, there will be correctness issues if we vectorize the above loop.
Due to the hardware limitation, although current ARM (Cortex-A7) and X86 (SSE or later) already have unaligned load and store support, but it is slower than aligned load/store. Usually, to hardware it means one additional load/store operation.


##### Sometimes you might not get performance improvement


### Function Inlining to improve ILP and instruction scheduling

In C/C++, `inline` keyword is only a hint for compiler long time ago. In fact, previously, `inline`, `extern` and `static` are designed for linker, not compiler.

The tips of using `inline` keyword:
- `inline` is only useful in current `.c/.cpp` file if is not declared and defined in the header file, and meanwhile `lto` is not turned on.
- Use `inline` for small functions in the header file if you want
- Do not add `inline` to a function when you think your code could run faster if the compiler `inline`s it.
- If you really think inline the function could help to improve the perforance, and the compiler does not do it currently. use ` __attribute__((always_inline))`

#### Function Inlining VS Macro
Function Inlining could have most the advantages of Function-like Macro.
With inline function, Compiler can help to check the type matching for you,
and make the code easier to debug and more readable.

Only consider use macro for the following conditions:
- Lazy argument evaluation. `#define SELECT(f, a, b) ((f)? (a): (b))`. When use inline function,
  parm `b` need to be evaluated at first.
- Access to context. if you want to turn the parameter name into a string like `#arg`.
- Type independence code writing (C++ already have template for this).
  `#define max(a, b) ((a>b)? (a): (b))` .
- Need `return` in our macro: When use macro, the `return` stmt will still in the expanded code,
  while inline function can not keep it there.



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


### Loop Interchange for memory access optimization

```c++
/* Before */
for (j=0; j < 100; j++)
  for (i=0; i < 5000; i++)
     x[i][j] = 2 * x[i][j];
```
For each iteration of inner loop-i, we access the element of each column, which is not adjacent access of memory, and it is almost always cache miss.

The following code interchanged the loop, and then the array access is better by only access each adjacent element. Since the processor hardware will prefetch the adjacent data automatically from memory to cache, the code will always cache hit, and the performance could be improved a lot.

```c++
/* after */
for (i=0; i < 5000; i++)
  for (j=0; j < 100; j++)
    x[i][j] = 2 * x[i][j];
```


### Loop Tiling for memory access optimizations
Loop Tiling, AKA loop blocking, it tries to split the array access by small blocks, and make sure:
1. The data in the block will be accessed firstly.
2. The data could be hold in cache automatically.

For the following code, if N is not-so-small, it is hard for the cache to hold all three array `x[N][N]`, `y[N][N]` and `z[N][N]`.

```c++
/* Before */
for (i=0; i < N; i++)
  for(j=0; j < N; j++) {
    r = 0;
    for (k=0; k < N; k++) {
      r += y[i][k]* z[k][j];
    }
    x[i][j]=r;
  }
```

While N=6, and i=1, and j iterates in range [3, 6). Following is the 3 2-D arraies' access range:
- x: `x[1][3:]`
- y: `y[1][:]`x3
- z: `z[:][3:]`x3

There will be a lot of cache miss.

The following code is better:

```c++
/* After */
for(jj=0; jj < N; jj+=B)
  for(kk=0; kk < N; kk+=B)
    for(i=0; i < N; i++)
      for(j=jj; j < min(jj+B, N); j++) {
        r = 0;
        for(k=kk; k < min(kk+B, N); k++)
          r = r + y[i][k] * z[k][j];
        x[i][j] = x[i][j] + r;
      }
```
The inner i-j-k loop have better locality now, since the access range is:
- x: `x[1][jj:jj+B]`
- y: `y[1][kk:kk+B]`
- z: `z[kk:kk+B][jj:jj+B]`

z only need a `BXB` size of cache, while x and y only needed  `1XB`,

### Prefetch to help hardware put useful data in Cache
#### Why correctly insert prefetch instruction could help to improve performance?
The cache's hardware predicator is not smart enough, and can not predicate what
the next memory access will be all the time. Non-block Prefetch instruction
could be inserted to solve this problem.

#### How to insert prefetch instruction correctly?



```c++
/* Before */
for (i=0; i < 3; i++) {
  for (j=0; j < 100; j++) {
    a[i][j] = b[j][0] * b[j+1][0];
  }
}


### Other loop optimizations

#### Software Pipeline

#### Loop interchange

#### Loop Fussion/Fission/Spilt



## C Intrinsic VS Embeded Assembly

 C Intrinsics could generally get the same performance improvement if we write the code correctly, since most of the time we are optimizing hot functions and loops. In most of the case we rely on SIMD extensions to optimize the code, and compiler already have intrinsic/type support for such kind of extension.

 compiler could also help to do type checking, register allocation, instruction scheduling based on the C code as well. Usually the ABI could be handled correctly as well. While if we use assembly, we need to maintain the ABI by ourselves.

 Since the compiler is used to generate assembly finaly, and meanwhile compiler have limitations about program analysis and optimization, hand tuned assembly could have better performance sometimes.

## Optimizations for Code size
- Do not do loop unrolling
- Do not do function inlining
- Use shorter instruction sequence if possible


### Optimizations for VLIW Processor (DSP)

#### Instruction Bundling

#### Advanced Software Pipeline

## Top tips

### Reduce Cache miss rate
Data Cache is the #1 source of stalls in most programs.

The following ways can help to increase the data cache hit rate:
- reorganizing offending data structures to have better locality
- pack structures and numerical types down to eliminate wasted bytes
- prefetch data wherever possible to reduce stalls


### Improve Load-hit-store operations
For your C code, compiler has safe assumptions about pointer aliasing.
When move data between disconnected register sets via memory, such as pointer type casting together with load and store,
- use `__restrict` liberally to promise the compiler about aliasing
- Eliminate memory based type casting among float/vector/int types.

### Reduce Branch mispredicts
If the branch predictor of the CPU guess wrong, the pipeline will be cleaned.
- Find out in your hot loop where the CPU is spending a lot if time refiling the instruction pipeline after a branch, and use branch hinting if possible. `__builtin_expect()`
- Replace branches with conditional-move when possible. Especially Floating point operations since they have deepper pipeline.


### Vectorize sequential operations in your loop

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

 ## Top Traps

 ### floating-point operatios

 ### Int operations
