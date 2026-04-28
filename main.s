.section .data
prefix:
	.ascii "The double is: "
buffer:
	.byte 0

.section .text
.globl _start

_start:
	mov %rsp, %rbp
	// Read from stdin and push each character to the stack
	read_loop:
		mov $0, %rax # syscall: sys_write
		mov $0, %rdi # file descriptor: stdin
		mov $buffer, %rsi # string address
		mov $1, %rdx # string length
		syscall # calls the kernel

		mov $'\n', %rdx
		xor buffer, %rdx
		jz read_exit

		push buffer
		
		jmp read_loop
	read_exit:

	// Pop each character from the stack, convert to int and accumulate
	xor %r8, %r8 # accumulator
	mov $10, %r10 # base
	mov $1, %r11 # radix
	to_int_loop:
		pop %rax
		sub $'0', %rax
		mul %r11
		add %rax, %r8
		mov %r11, %rax
		mul %r10
		mov %rax, %r11
		mov %rsp, %rcx
		xor %rbp, %rcx
		jnz to_int_loop

	// Print prefix
	mov $1, %rax # syscall: sys_write
	mov $1, %rdi # file descriptor: stdout
	mov $prefix, %rsi # string address
	mov $15, %rdx # string length
	syscall # calls the kernel

	// Double and move to %rax
	shl $1, %r8
	mov %r8, %rax

	// Convert each digit to ascii and push to stack
	to_ascii_loop:
		xor %rdx, %rdx
		div %r10
		add $'0', %rdx
		push %rdx
		test %rax, %rax
		jnz to_ascii_loop

	// Pop each character from the stack and print it
	print_loop:
		pop %rax
		mov %rax, buffer
		mov $1, %rax # syscall: sys_write
		mov $1, %rdi # file descriptor: stdout
		mov $buffer, %rsi # string address
		mov $1, %rdx # string length
		syscall # calls the kernel
		mov %rsp, %rcx
		xor %rbp, %rcx
		jnz print_loop

	// Print newline
	movb $'\n', buffer
	mov $1, %rax # syscall: sys_write
	mov $1, %rdi # file descriptor: stdout
	mov $buffer, %rsi # string address
	mov $1, %rdx # string length
	syscall # calls the kernel

	// Terminate
	mov $60, %rax # syscall: sys_exit
	xor %rdi, %rdi # exit status: 0
	syscall # calls the kernel
