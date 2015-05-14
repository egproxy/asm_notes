# Demonstrating simple use of cmd args via assembly

  .section .data

LC0:
    .asciz "Name of the program: %s\n"

LC1: 
    .asciz "Num of arguments: %d\n"

  .section .text

  .globl main

main:
  pushl   %ebp
  movl    %esp,     %ebp 
  subl    $8,       %esp

  #  Current Stack
  #  +-----------+ 
  #  | argv+0    |   
  #  +-----------+  +12
  #  | argc      |
  #  +-----------+  +8
  #  | ret addr  |
  #  +-----------+  +4
  #  | saved ebp |
  #  +-----------+  <--- %ebp   
  #  | subl 8    |
  #  |           |
  #  +-----------+  <--- %esp

  movl    12(%ebp), %eax      # move address at argv[0] into register `a`
  movl    (%eax),   %eax      # dereference address to get pointer to char array 
  movl    %eax,     4(%esp)   # move argv[0] to stack
  movl    $LC0,     (%esp)    # move cstr to print to stack
  call    printf          

  movl    8(%ebp),  %eax       
  movl    %eax,     4(%esp)
  movl    $LC1,     (%esp)
  call    printf

  movl    $1,       %eax       # sys call number 1
  movl    $0,       %ebx       # exit code 0
  int     $0x80                # interrupt to kernel to exit
