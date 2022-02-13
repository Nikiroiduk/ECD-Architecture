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

LAB5 segment 'code'
assume cs:LAB5, ds:LAB5, ss:LAB5, es:LAB5
org 100H
begin: jmp main
   
main proc near
    ; Variant №5
    ; Определить состояние мыши и координаты курсора после нажатия на
    ; клавишу, вывести информацию в заданное положение на экране и продолжить
    ; работу после нажатия на ту же клавишу.
    ;   Примечание: программа должна производить инициализацию мыши и
    ;   выдавать в начале работы на экран информацию об ее типе. По окончании работы –
    ;   нажатию ключевой клавиши на клавиатуре – мышь должна быть отключена и
    ;   восстановлен первоначальный видеорежим.

    ret
main endp

LAB5 ends
end begin