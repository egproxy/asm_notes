#include <assert.h>
#include <stdio.h>
#include "bn.h"

int main()
{
	bn *x = bn_new();
	bn *y = bn_new();
	bn *z = bn_new();
	assert(x);
	assert(y);
	assert(z);

	int ret = bn_hex2bn(x, "Feed");
	assert(!ret);
	ret = bn_hex2bn(y, "CafeF00d5");
	assert(!ret);
	ret = bn_add(x, x, x);
	assert(!ret);
	ret = bn_add(y, y, x);
	assert(!ret);
	ret = bn_hex2bn(x, "123456789abcdef");
	assert(!ret);
	ret = bn_add(z, x, y);
	assert(!ret);

	char x_str[20];
	char y_str[20];
	char z_str[20];
	ret = bn_bn2hex(x_str, sizeof x_str, x);
	assert(!ret);
	ret = bn_bn2hex(y_str, sizeof y_str, y);
	assert(!ret);
	ret = bn_bn2hex(z_str, sizeof z_str, z);
	assert(!ret);
	bn_free(x);
	bn_free(y);
	bn_free(z);
	printf("x: %s\ny: %s\nz: %s\n", x_str, y_str, z_str);
	return 0;
}
