  .section .data

LC0: .asciz "Number of limbs: %i\n"


	.file	"bn.s"
	.text
	.globl	bn_new
	.type	bn_new, @function
bn_new:
	pushl	%ebp
	movl	%esp, %ebp
  andl  $-16, %esp
  subl  $4, %esp
  movl  $12, (%esp)
  call  malloc
  movl  $0, (%eax)
  movl  $0, 4(%eax)
  movl  $0, 8(%eax)
  addl  $4, %esp 
  movl  %ebp, %esp
  popl  %ebp 
	ret
	.size	bn_new, .-bn_new

	.globl	bn_free
	.type	bn_free, @function
bn_free:
	pushl	%ebp
	movl	%esp, %ebp
  movl  8(%ebp), %ebx
  movl  (%ebx),  %ecx   # size
  movl  8(%ebx), %edx   # d
freeloop_START:
  cmpl  $0, %ecx
  jb   freeloop_END
  decl  %ecx
  movl  (%edx,%ecx,4), %eax
  call  free
  jmp   freeloop_START
freeloop_END:
  movl  %ebx,   %eax
  call  free
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
