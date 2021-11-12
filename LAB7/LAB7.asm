org 100h
.model small
.stack 100h
.data
.code
begin: jmp main
main proc near
     ; Variant №5

     mov ah,04CH
     int 21H
     ret
main endp

end begin