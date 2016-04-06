#### C Intrinsic VS Embeded Assembly

 C Intrinsics could generally get the same performance improvement if we write the code correctly, since most of the time we are optimizing hot functions and loops. In most of the case we rely on SIMD extensions to optimize the code, and compiler already have intrinsic/type support for such kind of extension.

 compiler could also help to do type checking, register allocation, instruction scheduling based on the C code as well. Usually the ABI could be handled correctly as well. While if we use assembly, we need to maintain the ABI by ourselves.
 
 Since the compiler is used to generate assembly finaly, and meanwhile compiler have limitations about program analysis and optimization, hand tuned assembly could have better performance sometimes.
 



