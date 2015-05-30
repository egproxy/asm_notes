CFLAGS := -m32 -g
LDFLAGS := -m32

.PHONY: all clean

all: bn
	gdb bn
clean:
	$(RM) bn main.o bn.o
%.o: %.s
	$(CC) -c -o $@ $(CFLAGS) $<
bn: main.o bn.o
main.o: bn.h
