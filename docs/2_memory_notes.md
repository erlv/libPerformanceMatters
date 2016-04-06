# Memory Hierarchy of the Computer

## Performance factors of different level of memory

Name | Size | Hit Time | Miss Penalty | Miss rate
----- | ---- | --- | ----------- | --------
L1-D | | | |
L1-I | | | |
TLB | 12 - 4096 | 0.5 -1 | 10 - 100 | 0.01% - 1%


## Cache
Cache Usually includes:
- L1-I Cache
- L1-D Cache
- L2 Cache
- L3 Cache
- TLB (Translation Lookaside Buffer)
 - If our platform support virtual memory address management.
 
 
### L1-I cache


### L1-D Cache


### TLB
TLB is used as a cache for paging addresses. After a translation between linear
and physical address happens, it is stored on the TLB.



### L2 Cache




## Memory

## Hard Disk

## The alignment problem

### Data Alignment during memory access
While programming, we treat each element in the array as an isolated element, 
we could simply load and store any size of them with the same latency anytime. 
It is mostly like the following figure.

![How Programmers see memory](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/da_programmer.jpg)

However, from the hardware's side, the world is completely different. The hardware
could only access the memory in 2-, 4-, 8-, 16- or even 32-byte chunk size. The following
figure shows when we access 32bit sized element, the processor will treat the memory
as 4-byte chunked memory.

![How processor sees memory](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/da_processor.jpg)

If we do not access the data based on the chunk boundary, then we get the data alignment
problem. Such problem could lead to performance degradation or program crash.

Single-byte memory access granularity
![1B memory access](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/da_singleByteAccess.jpg)

Double-byte memory access granularity
![2B memory access](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/da_doubleByteAccess.jpg)

Quad-byte memory access granularity
![4B memory access](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/da_quadByteAccess.jpg)

## Why we need optimization based on the memory hierarchy

## References
- [Data alignment: Straighten up and fly right](http://www.ibm.com/developerworks/library/pa-dalign/)
