; Variant #2
; Выдача «подсказки» по ключу /? во время запуска программы.


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

LAB4 segment 'code'
assume cs:LAB4, ds:LAB4, ss:LAB4, es:LAB4
org 100H
begin: jmp main
    klav proc far
        push ds es ax bx cx dx si di bp
        ; ***** 1 - получаем скан-код из порта 60h
        in al,60h
        mov ah,al
        push ax

        ; ***** 2 - посылаем сигнал подтверждения
        in al,61h
        or al,10000000b
        out 61h,al
        and al,01111111b
        out 61h,al
        mov ax,0040h
        mov es,ax
        mov bl,00000010B
        or es:[0017H],bl
        pop ax ; достаем из стека скан-код
        ; **** 3 - проверяем клавишу переключатель ****
        ; cmp al,2Ah
        ; jne l_shift_otjat
        ; левый shift нажат
        ; mov bl,00000010b
        ; or es:[0017h],bl
        ; ; Выводим РУС
        ; push es
        ; push cs
        ; pop es
        ; mov ah,13h
        ; lea bp,cs:sr
        ; mov cx,3
        ; mov dh,0
        ; mov dl,77
        ; mov bh,0
        ; mov al,0
        ; mov bl,1Eh
        ; int 10h
        ; pop es
        ; jmp quit
        ; l_shift_otjat:
        ; cmp al,0AAh
        ; jne next_key
        ; ; левый shift отжат
        ; mov bl,11111101b
        ; and es:[0017h],bl
        ; ; Выводим АНГ
        ; push es
        ; push cs
        ; pop es
        ; mov ah,13h
        ; lea bp,cs:sa
        ; mov cx,3
        ; mov dh,0
        ; mov dl,77
        ; mov bh,0
        ; mov al,0
        ; mov bl,1Eh
        ; int 10h
        ; pop es

        ; jmp quit
        ; next_key:
        ; ; проверяем на отжатые клавиши
        ; test al,10000000b
        ; jnz quit
        ; ; проверяем нажат ли левый Shift
        ; mov bl,es:[0017h]

        ; test bl,00000010b
        ; jz conv
        ; ; русские буквы
        ; add al,58
        ; **** 4 - преобразуем скан-код в ASCII-код
        ; conv: lea bx,cs:table
        ; xlat cs:table
        ; cmp al,0
        ; je quit
        ; ; **** 5 - помещаем ASCII-код в буфер клавиатуры
        mov bx,001Ah ; адрес адреса головы
        mov cx,es:[bx] ; сx - адреса головы
        mov di,es:[bx]+2 ; di -адрес хвоста
        cmp cx,60 ; голова на вершине буфера
        je h_end
        inc cx ; увеличиваем голову на 2
        inc cx
        cmp cx,di
        je quit ; буфер полон
        jmp go_ah ; нормальный случай
        h_end: cmp di,30 ; хвост в начале буфера
        je quit
        go_ah: mov es:[di],al ; заносим ASCII-код по адресу хвоста
        cmp di,60 ; хвост на вершине буфера
        jne no_w
        mov di,28
        no_w: add di,2
        mov es:[bx]+2,di ; новое значение хвоста по адресу [0040:001C]
        quit:
        pop bp di si dx cx bx ax es ds
        mov al,20h
        out 20h,al
        iret
        finish EQU $
    klav endp
; ********************************************
    main proc near
    
        cli
        lea dx,klav

        mov ah,25h
        mov al,9
        int 21h
        sti
        
        lea dx,finish
        int 27h
        ret
    main endp
    LAB4 ends
end begin