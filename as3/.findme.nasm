; assembly for test purposes
; simply output 1234 when shellcode is found  


global _start 


section .text 


_start: 

	; print 1234 
	mov eax, 0x4
	mov ebx, 0x1 
	push 0x34333231
	mov ecx,esp 
	mov edx, 0x4
	int 0x80 


	; exit 0  

	mov eax, 0x1 
	mov ebx, 0x0 
	int 0x80




