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


## Why we need optimization based on the memory hierarchy


## How to Optimize the code

### Instruction Level Parallelism


### Data-Level Parallelism

### Thread-Level Parallelism




