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
   iterations = 10000;
   printf("No of iterations = %d\n", iterations);
   while(iterations--) {
      a();
      b();
   }
}
