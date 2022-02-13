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
    newLineHelper db 0AH, 0DH, '$'
    mouseButtonsCountHelper db 'Number of mouse buttons: $'
    currentMouseTypeHelper db 'Current mouse type: $'
    mouseType1Helper db 'Bus Mouse$'
    mouseType2Helper db 'Serial Mouse$'
    mouseType3Helper db 'Inport Mouse$'
    mouseType4Helper db 'PS/2 Mouse$'
    mouseType5Helper db 'HP Mouse$'
    pressedKeyHelper db 'To exit press: $'

    currentMode db ?
    pressedKey db ?

    lmb db ?
    rmb db ?
    mmb db ?

    stringXCoord db 35
    stringYCoord db 12
    Xcoord db ?
    Ycoord db ?

    textModeTranslation db 8
    stateString db 11 dup(?)

main proc near
    ; Variant №5
    ; Определить состояние мыши и координаты курсора после нажатия на
    ; клавишу, вывести информацию в заданное положение на экране и продолжить
    ; работу после нажатия на ту же клавишу.
    ;   Примечание: программа должна производить инициализацию мыши и
    ;   выдавать в начале работы на экран информацию об ее типе. По окончании работы –
    ;   нажатию ключевой клавиши на клавиатуре – мышь должна быть отключена и
    ;   восстановлен первоначальный видеорежим.

    ; get current video mode
    mov ah, 0FH
    int 10H
    mov currentMode, al

    ; mouse initialization
    mov ax, 00H
    int 33H

    ; number of mouse buttons 
    printLineMacro mouseButtonsCountHelper
    add bl, 30H
    printSymbolMacro bl
    printLineMacro newLineHelper

    ; mouse type info
    call printMouseType

    ; waiting for any key to be pressed
    mov ah, 00H
    int 16H

    printLineMacro newLineHelper
    printLineMacro pressedKeyHelper
    printSymbolMacro al
    mov pressedKey, al

    ; turn on cursor
    mov ax, 01H
    int 33H

update:
    mov ax, 03H
    int 33H
    test bx,00000001B
    jne lmbPressed
    mov lmb, 0
    jmp nextBtn0
lmbPressed:
    mov lmb, 1
nextBtn0:
    test bx,00000010B
    jne rmbPressed
    mov rmb, 0
    jmp nextBtn1
rmbPressed:
    mov rmb, 1
nextBtn1:
    test bx,00000100B
    jne mmbPressed
    mov mmb, 0
    jmp continue
mmbPressed:
    mov mmb, 1
continue:
    mov ax,cx
    idiv textModeTranslation
    mov Xcoord,al
    mov ax,dx
    idiv textModeTranslation
    mov Ycoord,al
    call formString
    call stringOutputCoordinates
    mov ah, 01H
    int 16H
    jz update
    mov ah, 00H
    int 16H
    cmp al, pressedKey
    jz defVideoMode
    jne update

defVideoMode:
    mov ah, 00H
    mov al, currentMode
    int 10H
    ret
main endp

stringOutputCoordinates proc near
    push cs
    pop es
    mov ah, 13H
    lea bp, stateString
    mov cx, 11
    mov dh, stringYCoord
    mov dl, stringXCoord
    mov al, 0
    mov bl, 1EH
    int 10H
    ret
stringOutputCoordinates endp

formString proc near
    mov al, Xcoord
    inc al
    cbw
    mov bl, 10
    idiv bl
    add al, 30H
    add ah, 30H
    mov bp, 0
    mov [stateString + bp], al
    inc bp
    mov [stateString + bp], ah
    inc bp
    mov [stateString + bp], ' '

    mov al, Ycoord
    inc al
    cbw
    mov bl, 10
    idiv bl
    add al, 30H
    add ah, 30H
    inc bp
    mov [stateString + bp], al
    inc bp
    mov [stateString + bp], ah

    inc bp
    mov [stateString + bp], ' '
    inc bp
    mov al, lmb
    add al, 30H
    mov [stateString + bp], al
    inc bp
    mov [stateString + bp], ' '
    inc bp
    mov al, mmb
    add al, 30H
    mov [stateString + bp], al
    inc bp
    mov [stateString + bp], ' '
    inc bp
    mov al, rmb
    add al, 30H
    mov [stateString + bp], al
    ret
formString endp

printMouseType proc
    printLineMacro currentMouseTypeHelper
    mov ax, 24H
    int 33H
    cmp ch, 1
    jz type1
    cmp ch, 2
    jz type2
    cmp ch, 3
    jz type3
    cmp ch, 4
    jz type4
    cmp ch, 5
    jz type5
type1:
    printLineMacro mouseType1Helper
    ret
type2:
    printLineMacro mouseType2Helper
    ret
type3:
    printLineMacro mouseType3Helper
    ret
type4:
    printLineMacro mouseType4Helper
    ret
type5:
    printLineMacro mouseType5Helper
    ret
printMouseType endp

LAB5 ends
end begin