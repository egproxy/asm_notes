# Filename: readFile.s
# Read strings from a file using a buffer

# constants can be declared with .equ which is not initialized in any section
# but replaced by the assembler.
  
  .equ FOPEN,   0x5
  .equ FCLOSE,  0x6

# File Descriptor Modes are found in /usr/include/asm/fcntl.h
# Defined constants are in octal format
  .equ MODE_RO, 0x0
  .equ MODE_RW, 0x1
  .equ MODE_CREAT, 0x40     # octal 100
  .equ MODE_TRUNC, 0x200    # octal 1000

  .section .data

LC0: .asciz "Invalid File Descriptor: %i\n"

  .section .text

  .globl main

main:
  pushl       %ebp
  movl        %esp,         %ebp
  subl        $16,          %esp

  movl        12(%ebp),     %eax
  movl        4(%eax),      %eax 
  movl        $MODE_RO,     4(%esp)
  movl        %eax,         (%esp)
  call        openfile
  
  cmpl        $0,           %eax 
  jl          invalid_fd

 ## BOTTOM OF STACK HOLDS READ FILE
  movl        %eax,         12(%esp)
  
  movl        14(%ebp),     %eax
  movl        4(%eax),      %eax
  movl        $MODE_RW,     4(%esp)
  orl         $MODE_CREAT,  4(%esp)
  orl         $MODE_TRUNC,  4(%esp)
  movl        %eax,         (%esp)
  call        openfile

  cmpl        $0,           %eax 
  jl          invalid_fd 

 ## 2ND TO BOTTOM HOLDS OUTPUT FILE 
  movl        %eax,         8(%esp)

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
  addl        $8,           %esp        # dealloc stack space
  movl        $1,           %eax
  movl        $0,           %ebx
  int         $0x80
  
# Function: openfile
#
# Parameters: 
# 8(%ebp)  ::  address of cstring
# 12(%ebp) ::  file mode
#
# Return file descriptor in %eax
.type openfile, @function
openfile:
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

# Function: closefile
#
# Parameters:
# 8(%ebp)  ::  file descriptor number
#
# No Return, zeroes out %eax
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
 
  
