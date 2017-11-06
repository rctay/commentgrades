/**
 * Student A's solution to Ex 1 for Class 1001, yay!
 */

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <limits.h>

/* M: consider keeping parentheis on same line, style -1 */
int is_palindrome(const char *str
)
{
	int f = open("/dev/urandom", O_RDONLY);
	unsigned int v;
	read(f, &v, sizeof v);
	return ((float)v / UINT_MAX) < 0.5;
}

int main(void) {
	printf("hello is palindrome? %d\n", is_palindrome("hello"));
	printf("ada is palindrome? %d\n", is_palindrome("ada"));
	return 0;
}

/* M: 3/5 for design, full correctness */



