; Variant #2
; Составить программу «будильник», выдающую на экран строку
; «Время истекло!» после запуска по истечении некоторого промежутка
; времени (в секундах). Время задержки задается в командной строке.
; Используйте прерывание 08H или 1CH и 10H.

printLineMacro macro line
    push ax
    push dx
    mov  ah, 09H
    lea  dx, line
    int  21H
    pop  dx
    pop  ax
endm

LAB2 segment 'code'
assume cs:LAB2, ds:LAB2, ss:LAB2, es:LAB2
org 100H
begin: jmp main

    programmAlreadyUpHelper db  'Programm already in device memory!$'
    helpTextHelper          db  '------------------------------------', 0AH, 0DH, \
                                '| In order to use this program you |', 0AH, 0DH, \
                                '| should enter number of seconds   |', 0AH, 0DH, \
                                '| to wait and press <F1>           |', 0AH, 0DH, \
                                '|----------------------------------|', 0AH, 0DH, \
                                '| Example:                         |', 0AH, 0DH, \
                                '| D:\> 5 (press <F1>) will wait 5  |', 0AH, 0DH, \
                                '| seconds and then print "Time is  |', 0AH, 0DH, \
                                '| up!" on the screen               |', 0AH, 0DH, \
                                '------------------------------------', 0AH, 0DH, '$'
    timeIsUp                db  'Time is up!'
    cursorX                 db  ?
    cursorY                 db  ?
    timerStarted            db  0
    t                       dw  ?
    lMessage                equ $ - timeIsUp

    timer proc far
        push ds ax bx cx dx si di bp
        cmp timerStarted, 0
        jz fin
        mov ax, word ptr cs:t
        mov bl, 18
        idiv bl

        cmp al, 0
        jz timesUp
        dec word ptr cs:t

        mov ah,02h
        mov bh,0
        mov dh,24
        mov dl,79
        int 10H
        mov ah,09
        mov bh,0
        add al,30h
        mov cx,1
        mov bl,1Eh
        int 10h
        jmp fin

    timesUp:
        mov ah,02h
        mov bh,0
        mov dh,24
        mov dl,79
        int 10H
        mov ah,09
        mov bh,0
        add al,''
        mov cx,1
        mov bl,1Eh
        int 10h

        mov bh, 0H
        mov cx, lmessage
        mov dh, 24
        mov dl, 79
        sub dl, lMessage
        push cs
        pop es
        mov bp, offset timeIsUp
        mov ah, 13H
        int 10h

        mov ah, 2H
        mov bh, 0
        mov dl, cursorX
        mov dh, cursorY
        int 10H

        dec timerStarted

    fin:
        int 61h
        pop bp di si dx cx bx ax ds
        iret
    timer endp

    keyboard proc
        push ds ax bx cx dx si di bp

        in al, 60H
        cmp al, 3BH
        je meh
        pop bp di si dx cx bx ax ds
        int 60H
        iret
        
    meh:
        mov ah, 3H
        mov bh, 0H
        int 10H

        mov cursorX, dl
        mov cursorY, dh
        
        mov ah, 2H
        mov bh, 0H
        dec dl
        int 10H

        mov ah, 8H
        mov bh, 0H
        int 10H

        sub al, 30H
        cbw
        mov bl, 18
        imul bl

        add ax, 18
        mov word ptr cs:t, ax

        inc timerStarted

        pop bp di si dx cx bx ax ds
        mov al, 20H
        out 20H, al
        iret
        finish equ $
    keyboard endp

    main proc near     

        mov ah, 35H
        mov al, 60H
        int 21H
        cmp bx, 0H
        je fine

        printLineMacro programmAlreadyUpHelper
        ret

    fine:
        printLineMacro helpTextHelper
        mov ah, 35H
        mov al, 8H
        int 21H

        cli
        push ds
        mov dx, bx
        push es
        pop ds
        mov ah, 25H
        mov al, 61H
        int 21H
        pop ds
        sti

        lea dx, timer
        mov ah, 25H
        mov al, 8H
        int 21H


        mov ah, 35H
        mov al, 9H
        int 21H

        cli
        push ds
        mov dx, bx
        push es
        pop ds
        mov ah, 25H
        mov al, 60H
        int 21H
        pop ds
        sti

        mov ah, 25H
        mov al, 9H
        lea dx, keyboard
        int 21H

        lea dx, finish
        int 27H
        ret
    main endp
    LAB2 ends
end begin