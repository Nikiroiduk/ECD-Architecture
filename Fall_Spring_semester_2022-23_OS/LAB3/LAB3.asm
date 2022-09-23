; Variant #2
; Написать программу проигрывания мелодии.
; Таблица номеров частот и длительностей нот: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
; 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22.
; Таблица частот: 1709, 1809, 2031, 2280, 1521, 1709, 1809, 2031, 2280, 1521,
; 1709, 1353, 1709, 1809,1521,1809, 2031, 1809, 1709, 2031, 2280, 1139.
; Таблица задержек: 4, 4 ,4, 4, 5, 4, 4, 4, 4, 5, 4, 5, 4, 4, 5, 4, 4, 4, 4, 4, 5, 5.
; Генерацию звука производить путём программирования таймера.


printSymbolMacro macro symbol
    push ax
    push dx
    mov  ah, 02H
    mov  dx, symbol
    int  21H
    pop  dx
    pop  ax
endm

printLineMacro macro line
    push ax
    push dx
    mov  ah, 09H
    lea  dx, line
    int  21H
    pop  dx
    pop  ax
endm

LAB3 segment 'code'
assume cs:LAB3, ds:LAB3, ss:LAB3, es:LAB3
org 100H
begin: jmp main

    startProgramHelper db 'Press any key to start$'
    freqs  dw  1709, 1809, 2031, 2280, 1521, \
               1709, 1809, 2031, 2280, 1521, \
               1709, 1353, 1709, 1809, 1521, \
               1809, 2031, 1809, 1709, 2031, \
               2280, 1139
    delays dw  4, 4, 4, 4, 5, 4, 4, 4, \
               4, 5, 4, 5, 4, 4, 5, 4, \
               4, 4, 4, 4, 5, 5
    len    equ $ - delays
    freq   dw  ?
    delay  dw  ?
    state  db  ?

    main proc near
        printLineMacro startProgramHelper
        mov  ah, 8H
        int  21H
        xor  ax, ax

        xor  cx, cx
    play:
        lea  si, freqs
        add  si, cx
        mov  ax, [si]
        mov  freq, ax
        
        lea  si, delays
        add  si, cx
        mov  ax, [si]
        mov  delay, ax
        push cx

        in   al, 61H 
        mov  state, al

        or   al, 00000011B
        out  61H, al

        mov  al, 10110110B
        out  43H, al

        mov  ax, freq
        out  42H, al
        mov  al, ah
        out  42H, al
        mov  ah, 0
        
        int  1AH
        add  dx, delay
        mov  delay, dx
    zzz:
        int  1AH
        cmp  dx, delay
        jnz  zzz

        pop  cx
        add  cx, 2
        cmp  cx, len
        jz   fin
        jmp  play

    fin:
        in   al, 61H
        mov  al, state
        and  al, 11111100B
        out  61H, al

        ret
    main endp
    LAB3 ends
end begin