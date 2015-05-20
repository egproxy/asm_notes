OTFILE := asm.s
CFLAGS := -m32 -g -S -O0 -o $(OTFILE)

all:
	$(CC) $(CFLAGS) main.c
    
clean:
	$(RM) main.o $(OTFILE) a.out; ls
