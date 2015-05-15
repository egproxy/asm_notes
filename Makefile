CFLAGS := -m32 -g -S -O0

all:
	gcc $(CFLAGS) main.c
    
clean:
	$(RM) main.o main.s a.out; ls
