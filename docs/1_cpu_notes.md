# CPU Micro Architecture

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

### SuperScalar processor
Scalar Processor could only run one instruction at a time, while superscalar processor
can run multiple instructions at the same time by have multiple different execution unit.

```c++
// The following two instructions can run in parallel in the processor
a=b+c;
d=e+f

//The following two instructions can not run in parallel in processor
a=b+c;
b=e+f;
```


### The evolution of ARM Cortex Micro Architecture

#### ARM Cortex-A7 Micro Architecture
Cortex-A7 is in-order execution.

![ARM Cortex-A7](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/arm_cortexa7.png)

Cortex-A7 features:
- Partial dual-issue, in-order execution
- 8-stage pipeline
- Neon SIMD
- VFPv4
#### ARM Cortex-A9 Micro Architecture
Cortex-A9 is out of order execution.

![ARM Cortex-A9](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/arm_cortexa9.jpg)

Cortex-A9 could have optional VFPv3 FP support.


#### ARM Cortex-A15 Micro Architecture
Cortex-A15 is out of order execution.
![ARM Cortex-A15](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/arm_cortexa15.gif)


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


### The VLIW processors
VLIW (Very Long Instruction Word) is a popular architecture in the low power DSP world, since it  could minimize the power consumption of the processor.

- MXP TriMedia processor
- ADI SHARC DSP
- TI C6000 DSP
- ST ST200 DSP
- Tensilica Xtensa DSP
- Intel Itanium
- Nvidia and AMD GPU is also somekind of VLIW for non-graphics workloads

![VLIW execution model](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/vliw.jpg)

When VLIW is running, compiler will analyze the instruction dependence, and based on such information to bundle several instruction together.

The bundling basically obey the following rules:
- Only bundle the instructions according to the instruction bundling format specified by the processor
- Instructions bundled together means they will be issued and executed parallelly



## SIMD Instruction Extensions

To improve the performance, both ARM and Intel introduced SIMD instructions.
- ARM Neon
- Intel SSE/AVX


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



## Increasing ILP

### Out-of-Order VS Very Long Instruction Word
Out-of-Order(OoO) relys on hardware support in CPU to improve ILP. While Very Long Instruction Word(VLIW) relies more on compiler dependence analysis to figure out the instructions which do not have dependece and could run simutaniously.

OoO consumes more power while running, VLIW needs a powerful compiler which is hard to implement and maintain. Altough VLIW failed as general purpose processor, it is still very popular in the low-power embeded DSP applications.



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



#### General Optimizations for ILP

##### Loop Unrolling

#####




## Reference

- [Optimizing subroutines in assembly language An optimization guide for x86 platforms By Agner Fog](www.agner.org/optimize/optimizing_assembly.pdf)
