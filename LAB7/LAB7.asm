LAB7 segment 'code'
assume cs:LAB7, ds:LAB7, ss:LAB7, es:LAB7
org 100h
begin: jmp main
    ; numbers in names is an evil...
    ; problems with next numbers: 66, 14, 32, 65, 75, 80, 84, 89, 97, 98
    ; ASCII                       B   SO  spc A   K   P   T   Y   a   b
    planes db 22,'Boeing        ',91,'Boeing        '
           db 96,'Boeing        ',95,'Ty            '
           db 90,'Ty            ',54,'Yak           '
           db 87,'Airbus        ',99,'Airbus        '
           db 57,'King Air i    ',70,'Piaggio Avanti'

    arrSize dw 99H
    itemLength db 0EH

    result db 14 dup(?), '$'
    input db 3,3 dup(?)
    speed db ?
    exception db 'There is no plane with such speed($'
    return db 0AH,0DH,'$'
    helper db 'Input plane speed:$'
main proc near
    ; Variant №5
    ; По максимальной скорости самолета определить его марку.

    mov ah,09H
    lea dx,helper
    int 21H

    call numberIn

    mov ah,09H
    lea dx,return
    int 21H

    cld
    mov cx,arrSize
    lea di,planes
    mov al,speed
    repne scasb
    je searhPlane

    mov ah,09H
    lea dx,exception
    int 21H
    jmp except

    searhPlane:
    cld
    mov si,di
    lea di,result
    mov cl,itemLength
    rep movsb

    mov ah,09H
    lea dx,result
    int 21H

    except:
    mov ah,08H
    int 21H
    ret
main endp

; gets user input (number from 0 to 99)
numberIn proc
    mov ah,0AH
    lea dx,input
    int 21H

    mov bl,[input+2]
    sub bl,30H
    mov al,0AH
    imul bl

    mov bl,[input+3]
    sub bl,30H

    add al,bl
    mov speed,al
    ret
numberIn endp

LAB7 ends
end begin