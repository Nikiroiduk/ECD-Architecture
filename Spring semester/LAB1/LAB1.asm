LAB1 segment 'code'
assume cs:LAB1, ds:LAB1, ss:LAB1, es:LAB1
org 100h
begin: jmp main
    ; problems with next numbers: 66, 14, 32, 65, 75, 80, 84, 89, 97, 98
    ; ASCII                       B   SO  spc A   K   P   T   Y   a   b
    employees db 99,'Director   ',20,'Middle     '
              db 33,'Manager    ',30,'Senior     '
              db 88,'Top Manager',50,'Team Leed  '
              db 65,'Specialist ',10,'Intern     '
              db 15,'Junior     ',90,'Head       '

    arrSize dw 78H
    itemLength db 0AH

    result db 14 dup(?), '$'
    input db 3,3 dup(?)
    salary db ?
    exception db 'There is no position with this salary($'
    return db 0AH,0DH,'$'
    helper db 'Enter salary:$'
main proc near
    ; Variant №5 + 1
    ; По размеру зарплаты определить должность.

    mov ah,09H
    lea dx,helper
    int 21H

    call numberIn

    mov ah,09H
    lea dx,return
    int 21H

    cld
    mov cx,arrSize
    lea di,employees
    mov al,salary
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

    cmp bl,30H
    jge ok
    mov bl,0AH
    idiv bl
    mov salary,al
    ret
ok:
    sub bl,30H
    add al,bl
    mov salary,al
    ret
numberIn endp

LAB1 ends
end begin