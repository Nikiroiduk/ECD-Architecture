LAB7 segment 'code'
assume cs:LAB7, ds:LAB7, ss:LAB7, es:LAB7
org 100h
begin: jmp main
   
main proc near
    ; Variant №5

    int 21H
    ret
main endp

LAB7 ends
end begin