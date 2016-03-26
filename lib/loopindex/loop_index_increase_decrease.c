
#define ARRAY_SZ 1000
int a[ARRAY_SZ];

long long foo1_0() {
	int i = 0;
	long long sum;
	int* pa = &a[0];
	for (; i < ARRAY_SZ; i++) {
		sum += *pa;
		pa++;
	}
	return sum;
}

long long foo1_1() {
	int i = 0;
	long long sum;
	for (; i < ARRAY_SZ; i++) {
		sum += a[i];
	}
	return sum;
}



long long foo2_0() {
	int i = ARRAY_SZ;
	long long sum;
	int* pa= &a[ARRAY_SZ-1];
	for (; i != 0; i--) {
		sum += *pa;
		pa--;
	}
	return sum;
}

long long foo2_2() {
	int i = ARRAY_SZ-1;
	long long sum;
	for (; i >= 0; i--) {
		sum += a[i];
	}
	return sum;
}
