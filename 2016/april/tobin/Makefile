CFLAGS = -std=c99 -D_XOPEN_SOURCE=600 \
        -D_DEFAULT_SOURCE \
	-g -I${TLPI_INCL_DIR} \
	-pedantic \
	-Wall \
	-W \
	-Wmissing-prototypes \
	-Wno-sign-compare \
	-Wno-unused-parameter

douser: douser.o
	$(CC) -o $@ douser.o -L. -ltlpi -lcrypt

clean : 
	@for f in *.o; do \
	if [ -f $$f ]; then \
	rm "$$f"; \
	echo "rm $$f" ; \
	fi; done

