#ifndef BN_H
#define BN_H

#include <stdint.h>

/* The big num struct used by all of these functions. Numbers are stored in
 * "limbs"--32-bit chunks--in little endian. Thus, the number
 * 0x00112233445566778899aabbccddeeff would be stored as the array
 * {0xccddeeff, 0x8899aabb, 0x44556677, 0x00112233}.
 * The size member is the number of limbs pointed to by the d member whereas
 * the nlimbs member is the number of valid limbs.
 */
struct bn_t
{
	uint32_t size;
	uint32_t nlimbs;
	uint32_t *d;
};
typedef struct bn_t bn;

/* Allocate (by calling malloc()) a new struct bn. Set size, nlimbs, and d to
 * 0. Return NULL if a new struct bn cannot be allocated. */
bn *bn_new(void);

/* Free the argument x (and make sure to free x->d first). */
void bn_free(bn *x);

/* Convert a hex string to a struct bn. For example,
 * bn_hex2bn(x, "FeedFaceBadF00d1");
 * should set x->nlimbs to 2 and d to
 * {0xbadfood1, 0xfeedface}.
 * Make sure d is pointing to enough memory first by checking x->size and
 * reallocating memory if necessary.
 * Return 0 on success and -1 if it fails (either because the hex string is
 * invalid or because memory wasn't available.
 */
int bn_hex2bn(bn *x, const char *hex);

/* Convert the bn pointed to by x to a lowercase, NULL-terminated hex string
 * pointed to by hex. Do not include leading zeros (unless the number is zero
 * in which case write "0" to hex. Return 0 on success and -1 on error.
 *
 * struct bn *x = bn_new();
 * bn_hex2bn(x, "00ABCD");
 * char str1[4];
 * bn_bn2hex(str1, sizeof str1, x); // returns -1 since there isn't enough space
 * char str2[5];
 * bn_bn2hex(str2, sizeof str2, x); // returns 0, sets str2 to "abcd"
 */
int bn_bn2hex(char *hex, size_t size, const bn *x);

/* Add two numbers x and y together and store the result in r. Make sure r
 * grows, if necessary. Return 0 on success and -1 on error.
 *
 * Make sure you can handle bn_add(x, x, x) correctly.
 */
int bn_add(bn *r, const bn *x, const bn *y);

#endif
