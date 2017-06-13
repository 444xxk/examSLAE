; SLAE-xxx 
; as extra : 
; cat /usr/include/i386-linux-gnu/asm/unistd_32.h | grep mprotect
; #define __NR_mprotect		125

; /usr/include/asm-generic/mman-common.h
; #define PROT_READ	0x1		/* page can be read */
; #define PROT_WRITE	0x2		/* page can be written */
; #define PROT_EXEC	0x4		/* page can be executed */
; #define PROT_GROWSDOWN	0x01000000


global _start


_start: 
; unleash NX of stack 

mov edx, 0x01000007 ; memory rights RWX and goes downward   
mov ecx, 0x1000 ;  page size is 4096 
mov ebx, esp;  
mov eax,0x7d ; mprotect syscall
int 80h; 
