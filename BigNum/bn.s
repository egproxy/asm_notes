	.file	"bn.s"
	.text
	.globl	bn_new
	.type	bn_new, @function
bn_new:
	pushl	%ebp
	movl	%esp, %ebp

	# Return NULL
	xorl	%eax, %eax

	leave
	ret
	.size	bn_new, .-bn_new

	.globl	bn_free
	.type	bn_free, @function
bn_free:
	pushl	%ebp
	movl	%esp, %ebp

	leave
	ret
	.size	bn_new, .-bn_new


	.globl	bn_hex2bn
	.type	bn_hex2bn, @function
bn_hex2bn:
	pushl	%ebp
	movl	%esp, %ebp

	# Return -1
	movl	$-1, %eax

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
