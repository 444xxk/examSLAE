


_start: 




RANDSTART:
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      
                ; lets just take the lower bits of DL for a start..



; store the lowest byte for XOR 


