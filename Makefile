CFLAGS := -m32 -g -S -O0 -o asm.s

all:
	gcc $(CFLAGS) main.c
    
clean:
	$(RM) main.o main.s a.out; ls
