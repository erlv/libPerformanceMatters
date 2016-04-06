# CPU Micro Architecture Notes

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

![Instruction execution steps](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/instruction_execution.png)

###  The importance of Instruction Pipeline
For each instruction, we need all the above 5 steps, while only step 3 is the execution, and only step 4 could reflect the whole processor's state since only at this point we could get the values updated. If each step takes 1 cycle to finsh, the whole instruction execution will take 5 cycles. Which means after each instruction finish, we need to wait for 5 cycles for the next instruction to finish.


If we use instruction to pipeline all the instructions, we could only wait for one cycle for the next instruction to finish. Take the following 4-stage pipeline processor as an example.

![4-stage pipelined instructions](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/instruction_pipeline.png)

For the above pipeline, each instruction is split into at-most 4-steps to run. In theory, if we split instruction into more steps, each step will take shorter time to run, and then we could increase the CPU frequency, and then the latency between two adjuscent instruction finish will be smaller. However, as the pipeline goes deeper, more cycle is needed if we pre-execute the wrong direction for a branch instruction. Therefore there is a trade off here.




### The evolution of ARM Cortex Micro Architecture

#### ARM Cortex-A7 Micro Architecture
Cortex-A7 is in-order execution.
![ARM Cortex-A7](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/arm_cortexa7.png)

#### ARM Cortex-A9 Micro Architecture
Cortex-A9 is out of order execution.
![ARM Cortex-A9](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/arm_cortexa9.jpg)

#### ARM Cortex-A15 Micro Architecture
Cortex-A15 is out of order execution.
![ARM Cortex-A15](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/arm_cortexa15.jpg)


### The evolution of Intel X86 Micro Architecture
For the last few years, Intel X86 processor keep improving its micro architecture for better performance.

#### 2006 Intel Core 2 Micro Architecture
![Intel Core 2 Architecture](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/intel_core2.png)


#### 2008 Intel Nehalem Micro Architecture
![Intel Nehalem Micro Architecture](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/intel_nehalem.png)


#### 2011 Intel Sandy Bridge Micro Architecture

![Intel Sandy Bridge Micro Architecture](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/intelsandybridge.jpg)

#### 2013 Intel Haswell Micro Architecture

![Intel Haswell Micro Architecture](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/intel_haswellexec.png)

#### 2015 Intel Skylake Micro Architecture

![Intel Skylake Micro Architecture](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/intel_skylake.png)



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




## Why we need optimization based on the micro architecture?
If the code need a lot of computation, we need to run a lot of instructions. 
Since the architecture have many function unit, like multiple load/store unit, 
multiple ALU, etc. If we take advantage of them all, we could improve the performance
a lot. 

However, it is hard to always take advantage of them all without carefully modifing the
code, since we write our code sequentially, and meanwhile there is a lot of dependencies
here and there in our code.

## How to Optimize the code based on the micro architecture

The answer is  try to increase Instruction Level Parallelism (ILP) and Data Level Parallelism (DLP)

### Increasing ILP

#### Out-of-Order VS Very Long Instruction Word
Out-of-Order(OoO) relys on hardware support in CPU to improve ILP. While Very Long Instruction Word(VLIW) relies more on compiler dependence analysis to figure out the instructions which do not have dependece and could run simutaniously. 

OoO consumes more power while running, VLIW needs a powerful compiler which is hard to implement and maintain. Altough VLIW failed as general purpose processor, it is still very popular in the low-power embeded DSP applications.

#### General Optimizations for ILP

##### Loop Unrolling

#####

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
 


## Reference

- [Optimizing subroutines in assembly language An optimization guide for x86 platforms By Agner Fog](www.agner.org/optimize/optimizing_assembly.pdf)
