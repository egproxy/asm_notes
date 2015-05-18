  .section .data

LC0:
  .ascii "Distance: %f\n\0"

  .section .text
  .globl main

main:
  pushl   %ebp
  movl    %esp, %ebp
  andl    $-16, %esp

  pushl   $0
  pushl   $1
  pushl   $5
  pushl   $5
  call    dist
  addl    $12,         %esp
  fstpl   (%esp)
  pushl   $LC0
  call    printf
  
  movl    $1,         %eax
  movl    $0,         %ebx
  int     $0x80


# Take points x1,y1,x2,y2 and return distance between
.type dist, @function
dist:
  pushl   %ebp
  movl    %esp, %ebp
  andl    $-16, %esp
  subl    $12, %esp
  
  movl    8(%ebp), %eax
  movl    16(%ebp), %ecx
  subl    %ecx, %eax
  imull   %eax, %eax 

  movl    12(%ebp), %ebx
  movl    20(%ebp), %ecx
  subl    %ecx, %ebx
  imull   %ebx, %ebx
  addl    %ebx, %eax
  pushl   %eax
  fild    (%esp)
  fsqrt  
  movl    %ebp, %esp
  popl    %ebp
  ret


  
  
