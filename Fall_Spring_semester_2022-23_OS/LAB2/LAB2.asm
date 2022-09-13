; Variant #5
; Составить программу очистки произвольного прямоугольного окна
; экрана, координаты которого задаются в командной строке. Используйте
; прерывание 10H.

spaceMacro macro
    printSymbolMacro 20H
endm

printSymbolMacro macro symbol
    push ax
    push dx
    mov ah, 02H
    mov dx, symbol
    int 21H
    pop dx
    pop ax
endm

printSymbolMacro macro symbol
    push ax
    push dx
    mov ah, 02H
    mov dl, symbol
    int 21H
    pop dx
    pop ax
endm

printLineMacro macro line
    push ax
    push dx
    mov ah, 09H
    lea dx, line
    int 21H
    pop dx
    pop ax
endm

LAB2 segment 'code'
assume cs:LAB2, ds:LAB2, ss:LAB2, es:LAB2
org 100h
begin: jmp main
    newLineHelper db 0AH, 0DH, '$'
    



    data dw ?
    sign db '+'
    tensThousands db ?
    thousands db ?
    hundreds db ?
    tens db ?
    ones db ?
    
main proc near
    
    ret
main endp

numberOut proc near
    push ax
    push bx
    push cx
    push dx
    mov ax, data
    and ax, 8000H
    mov cl, 15
    shr ax, cl
    cmp ax, 1
    jne @m1
    mov ax, data
    neg ax
    mov sign, '-'
    jmp @m2
@m1:
    mov ax, data
@m2:
    cwd
    mov bx, 10000
    idiv bx
    mov tensThousands, al
    mov ax, dx
    cwd
    mov bx, 1000
    idiv bx
    mov thousands, al
    mov ax, dx
    mov bl, 100
    idiv bl
    mov hundreds, al
    mov al, ah
    cbw
    mov bl, 10
    idiv bl
    mov tens, al
    mov ones, ah
    cmp sign, '+'
    je @m500
    mov ah, 02H
    mov dl, sign
    int 21H
@m500:
    cmp tensThousands, 0
    je @m200
    mov ah, 02H
    mov dl, tensThousands
    add dl, 30H
    int 21H
@m200:
    cmp tensThousands, 0
    jne @m300
    cmp thousands, 0
    je @m400
@m300:
    mov ah, 02H
    mov dl, thousands
    add dl, 30H
    int 21H
@m400:
    cmp tensThousands, 0
    jne @m600
    cmp thousands, 0
    jne @m600
    cmp hundreds, 0
    je @m700
@m600:
    mov ah, 02H
    mov dl, hundreds
    add dl, 30H
    int 21H
@m700:
    cmp tensThousands, 0
    jne @m900
    cmp thousands, 0
    jne @m900
    cmp hundreds, 0
    jne @m900
    cmp tens, 0
    je @m950
@m900:
    mov ah, 02H
    mov dl, tens
    add dl, 30H
    int 21H
@m950:
    mov ah, 02H
    mov dl, ones
    add dl, 30H
    int 21H
    pop dx
    pop cx
    pop bx
    pop ax
    ret
numberOut endp

LAB2 ends
end begin
