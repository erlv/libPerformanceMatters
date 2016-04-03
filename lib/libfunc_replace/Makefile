NATIVE_GCC=gcc
CROSS_GCC=arm

CC=${NATIVE_GCC}
#CC=$CROSS_GCC

all:
	# No replace
	${CC} replace_main.c -o replace_noreplace.exe -lm
	
	#static replace
	${CC} libmyimplementation_static.c -c -o myimplementation_static.o
	ar rcs libmylib.a myimplementation_static.o
	${CC} -static replace_main.c -o replace_static.exe -L./ -lmylib -lm -DSTATIC_LINK
		
	# Dynamic replace
	${CC} libmyimplementation_dynamic.c -c -fPIC -o myimplementation_dynamic.o
	${CC} -shared -Wl,-soname,libmylib.so -o libmylib.so  myimplementation_dynamic.o -lm -ldl
	${CC} replace_main.c -o replace_dynamic.exe -L./ -lmylib

clean:
	-rm -rf *.o *.exe *.so *.a
