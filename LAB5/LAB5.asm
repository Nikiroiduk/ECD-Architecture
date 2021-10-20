LAB5 segment 'code'
assume cs:LAB5, ds:LAB5, ss:LAB5, es:LAB5
org 100h
begin: jmp main

MAIN proc near
     ; Meh
     ; Variant №5

     mov ah,04CH
     int 21H
     ret
MAIN endp

LAB5 ends
end begin