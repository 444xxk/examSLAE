; shell for test purposes 
; author 


global _start 


section .text 


_start: 

	; print helloworld 
	mov eax, 0x4
	mov ebx, 0x1 
	mov ecx, message 
	mov edx, mlen 
	int 0x80 


	; exit 0  

	mov eax, 0x1 
	mov ebx, 0x0 
	int 0x80


section .data 

	message: db "shellcode found and executed"
	mlen equ $-message 


