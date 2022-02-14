spaceMacro macro
    push ax
    push dx
    mov ah,02H
    mov dl,20H
    int 21H
    pop dx
    pop ax
endm

printLineMacro macro line
    push ax
    push dx
    mov ah,09H
    lea dx,line
    int 21H
    pop dx
    pop ax
endm

LAB3 segment 'code'
assume cs:LAB3, ds:LAB3, ss:LAB3, es:LAB3
org 100H
begin: jmp main
    dataWord dw ?
    my_s db '+'
    T_Th db ?
    Th db ?
    Hu db ?
    Tens db ?
    Ones db ?
    input db 7,7 dup(?)
    dataev dw 0
    mnoj dw ?

    newLine db 0AH, 0DH, '$'
    resultHelper db 'Z = S{k * X[k + 1]/(k + 1) - X[2k + 1] * X[N + 1 - k]} = $'
    inputHelper db 'Enter an array of 8 elements:$'
    outputHelper db 'Your array: $'

    X dw 8 dup(?)
    num dw ?
    sum dw 0
    k dw ?
    step dw ?
    N dw 4

main proc near
    ; Variant №5
    ; Z = S{k*X[k+1]/(k+1)-X[2k+1]*X[N+1-k]}
    ; N=4 k=1,2,3

    printLineMacro inputHelper
    printLineMacro newLine
    mov cx,8
    lea si,X
inpt:
    push cx
    call numberIn
    mov ax,num
    mov [si],ax
    add si,2
    printLineMacro newLine
    pop cx
    loop inpt

    printLineMacro outputHelper
    mov cx,8
    lea si,X
output:
    push cx
    mov ax,[si]
    mov dataWord,ax
    call disp
    add si,2
    spaceMacro
    pop cx
    loop output
    
    printLineMacro newLine
    printLineMacro resultHelper
    mov cx,3
result:
    lea si,X
    mov k,cx
    inc k
    mov ax,k
    mov bx,2
    imul bx
    add si,ax ; offset [k + 1]
    mov ax,[si]
    dec k
    imul k
    push ax ; ax = k * X[k + 1]

    mov k,cx
    inc k
    mov ax,k
    push ax ; ax = k + 1
    dec k

    mov ax,k
    mov bl,2
    imul bl
    inc ax ; 2k + 1
    imul bl
    lea si,X
    add si,ax
    mov ax,[si]
    push ax ; ax = X[2k + 1]

    mov ax,N
    inc ax
    sub ax,k
    mov bl,2
    imul bl ; ax = offset X[N + 1 - k]
    lea si,X
    add si,ax
    mov ax,[si]
    push ax

    pop ax
    pop bx
    imul bx
    push ax ; ax = X[2k + 1] * X[N + 1 - k]
    pop bx ; k + 1
    pop ax ; k * X[k + 1]
    cwd
    idiv bx ; k * X[k + 1] / k + 1
    pop bx
    sub ax,bx
    add sum,ax
    loop result

    mov ax,sum
    mov dataWord,ax
    call disp
    ret
main endp

numberIn proc near
    mov num,0
    mov ah,0AH
    lea dx,input
    int 21H
    mov mnoj,1
    mov cl,byte ptr input+1
    mov ch,0
    mov bp,cx
    add bp,1
    @m1000:
    mov al,byte ptr input+bp
    sub al,30H
    cbw
    imul mnoj
    add num,ax
    mov ax,10
    imul mnoj
    mov mnoj,ax
    sub bp,1
    loop @m1000
    ret
numberIn endp

disp proc near
     push ax
     push bx
     push cx
     push dx
     mov ax,dataWord
     and ax,1000000000000000b
     mov cl,15
     shr ax,cl
     cmp ax,1
     jne @m1
     mov ax,dataWord
     neg ax
     mov my_s,'-'
     jmp @m2
     @m1: mov ax,dataWord
     @m2: cwd
     mov bx,10000
     idiv bx
     mov T_Th,al
     mov ax,dx
     cwd
     mov bx,1000
     idiv bx
     mov Th,al
     mov ax,dx
     mov bl,100
     idiv bl
     mov Hu,al
     mov al,ah
     cbw
     mov bl,10
     idiv bl
     mov Tens,al
     mov Ones,ah
     cmp my_s,'+'
     je @m500
     mov ah,02H
     mov dl,my_s
     int 21H
     @m500: cmp T_TH,0
     je @m200
     mov ah,02H
     mov dl,T_Th
     add dl,48
     int 21H
     @m200: cmp T_Th,0
     jne @m300
     cmp Th,0
     je @m400
     @m300: mov ah,02H
     mov dl,Th
     add dl,48
     int 21H
     @m400: cmp T_TH,0
     jne @m600
     cmp Th,0
     jne @m600
     cmp hu,0
     je @m700
     @m600: mov ah,02H
     mov dl,Hu
     add dl,48
     int 21H
     @m700: cmp T_TH,0
     jne @m900
     cmp Th,0
     jne @m900
     cmp Hu,0
     jne @m900
     cmp Tens,0
     je @m950
     @m900: mov ah,02H
     mov dl,Tens
     add dl,48
     int 21H
     @m950: mov ah,02H
     mov dl,Ones
     add dl,48
     int 21H
     mov ah,02H
     mov dl,' '
     int 21H
     pop dx
     pop cx
     pop bx
     pop ax
     ret
disp endp

LAB3 ends
end begin