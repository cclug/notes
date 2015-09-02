#include <stdio.h>
#include <fcntl.h>

/* demonstration of horrible bug; neither compiler nor lint picks it up */
int main(void)
{
	char *file = "config";
	FILE *fp;
	char buf[BUFSIZ];

	if ((fp = fopen(file, O_RDONLY)) == NULL)
	/* if ((fp = fopen(file, "r")) == NULL) */
		fprintf(stderr, "fopen failed");
	
	while (fgets(buf, BUFSIZ, fp) != NULL)
		if (fputs(buf, stdout) == EOF)
			fprintf(stderr, "output error");

	if (ferror(fp))
		fprintf(stderr, "input error");

	return 0;
	
}
