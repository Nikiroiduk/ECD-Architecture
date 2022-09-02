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

printLineMacro macro line
    push ax
    push dx
    mov ah, 09H
    lea dx, line
    int 21H
    pop dx
    pop ax
endm

printInputHelpMacro macro lineStart, term, lineEnd
    push ax
    printLineMacro lineStart
    mov ax, term
    mov data, ax
    call numberOut
    printLineMacro lineEnd
    pop ax
endm

LAB4 segment 'code'
assume cs:LAB4, ds:LAB4, ss:LAB4, es:LAB4
org 100H
begin: jmp main
    cols dw 3
    rows dw 5
    array dw 100 dup(?)

    newLineHelper db 0AH, 0DH, '$'
    inputHelperStart db 'Enter an element [$'
    inputHelperEnd db ']: $'
    outputHelper db 'Your array:$'
    additionalHelper db 'Numbers satisfying the condition:$'
    resultHelper db 'Sum = $'

    sum dw 0

    buffer db 7, 7 dup(?)
    dataWord dw 0
    multiplier dw ?
    rowSize dw ?
    arrSize dw ?

    data dw ?
    sign db '+'
    tensThousands db ?
    thousands db ?
    hundreds db ?
    tens db ?
    ones db ?

main proc near
    ; Variant №5
    ; Подпрограмма суммирования слов, делящихся на 5, в нечетных строках.

    mov ax, rows
    mov bx, cols
    imul bx
    mov arrSize, ax
    mov ax, cols
    mov bx, 2
    imul bx
    mov rowSize, ax

    mov cx, arrSize
    lea si, array
    mov bx, 0
input:
    push cx
    printInputHelpMacro inputHelperStart, bx, inputHelperEnd
    call numberIn
    mov ax, dataWord
    mov [si], ax
    add si, 2
    pop cx
    inc bx
    loop input

    printLineMacro newLineHelper
    printLineMacro outputHelper
    printLineMacro newLineHelper
    mov cx, rows
    mov bx, 0
nRow:
    push cx
    mov cx, cols
    mov si, 0
nElem:
    mov ax, array[bx][si]
    mov data, ax
    call numberOut
    spaceMacro
    add si, 2
    loop nElem
    add bx, rowSize
    printLineMacro newLineHelper
    pop cx
    loop nRow

    printLineMacro newLineHelper
    printLineMacro additionalHelper
    printLineMacro newLineHelper
    mov bx, 0
    mov cx, rows
    mov dx, 0
    mov ax, 2
    cwd
    idiv cx
    cmp dx, 0
    jnz calc
    dec cx
calc:
    push cx
    mov cx, cols
    mov si, 0
elem:
    mov ax, array[bx][si]
    push ax
    push bx
    cwd
    mov bx, 5
    idiv bx
    pop bx
    pop ax
    cmp dx, 0
    jnz false
    add sum, ax
    mov data, ax
    call numberOut
    spaceMacro
    cmp cx, 0
    jnz false
    printLineMacro newLineHelper
false:
    add si, 2
    loop elem
    add bx, rowSize
    add bx, rowSize
    pop cx
    sub cx, 2
    cmp cx, 0
    jge calc

    printLineMacro newLineHelper
    printLineMacro resultHelper
    mov ax, sum
    mov data, ax
    call numberOut

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

numberIn proc near
    push ax
    push bx
    push cx
    push dx
    mov dataWord, 0
    mov ah, 0AH
    lea dx, buffer
    int 21H
    mov multiplier, 1
    mov cl, byte ptr buffer + 1
    mov ch, 0
    mov bp, cx
    add bp, 1
@m1000:
    mov al, byte ptr buffer + bp
    sub al, 30H
    cbw
    imul multiplier
    add dataWord, ax
    mov ax, 10
    imul multiplier
    mov multiplier, ax
    sub bp, 1
    loop @m1000
    printLineMacro newLineHelper
    pop dx
    pop cx
    pop bx
    pop ax
    ret
numberIn endp

LAB4 ends
end begin