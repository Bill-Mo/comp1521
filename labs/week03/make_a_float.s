	.file	"make_a_float.c"
	.text
	.section	.rodata
.LC0:
	.string	"bits : %s\n"
.LC1:
	.string	"float: %0.10f\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movl	%edi, -68(%rbp)
	movq	%rsi, -80(%rbp)
	movl	-4(%rbp), %eax
	andl	$511, %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	shrl	$9, %eax
	movzbl	%al, %eax
	leal	(%rax,%rax), %edx
	movzwl	-4(%rbp), %eax
	andw	$-511, %ax
	orl	%edx, %eax
	movw	%ax, -4(%rbp)
	movzwl	-4(%rbp), %eax
	shrw	%ax
	andb	$-1, %ah
	andl	$1, %eax
	andl	$1, %eax
	movl	%eax, %edx
	movzbl	-4(%rbp), %eax
	andl	$-2, %eax
	orl	%edx, %eax
	movb	%al, -4(%rbp)
	movq	-80(%rbp), %rdx
	movl	-68(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	checkArgs
	movq	-80(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rdx
	movq	-80(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rcx
	movq	-80(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	getBits
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	leaq	-64(%rbp), %rdx
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	showBits
	movq	%rax, %rsi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movss	-4(%rbp), %xmm0
	cvtss2sd	%xmm0, %xmm0
	leaq	.LC1(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.section	.rodata
.LC2:
	.string	"%d\n"
	.text
	.globl	getBits
	.type	getBits, @function
getBits:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	andl	$1, %eax
	andl	$1, %eax
	movl	%eax, %edx
	movzbl	-4(%rbp), %eax
	andl	$-2, %eax
	orl	%edx, %eax
	movb	%al, -4(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movzbl	%al, %eax
	leal	(%rax,%rax), %edx
	movzwl	-4(%rbp), %eax
	andw	$-511, %ax
	orl	%edx, %eax
	movw	%ax, -4(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	andl	$8388607, %eax
	sall	$9, %eax
	movl	%eax, %edx
	movl	-4(%rbp), %eax
	andl	$511, %eax
	orl	%edx, %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC2(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-4(%rbp), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	getBits, .-getBits
	.globl	showBits
	.type	showBits, @function
showBits:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movb	$0, (%rax)
	movq	-16(%rbp), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	showBits, .-showBits
	.section	.rodata
.LC3:
	.string	"Usage: %s Sign Exp Frac\n"
.LC4:
	.string	"%s: invalid Sign: %s\n"
.LC5:
	.string	"%s: invalid Exp: %s\n"
.LC6:
	.string	"%s: invalid Frac: %s\n"
	.text
	.globl	checkArgs
	.type	checkArgs, @function
checkArgs:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	cmpl	$2, -4(%rbp)
	jg	.L8
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC3(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %edi
	call	exit@PLT
.L8:
	movq	-16(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	justBits
	testl	%eax, %eax
	jne	.L9
	movq	-16(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC4(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %edi
	call	exit@PLT
.L9:
	movq	-16(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movl	$8, %esi
	movq	%rax, %rdi
	call	justBits
	testl	%eax, %eax
	jne	.L10
	movq	-16(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC5(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %edi
	call	exit@PLT
.L10:
	movq	-16(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movl	$23, %esi
	movq	%rax, %rdi
	call	justBits
	testl	%eax, %eax
	jne	.L13
	movq	-16(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC6(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %edi
	call	exit@PLT
.L13:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	checkArgs, .-checkArgs
	.globl	justBits
	.type	justBits, @function
justBits:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	movl	-12(%rbp), %eax
	cltq
	cmpq	%rax, %rdx
	je	.L17
	movl	$0, %eax
	jmp	.L16
.L19:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$48, %al
	je	.L18
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$49, %al
	je	.L18
	movl	$0, %eax
	jmp	.L16
.L18:
	addq	$1, -8(%rbp)
.L17:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L19
	movl	$1, %eax
.L16:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	justBits, .-justBits
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",@progbits
