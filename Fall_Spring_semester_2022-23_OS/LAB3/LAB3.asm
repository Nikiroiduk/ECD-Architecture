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

    delays dw  40, 40, 40, 40, 50, 40, 40, 40, \
               40, 50, 40, 50, 40, 40, 50, 40, \
               40, 40, 40, 40, 50, 50

    len    equ $ - delays



    data                       dw ?
    sign                       db '+'
    tensThousands              db ?
    thousands                  db ?
    hundreds                   db ?
    tens                       db ?
    ones                       db ?

    main proc near
        printLineMacro startProgramHelper
        mov ah, 8H
        int 21H
        xor cx, cx
    meh:
        lea si, freqs
        add si, cx
        mov di, [si]
        
        lea si, delays
        add si, cx
        mov bx, [si]
        call SOUND

        add cx, 2
        cmp cx, len
        jz fin
        jmp meh
    fin:
    
        ret
    main endp

    SOUND    PROC   near
         push   ax
         push   cx
         push   dx
         push   ds
         push   es
         push   si
;-----------------------------------------------------------
         in     al,61h            ;  Read current port mode B (8255)
         mov    cl,al             ;  Save current mode
         or     al,3              ;  Switch on speaker and timer
         out    61h,al            ;
         mov    al,0B6h           ;  set for channel  2 (8253)
         out    43h,al            ;  command register  8253
         mov    dx,14h            ;
         mov    ax,4F38h          ;  divisor of frequency
         div    di                ;
         out    42h,al            ;  lower byte of frequency
         mov    al,ah             ;
         out    42h,al            ;  higher byte of frequency
;  Generation of sound delay 
         mov    ax,91             ;  multiplier  -  AX register !
         mul    bx                ;  AX =BX*91 (result in   DX:AX)
         mov    bx,500            ;  divisor, dividend in   DX:AX
         div    bx                ;  result in   AX, remainder in DX 
         mov    bx,ax             ;  save result
         mov    ah,0              ;  read time
         int    1Ah               ;
         add    dx,bx             ;
         mov    bx,dx             ;
Cycle:   int    1Ah               ;
         cmp    dx,bx             ;  Has time gone ?
         jne    Cycle             ;
         in     al,61h            ;  Read mode of port B (8255)
         mov    al,cl             ;  Previous mode 
         and    al,0FCh           ;
         out    61h,al            ;  Restore mode
;-----------------------------------------------------------
;  Restoring registers and exit
Exit:    pop    si                ;
         pop    es                ;
         pop    ds                ;
         pop    dx                ;
         pop    cx                ;
         pop    ax                ;
         ret                      ;  exit from subroutine
SOUND    ENDP

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

    LAB3 ends
end begin