; Variant #5
; Составить программу, выдающую следующую системную
; информацию: версию OC, информацию о диске. Используйте следующие
; функции прерывания 21H:
; 1. Дать версию OC.
; Вход:  AH = 30H
; Выход: AL – старшая часть версии; AH – меньшая часть версии.
; 2. Дать информацию о диске.
; Вход:  AH=36H, DL = код устройства (0 – по умолчанию, 1 – А, 2 – В и т.д.)
; Выход: AX – кол-во секторов на кластер (или 0FFFFH, если ошибка).
;        CX – кол-во байт/сектор;
;        BX – кол-во доступных кластеров;
;        DX – всего кластеров на диске.

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

LAB1 segment 'code'
assume cs:LAB1, ds:LAB1, ss:LAB1, es:LAB1
org 100h
begin: jmp main
    newLineHelper db 0AH, 0DH, '$'
    osVersionHelper db 'OS version: $'
    diskInfoHelper db 'Disk info$'
    sectorsPerClusterHelper db 'Sectors per cluster: $'
    numberOfFreeClustersHelper db 'Number of free clusters: $'
    bytesPerSectorHelper db 'Bytes per sector: $'
    totalClustersOnDriveHelper db 'Total clusters on drive: $'
    totalDriveSpaceHelper db 'Total space on drive: $'
    freeDriveSpaceHelper db 'Free space on drive: $'
    diskErrorHelper db 'Something went wrong :($'
    megaBytesHelper db ' megabytes$'

    diskSize dd ?

    data dw ?
    sign db '+'
    tensThousands db ?
    thousands db ?
    hundreds db ?
    tens db ?
    ones db ?
main proc near
    call task1
    call task2
    ret
main endp

task1 proc
    printLineMacro osVersionHelper
    mov ah, 30H
    int 21H
    mov bl, ah
    cwd
    mov data, ax
    call numberOut
    printSymbolMacro 2EH
    mov al, bl
    cwd
    mov data, ax
    call numberOut
    
    ret
task1 endp

task2 proc
    printLineMacro newLineHelper
    printLineMacro newLineHelper
    printLineMacro diskInfoHelper
    printLineMacro newLineHelper
    mov ah, 36H
    mov dl, 0
    int 21H

    cmp ax, 0FFFFH
    jz error
    jnz continue
error:
    printLineMacro diskErrorHelper
    ret

continue:
    printLineMacro sectorsPerClusterHelper
    mov data, ax
    call numberOut
    printLineMacro newLineHelper

    printLineMacro numberOfFreeClustersHelper
    mov data, bx
    call numberOut
    printLineMacro newLineHelper

    printLineMacro bytesPerSectorHelper
    mov data, cx
    call numberOut
    printLineMacro newLineHelper

    printLineMacro totalClustersOnDriveHelper
    mov data, dx
    call numberOut
    printLineMacro newLineHelper

    printLineMacro totalDriveSpaceHelper
    push dx
    call calcDriveSize
    pop data
    call writeDecimal
    printLineMacro megaBytesHelper
    printLineMacro newLineHelper

    printLineMacro freeDriveSpaceHelper
    push bx
    call calcDriveSize
    pop data
    call writeDecimal
    printLineMacro megaBytesHelper
    printLineMacro newLineHelper

    ret
task2 endp

calcDriveSize proc
    pop si
    pop data
    FINIT
    FILD data
    mov data, ax
    FILD data
    FMUL
    mov data, cx
    FILD data
    FMUL
    mov di, 1024
    mov data, di
    FIDIV data
    FIDIV data
    FISTP diskSize
    mov dx, word ptr diskSize
    push dx
    push si
    ret
calcDriveSize endp

writeDecimal proc
    push ax
    push bx
    push cx
    push dx
    push si
    mov ax, data
    mov si, 10
    xor cx, cx

nonZero:
    xor dx, dx
    div si
    push dx
    inc cx
    or ax, ax
    jnz nonZero

    mov ah,02H

writeDigitLoop:
    pop dx
    add dx, 30H
    int 21H
    loop writeDigitLoop

endDecimal:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
writeDecimal endp

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

LAB1 ends
end begin
