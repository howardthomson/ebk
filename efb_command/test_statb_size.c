#include <sys/stat.h>
#include <stdio.h>

struct stat statb;

int main (int ac, char **av) {

	printf ("Sizeof stuct stat = %ld\n", sizeof (statb));
}