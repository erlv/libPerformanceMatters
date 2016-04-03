/* log example */
#include <stdio.h>      /* printf */
#include <math.h>       /* log */
#include <stdlib.h>
#include <dlfcn.h>

double log(double in) {
	printf("mylog is called\n");
	void *handle;
	double (*log)(double);
	char *error;

	handle = dlopen("libm.so", RTLD_LAZY);
	if (!handle) {
		fprintf(stderr, "%s\n", dlerror());
		exit(EXIT_FAILURE);
	}

	dlerror();    /* Clear any existing error */

	*(void **) (&log) = dlsym(handle, "log");

	if ((error = dlerror()) != NULL)  {
		fprintf(stderr, "%s\n", error);
		exit(EXIT_FAILURE);
	}

	double ret = (*log)(in);
	dlclose(handle);
	return ret;
}

