indexMacro macro term
    local lp, fin
    mov bl,term
    mov cx,25
    mov bp,0
    lp:
    mov al,list+bp
    cmp al,bl
    jg fin
    inc bp
    loop lp
    fin:
    mov result,bp
endm

spaceMacro macro
    mov ah,02H
    mov dl,20H
    int 21H
endm

returnMacro macro
    mov ah,09H
    lea dx,newLine
    int 21H
endm

LAB2 segment 'code'
assume cs:LAB2, ds:LAB2, ss:LAB2, es:LAB2
org 100h
begin: jmp main
list db 11, 12, 14, 16, 21
     db 23, 23, 23, 31, 32
     db 33, 39, 41, 43, 45
     db 45, 48, 48, 54, 56
     db 58, 78, 82, 82, 98
input db 3,3 dup(?)
num db 0
data db ?
result dw ?
helper db 'Enter your number: $'
newLine db 0AH, 20H, '$'
tens db ?
ones db ?

main proc near
    ; Variant №5
    ; В зависимости от переданного через параметр числа вставляет его на
    ; свое место в список из 25 упорядоченных по возрастанию элементов.

    call prtList
    
    returnMacro
    lea dx,helper
    int 21H
    call numberIn
    
    indexMacro num
    returnMacro

    call prtList  
    ret
main endp

;TODO: переписать эту штуку для вывода списка (добавления эемента на его индекс)
prtList proc
    mov cx,25
    mov bp,0
    meh:
    cmp bp,result
    jnz cnt
    cmp num,0
    jz cnt
    jmp fine
    strangething:
    mov al,num
    mov data,al
    call prntNum
    jmp fin3
    fine:
    mov al,num
    mov data,al
    call prntNum
    spaceMacro
    cnt:
    mov al,list + bp
    mov data,al
    call prntNum
    spaceMacro
    inc bp
    cmp bp,result
    jz strangething
    fin3: loop meh
    ret
prtList endp

prntNum proc
    mov al,data
    cbw
    mov bl,0AH
    idiv bl
    mov tens,al
    mov ones,ah
    mov ah,02
    mov dl,tens
    add dl,30H
    int 21H
    mov ah,02
    mov dl,ones
    add dl,30H
    int 21H
    spaceMacro
    ret
prntNum endp

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
    mov num,al
    ret
ok:
    sub bl,30H
    add al,bl
    mov num,al
    ret
numberIn endp

LAB2 ends
end begin