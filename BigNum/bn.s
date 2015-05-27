
	.file	"bn.s"
	.section .text

# Function: bn_new
# Purpose:
#  Create new bn struct and return it
#
	.globl	bn_new
	.type	bn_new, @function
bn_new:
	pushl	%ebp
	movl	%esp,       %ebp
  subl  $4,         %esp
  movl  $12,        (%esp)
  call  malloc
  movl  $0,         (%eax)    # Set size to 0
  movl  $0,         4(%eax)   # Set numOfLimbs to 0
  movl  $0,         8(%eax)   # Set *d to NULL
  addl  $4,         %esp 
  movl  %ebp,       %esp
  popl  %ebp 
	ret
	.size	bn_new, .-bn_new


# Function: bn_free
# Purpose: 
#   Takes a bn struct and zero's out all its data
#   Dynamically allocated d will be freed from the
#   heap. Finally, deallocate the struct
#
	.globl	bn_free
	.type	bn_free, @function
bn_free:
	pushl	%ebp
	movl	%esp,       %ebp
  subl  $4,         %esp
  movl  8(%ebp),    %ebx      # holds address to struct bn
  cmpl  $0,         8(%ebx)   # check if anything was allocated in *d
  je    BND_EMPTY             # skip on NULL
  movl  8(%ebx),    %eax
  movl  %eax,       (%esp)    # Otherwise, free the heap
  call  free
  BND_EMPTY:
  movl  %ebx,       (%esp)      
  call  free                  # Deallocat the struct
  addl  $4,         %esp      # Clear extra space from stack
	leave
	ret
	.size	bn_new, .-bn_new



	.globl	bn_hex2bn
	.type	bn_hex2bn, @function
bn_hex2bn:
	pushl	%ebp
	movl	%esp,     %ebp
  subl  $16,      %esp
  pushl 12(%ebp)
  call  strlen
  xorl  %edx,     %edx
  movl  $8,       %ebx
  divl  %ebx
  movl  %eax,     4(%esp)   # find how many limbs are needed
  movl  8(%ebp),  %ebx 
  movl  %eax,     4(%ebx)
  cmpl  $0,       %edx 
  je    noremain
  incl  4(%ebx)
noremain:
  movl  4(%ebx),  %eax 
  movl  %eax,     (%ebx)
  movl  %eax,     (%esp)
  call  malloc
  movl  %eax,     8(%ebx)   # store array of u32ints to d
                            # represented by array of pointers to 4 bytes

	leave
	ret
	.size	bn_hex2bn, .-bn_hex2bn



	.globl	bn_bn2hex
	.type	bn_bn2hex, @function
bn_bn2hex:
	push	%ebp
	movl	%esp, %ebp

	# Return -1
	movl	$-1, %eax

	leave
	ret
	.size	bn_bn2hex, .-bn_bn2hex

	.globl	bn_add
	.type	bn_add, @function
bn_add:
	push	%ebp
	movl	%esp, %ebp

	# Return -1
	movl	$-1, %eax

	leave
	ret
	.size	bn_add, .-bn_add
