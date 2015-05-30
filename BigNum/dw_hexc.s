
  .section .data

NEEDARG: .asciz "No argument given\n"

GOTRET:  .asciz "Got return: %X\n"
  
  .section .text

  .globl main
main: 
  pushl %ebp
  movl  %esp, %ebp
  subl  $8,   %esp

  movl  8(%ebp), %eax 
  cmpl  $1,     %eax
  jbe   ERR
 
  movl 12(%ebp), %eax
  movl 4(%eax),  %eax
  movl %eax,    (%esp)
  call dw_hexc
  
  movl %eax,    4(%esp)
  movl $GOTRET, (%esp)
  call printf
  movl $0, %ebx
  jmp END
  ERR:
    movl $NEEDARG, (%esp)
    call printf
    movl $1, %ebx

  END:
    movl  $1,  %eax
  int   $0x80


# Function: dw_hexc
# Parameters:
#   8(%ebp) - the cstring to convert must be 8 characters or less
# Returns:
#   8 chars converted and stuft into a 4 byte value
#   -1 on an invalid hex string

.type dw_hexc,@function
dw_hexc:
  pushl %ebp
  movl  %esp, %ebp
  subl  $12,   %esp
  xorl  %edi, %edi                  # loop counter
_hexc_LP:
  movl  8(%ebp), %edx
  cmpl  $8, %edi                    # first check if max bytes have been read
  je    _hexc_LPE                   
                                    # then check if it's a null character
  movzbl (%edx, %edi, 1), %ecx
  cmpl  $0,    %ecx                 # if it is any of those exit and return result
  je    _hexc_LPE 
  movl  %ecx, (%esp)
  call  isxdigit
  cmpl  $0, %eax
  je    _hexc_ERR
  incl %edi
  jmp _hexc_LP

_hexc_LPE:
  xorl %eax, %eax
  movl 8(%ebp), %ebx
  movl %ebx, (%esp)
  movl $0,  4(%esp)
  movl $16, 8(%esp)
  call strtoul 
  jmp _hexc_END
_hexc_ERR:
  movl $-1, %eax
_hexc_END:
  movl %ebp, %esp
  popl %ebp
  ret




