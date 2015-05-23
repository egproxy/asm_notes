# Filename: makeLower.s 
# Purpose: Demonstrating char by char processing used heavily
# in file handling and IO

  # Read only data segment

  .section .rodata 

LC0: .asciz "Converted string: %s\n"

  .section .text
  .globl main

main:
  pushl %ebp
  movl  %esp,     %ebp

  subl  $8,       %esp

  movl  8(%ebp),  %ebx
  cmpl  $1,       %ebx     
  jbe   forceexit
  
  movl  12(%ebp), %eax
  movl  4(%eax),  %eax
  movl  %eax,     (%esp)
  call  makeLower
  movl  %eax,     4(%esp)
  movl  $LC0,     (%esp)
  call  printf

forceexit:
  movl  $1,       %eax
  movl  $0,       %ebx

  int   $0x80       # Interrupt OS from whatever it's doing
                    # and call exit


# Function: makeLower
# Argument:
#   8(%ebp) - address of cstring to be converted
#
# Returns:
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
  je    fin
  cmpl  $65,      %ebx
  jl    next
  cmpl  $90,      %ebx
  ja    next
  addl  $32,      %ebx 
  movb  %bl,      (%eax, %edi, 1)
next:
  inc   %edi
  jmp   loop      
fin:
  movl  %ebp,     %esp 
  popl  %ebp
  ret
  
