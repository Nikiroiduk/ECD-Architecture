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

LAB5 segment 'code'
assume cs:LAB5, ds:LAB5, ss:LAB5, es:LAB5
org 100H
begin: jmp main

    X dd -1.3
    Y dd ?
    DWA dd 2.0
    CHETIRE dd 4.0
    TIME dd ?

main proc near
    ; Variant №5
    ; Y = arctg((1+x)/(1-x))/4

    ; FINIT ; инициализация математического сопроцессора
    ; FLD X ; ST(0) = x = –1.3
    ; FLD CHETIRE ; ST(0) = 4; ST(1) = x = –1.3
    ; FDIV ; ST(0) = x / 4 = –0.325
    ; FLD X ; ST(0) = –1.3 ST(1) = –0.325
    ; FMUL ; ST(0) = x*x / 4 = 0.4225
    ; FSTP TIME ; TIME = x*x / 4 = 0.4225
    ; FLD X ; ST(0) = x = –1.3
    ; FLD DWA ; ST(0) =2 ST(1) = x = –1.3
    ; FDIV ; ST(0) = x / 2 = –0.65
    ; FADD TIME ; ST(0) = x*x / 4 + x / 2 = –0.65 + 0.4225 = –0.2275
    ; FLD1 ; ST(0) = 1; ST(1) = x*x / 4 + x / 2 = –0.2275
    ; FADD ; ST(0) = x*x / 4 + x / 2+1 = 0.7725
    ; FPTAN ; ST(0) = 1; ST(1) = 0.9745
    ; FSTP X ; X = 1
    ; FSTP Y ; Y = 0.9745

    FINIT
    FLD X
    FSTP Y


    mov ax, word ptr Y
 
 
    mov bx,ax
    shl bx,1
        mov cx,32
ob1:
        shl bx,1
        jc ob2
        
        printSymbolMacro 30H
        jmp ob3
        
ob2:
        printSymbolMacro 31H
ob3:
        loop ob1  


    ret
main endp

LAB5 ends
end begin