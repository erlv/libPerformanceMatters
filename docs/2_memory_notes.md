# Memory Hierarchy of the Computer

## Performance factors of different level of memory

Name | Size | Hit Time | Miss Penalty | Miss rate
----- | ---- | --- | ----------- | --------
L1-D | | | |
L1-I | | | |
TLB | 12 - 4096 | 0.5 -1 | 10 - 100 | 0.01% - 1%


### Memory Hierarchy details on ARM Processor

The following are detail data for Samsuny Exynos 4210's implementation of Cortex-A9
- 4-bytes range cross penalty = 1 cycle
- 8-bytes range cross penalty = 6 cycles
- CPU can handle TLB misses in parallel (it works with two parallel accesses at least).
- L1 B/W (Parallel Random Read) = 1 cycles per one access
- L2->L1 B/W (Parallel Random Read) = 7 cycles per cache line
- L2->L1 B/W (Read, 32 bytes step) = 8.7 cycles per cache line
- L2 Write (Sequential) = 1 cycle per 4 bytes.
- L2 Write (Write, 32 bytes step) = 11.5 cycles per write (cache line), probably write allocate to L1 is enabled
- RAM Read B/W (Parallel Random Read) = 68 ns / cache line = 470 MB/s
- RAM Read B/W (Read, 4 Bytes step) = 890 MB/s
- RAM Read B/W (Read, 32 Bytes step) = 1010 MB/s
- RAM Write B/W (Sequential, or 4 bytes step) = 1600 MB/s
- RAM Write B/W (32 bytes step) = 725 MB/s, probably write allocate is enabled 

## Cache
Cache Usually includes:
- L1-I Cache
- L1-D Cache
- L2 Cache
- L3 Cache
- TLB (Translation Lookaside Buffer)
 - If our platform support virtual memory address management.
 
### Cache Line
While transfer data between Cache and Memory, it is by blocks of fixed size which is called cache line.

Meanwhile the cache is split by the size of cache line as well. 
The cache line size is usually 32B or 64B.

![How Cache Line works](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/CacheLines.png)


Each time when cache need to get data from main memory, or write data to main memory, the cache in
fact access memory by the size of cache line. Therefore if your data to be accessed cross the boundy of cache line, the performance should be bad.

### L1-I cache


### L1-D Cache


### TLB
TLB is used as a cache for paging addresses. After a translation between linear
and physical address happens, it is stored on the TLB.



### L2 Cache




## Memory


### The memory bank conflict problem


### The alignment problem

#### Data Alignment during memory access
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

For the following 1B memory access granularity, no matter we access the data from
address 0 or address 1, since we only access 1B, there is no problem.

![1B memory access](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/da_singleByteAccess.jpg)


For the following 2B memory access granularity, the 2B data will be aligned to 2B boundy, if we
 access to unaligned address, the processor need to rearrange the data by itself if supported, or complain about bus error.

![2B memory access](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/da_doubleByteAccess.jpg)


For the following 4B memory access granularity, if we do not access the unalign address, the same problem happens.

![4B memory access](https://raw.githubusercontent.com/erlv/libPerformanceMatters/master/docs/images/da_quadByteAccess.jpg)

## References
- [Data alignment: Straighten up and fly right](http://www.ibm.com/developerworks/library/pa-dalign/)
