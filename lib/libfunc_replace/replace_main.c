/* log example */
#include <stdio.h>      /* printf */
#include <math.h>       /* log */

int main ()
{
  double param, result;
  param = 5.5;
#ifdef STATIC_LINK
  result = mylog(param);
#else
  result = log (param);
#endif
  printf ("log(%f) = %f\n", param, result );
  return 0;
}

