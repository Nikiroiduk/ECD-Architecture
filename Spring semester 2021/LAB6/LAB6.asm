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

LAB6 segment 'code'
assume cs:LAB6, ds:LAB6, ss:LAB6, es:LAB6
org 100H
begin: jmp main

    X dd 3.14
    Y dd ?
    FOUR dd 4.0

main proc near
    ; Variant №5
    ; Y = arctg((1+x)/(1-x))/4

    FINIT
    FLD1            ; st(0) = 1
    FLD X           ; st(0) = x     st(1) = 1
    FADDP st(1), st ; st(0) = x + 1           
    FLD1            ; st(0) = 1     st(1) = x + 1
    FLD X           ; st(0) = x     st(1) = 1     st(2) = x + 1
    FSUBP st(1), st ; st(0) = 1 - x st(1) = x + 1
    FDIVP st(1), st ; st(0) = (1 + x)/(1 - x)
    FLD1            ; st(0) = 1     st(1) = (1 + x)/(1 - x)
    FPATAN          ; st(0) = arctan(((1 + x)/(1 - x))/1)
    FLD FOUR        ; st(0) = 4     st(1) = arctan(((1 + x)/(1 - x))/1)
    FDIVP st(1), st ; st(0) = arctan(((1 + x)/(1 - x))/1)/4
    FSTP Y

    call printRealNumber

    ret
main endp

printRealNumber proc
    mov cx, 4
print:
    mov bp, cx
    dec bp
    push cx
    mov al, byte ptr Y + bp
    mov bl,al
    mov cx,8
ob1:
    shl bl,1
    jc ob2
    printSymbolMacro 30H
    jmp ob3
ob2:
    printSymbolMacro 31H
ob3:
    loop ob1
    spaceMacro
    pop cx
    loop print
    ret
printRealNumber endp

LAB6 ends
end begin