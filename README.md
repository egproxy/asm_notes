x86 AT&T Gas Assembly
---------------------

Learning linux gas for 32bit architectures. AT&T is fairly universal when  
disassembling which is why I chose this. However, intel syntax is used in  
windows and GNU tools provide an option for it. So the real reason is so  
I can just jump in w/o having to mess with settings :P  
  
Currently using `gcc -S -m32 -O0 code.c` to produce 32bit assembly output  
and studying that to learn since I haven't found any really good tutorials  
on this online.  
  
Explanation on the flags:  
-S:   produce assembly output  
-m32: target 32bit architecture  
-O0:  Optimization set to 0, [0-3]  

To produce an executable is no problem. `gcc -m32 -g code.s` or you can  
take the long route and type this  
`as code.s -o code.o`  
`ld code.o -o runexe`  
  
`main.c` & Makefile included is my test outputter. Running `make` or  
`make all` will produce assembly output  
  
You can also check the exit code of a program by running `echo $?`  
  
<3 GDB is love, GDB is life  <3  
  
My most used commands are:  
disass  
info registers  
x $gpr + # (gpr = general purpose register)  
  
  
# Useful References #
- Addresing Modes  
http://docs.oracle.com/cd/E19120-01/open.solaris/817-5477/ennby/index.html  
  
- Jumps & Flags  
www.unixwiz.net/techtips/x86-jumps.html  
