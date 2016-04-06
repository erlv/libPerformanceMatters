# Performance Tuning Tools

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

## gprof
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

## Oprofile
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

## Assembly analysis
Basically, no matter what kind of platform you are try to run your program, assembly is the most straight forward way to know how your program will run on the platform. And for C/C++ language and embeded assembly, compiler will turn all the code in your program into assembly code at first before your program could be run.

assembly is the instruction sequence of your code. It is the intermediate level of your code to understand how your program will run on the platform. Therefore, you are highly recommanded to figure out the assembly code of your code especially the hot function while tunning performance.

`objdump -S` and `gcc -S` are two ways to get the assembly. The difference between these two tools is that:
 - `objdump -S` directly analyse the binary (executable or object) file, and get the instruction sequences which will be executed.
 - `gcc -S` generated assembly by the `gcc` compiler. `gcc` compiler analyse the C code, and based on the C code and the target architecture to generate assembly.
 - `as` eats the compiler generated assembly, and then generate object file which could be used by `objdump -S`. Sometimes, on some architecture, `as` might automatically expand assembly macro into multiple instructions, or combine several instructions into an assembly macro. We could treat `objdump -S` generated assembly as the final assembly.
