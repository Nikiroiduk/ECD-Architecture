LAB5 segment 'code'
assume cs:LAB5, ds:LAB5, ss:LAB5, es:LAB5
org 100h
begin: jmp main
       data dw ?
       my_s db '+'
       T_Th db ?
       Th db ?
       Hu db ?
       Tens db ?
       Ones db ?

       a dw ?
       b dw ?
       r dw 0
       x dw ?
       wh dw ?
       fr dw ?
MAIN proc near
     ; Variant №5
     ; x^3 + 4 [-1, 1] 50
     mov cx,25
     mov a,-25
     mov b,25

lp:  ; a^3 + 4
     mov ax,a
     imul a
     imul a
     add ax,4
     inc a
     mov bx,ax
     ; b^3 + 4
     mov ax,b
     imul b
     imul b
     add ax,4
     dec b
     ; (a^3 + 4) + (b^3 + 4)
     add ax,bx
     ; add to result
     add r,ax
     ; -2 -1 (0 0) 1 2
     ;         ↓
     ; -2 -1  (0)  1 2
     cmp a,0
     jz last
     jmp e
last:add r,4
     jmp e
e:   loop lp

     ; 204 / 25 = 8.16 or 8 + (4 / 25)
     mov ax,r
     mov bl,25
     idiv bl

     mov dl,ah 
     cbw
     mov wh,ax 
     mov ax,0
     mov al,dl
     cbw
     mov fr,ax 

     ; output
     mov ax,wh
     mov data,ax
     call DISP
     mov dx,'+'
     mov ah,02H
     int 21H
     mov dx,'('
     mov ah,02H
     int 21H
     mov ax,fr
     mov data,ax
     call DISP
     mov dx,'/'
     mov ah,02H
     int 21H
     mov ax,25
     mov data,ax
     call DISP
     mov dx,')'
     mov ah,02H
     int 21H

     mov ah,04CH
     int 21H
     ret
MAIN endp

DISP proc near
     mov ax,data
     and ax,1000000000000000b
     mov cl,15
     shr ax,cl
     cmp ax,1
     jne @m1
     mov ax,data
     neg ax
     mov my_s,'-'
     jmp @m2
@m1: mov ax,data
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
@m200: cmp T_Th,0
     jne @m300
     cmp Th,0
     je @m400
@m300: mov ah,02h
     mov dl,Th
     add dl,48
     int 21h
@m400: cmp T_TH,0
     jne @m600
     cmp Th,0
     jne @m600
     cmp hu,0
     je @m700
@m600: mov ah,02h
     mov dl,Hu
     add dl,48
     int 21h
@m700: cmp T_TH,0
     jne @m900
     cmp Th,0
     jne @m900
     cmp Hu,0
     jne @m900
     cmp Tens,0
     je @m950
@m900: mov ah,02h
     mov dl,Tens
     add dl,48
     int 21h
@m950: mov ah,02h
     mov dl,Ones
     add dl,48
     int 21H
     ret
DISP endp

LAB5 ends
end begin