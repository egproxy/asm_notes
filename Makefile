OTFILE := asm.s
CFLAGS := -m32 -S -fomit-frame-pointer -O0 -Wall -o $(OTFILE)
GFLAGS := -m32 -S -g -O0 -Wall -o $(OTFILE)

all:
	$(CC) $(CFLAGS) main.c

debug:
	$(CC) $(GFLAG) main.c
    
clean:
	$(RM) main.o $(OTFILE) a.out; ls
