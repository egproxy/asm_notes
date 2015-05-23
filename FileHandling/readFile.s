# Filename: readFile.s
# Read strings from a file using a buffer

# constants can be declared with .equ which is not initialized in any section
# but replaced by the assembler.
  
  .equ FOPEN,   0x5
  .equ FCLOSE,  0x6

# File Descriptor Modes are found in /usr/include/asm/fcntl.h
# Defined constants are in octal format
  .equ MODE_RO, 0x0

  .section .data

LC0: .asciz "Got File Descriptor: %i\n"

  .section .text

  .globl main

main:
  pushl       %ebp
  movl        %esp,         %ebp
  subl        $8,           %esp
  movl        12(%ebp),     %eax
  
  movl        4(%eax),      %eax 
  movl        $MODE_RO,     4(%esp)
  movl        %eax,         (%esp)
  call        readfile

  movl        %eax,         4(%esp)
  movl        $LC0,         (%esp)
  call        printf
  
  addl        $8,           %esp

  movl        $1,           %eax
  movl        $0,           %ebx
  int         $0x80
  

# Return file descriptor in %eax
.type readfile, @function
readfile:
  pushl       %ebp
  movl        %esp,         %ebp
  movl        $FOPEN,       %eax
  movl        8(%ebp),      %ebx
  movl        12(%ebp),     %ecx
  movl        $0444,        %edx 
  int         $0x80
  movl        %ebp,         %esp
  popl        %ebp
  ret


  
