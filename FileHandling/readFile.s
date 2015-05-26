# Filename: readFile.s
# Demonstrates read strings from a file using a buffer.
# 
# Usage:
# ./a.out filename.txt [ outputfile.txt = "out.txt" ]
#
# filename.txt must be readable. "outputfile.txt" defaults to out.txt
# if no argument is supplied. If no file by the name "outputfile.txt"
# exists, program will create it.
#
# Purpose:
# Program reads all text from an input file and writes the lowercase
# equivalent to an output file.


# constants can be declared with .equ which is not initialized in any section
# but replaced by the assembler.
.equ FREAD,   0x3
.equ FWRITE,  0x4
.equ FOPEN,   0x5
.equ FCLOSE,  0x6

# File Descriptor Modes are found in /usr/include/asm/fcntl.h
# Defined constants are in octal format
.equ MODE_RO, 0x0
.equ MODE_RW, 0x1
.equ MODE_CREAT, 0x40       # octal 100
.equ MODE_TRUNC, 0x200      # octal 1000

  .section .bss

.lcomm BUFF, 256

  .section .data

LC0: .asciz "Invalid File Descriptor: %i\n"

  .section .rodata
DOUT: .asciz "out.txt"      # default output filename

  .section .text

  .globl main

main:
  pushl       %ebp
  movl        %esp,         %ebp
  subl        $20,          %esp

  movl        12(%ebp),     %eax
  movl        4(%eax),      %eax 
  movl        $MODE_RO,     4(%esp)
  movl        %eax,         (%esp)
  call        openfile
  cmpl        $0,           %eax 
  jl          invalid_fd
  movl        %eax,         16(%esp)      ## BOTTOM OF STACK HOLDS READ FILE

# USE DEFAULT IF NO 3RD ARGV GIVEN
  movl        8(%ebp),      %eax
  cmpl        $3,           %eax
  jge         specified
  movl        $DOUT,        %eax
  jmp         openout
specified:
  movl        12(%ebp),     %eax
  movl        8(%eax),      %eax
openout:
  movl        $MODE_RW,     %ebp
  orl         $MODE_CREAT,  %ebp
  orl         $MODE_TRUNC,  %ebp
  movl        %ebp,         4(%esp)
  movl        %eax,         (%esp)
  call        openfile
  cmpl        $0,           %eax 
  jl          invalid_fd 
  movl        %eax,         12(%esp)       ## 2ND TO BOTTOM HOLDS OUTPUT FILE
  
 ## START READING FROM INPUT FILE  
dountil_EOF:
  movl        16(%esp),     %eax
  movl        %eax,         (%esp)
  movl        $BUFF,        4(%esp)
  movl        $256,         8(%esp)
  call        readfile
  
  cmpl        $0,           %eax
  jle         dountil_END
  
    
  movl        %eax,         8(%esp)         ## SZ OF BUFFER to 3rd arg

  movl        $BUFF,        (%esp)
  call        makeLower

  movl        %eax,         4(%esp)         ## BUFFER to 2nd arg
  movl        12(%esp),     %eax
  movl        %eax,         (%esp)          ## RW-FD to 1st arg
  call        writefile
  jmp         dountil_EOF

dountil_END:
 ## CLOSE OPEN FILES 
  movl        12(%esp),     %eax
  movl        %eax,         (%esp)
  call        closefile

  movl        8(%esp),      %eax
  movl        %eax,         (%esp)
  call        closefile

  jmp         fin
invalid_fd:
  movl        %eax,         4(%esp)
  movl        $LC0,         (%esp)
  call        printf

fin: 
  addl        $16,           %esp        # dealloc stack space
  movl        $1,           %eax
  movl        $0,           %ebx
  int         $0x80
  
# FUNCTION: openfile
# PARAMETERS: 
#   8(%ebp)  -  address of cstring
#   12(%ebp) -  file mode
# RETURN:
#   file descriptor in %eax
.type openfile, @function
openfile:
  pushl       %ebp
  movl        %esp,         %ebp
  movl        $FOPEN,       %eax
  movl        8(%ebp),      %ebx
  movl        12(%ebp),     %ecx
  movl        $0666,        %edx 
  int         $0x80
  movl        %ebp,         %esp
  popl        %ebp
  ret

# FUNCTION: closefile
# PARAMETERS:
#   8(%ebp) - file descriptor number
# RETURN:
#   zeroes out %eax
.type closefile, @function
closefile:
  pushl       %ebp
  movl        %esp,         %ebp
  movl        $FCLOSE,      %eax
  movl        8(%ebp),      %ebx
  int         $0x80
  xorl        %eax,         %eax
  movl        %ebp,         %esp
  popl        %ebp
  ret
 
 # FUNCTION: readfile 
 # PARAMETERS: 
 #   8(%ebp) - valid file descriptor
 #  12(%ebp) - pointer to buffer
 #  16(%ebp) - size of buffer
 # RETURN:
 #  Number of bytes read or error code
.type readfile, @function
readfile:
  pushl       %ebp
  movl        %esp,         %ebp
  movl        $FREAD,       %eax      # READ SYSCALL
  movl        8(%ebp),      %ebx      # File descriptor for open file
  movl        12(%ebp),     %ecx      # Pointer to buffer
  movl        16(%ebp),     %edx      # Size of buffer
  int         $0x80
  movl        %ebp,         %esp
  popl        %ebp
  ret

# FUNCTION: writefile 
# PARAMETERS: 
#   8(%ebp) - valid file descriptor
#  12(%ebp) - pointer to buffer to be written
#  16(%ebp) - size of buffer
# RETURN:
#  Number of bytes written or error code
 .type writefile, @function
 writefile:
  pushl       %ebp
  movl        %esp,         %ebp
  movl        $FWRITE,      %eax
  movl        8(%ebp),      %ebx 
  movl        12(%ebp),     %ecx
  movl        16(%ebp),     %edx
  int         $0x80
  movl        %ebp,         %esp
  popl        %ebp
  ret

# FUNCTION: makeLower
# PARAMETERS:
#   8(%ebp) - address of cstring to be converted
# RETURN:
#   cstring converted to lowercase
.type makeLower, @function
makeLower:
  pushl %ebp
  movl  %esp,     %ebp
  xorl  %ebx,     %ebx
  movl  8(%ebp),  %eax
loop:
  movb  (%eax, %edi, 1), %bl
  cmpl  $0,       %ebx
  je    mlfin
  cmpl  $65,      %ebx
  jl    next
  cmpl  $90,      %ebx
  ja    next
  addl  $32,      %ebx
  movb  %bl,      (%eax, %edi, 1)
next:
  inc   %edi
  jmp   loop
mlfin:
  movl  %ebp,     %esp
  popl  %ebp
  ret
