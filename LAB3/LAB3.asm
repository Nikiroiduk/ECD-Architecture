LAB3 segment 'code'
assume cs:LAB3, ds:LAB3, ss:LAB3, es:LAB3
org 100h
begin: jmp main
       ;------------------------------------------------------------
       data dw ?
       my_s db '+'
       T_Th db ?
       Th db ?
       Hu db ?
       Tens db ?
       Ones db ?
       ;------------------------------------------------------------
       ans dw ?
MAIN proc near
     ;a--------------------------------------------------------------
     ;3 x 5----------------------------------------------------------
     mov al,3
     mov bl,5
     imul bl
     push ax
     ;(1982 - 1875)/25 + 497-----------------------------------------
     mov ax,1982
     sub ax,1857
     ;/25
     cwd
     mov bx,25
     idiv bx
     ;+ 497
     add ax,497
     mov ans,ax
     ;+ 15
     pop ax
     add ax,ans
     ;a end---------------------------------------------------------
     ;print a
     mov data,ax
     call DISP

     
     ;b-------------------------------------------------------------
     ;(12 - 10)
     mov ax,12
     sub ax,10
     push ax 
     ;(12 x 14)
     mov al,12
     mov bl,14
     imul bl
     ;(12 - 10) x (12 x 14)
     mov bx,ax
     pop ax
     imul bx
     push ax
     ;(1920 - 820)
     mov ax,1920
     sub ax,820
     push ax
     ;(120 - 10)
     mov ax,120
     sub ax,10
     ;(1920 - 820) / (120 - 10)
     mov bx,ax
     pop ax
     cwd 
     idiv bx
     push ax
     ;(12 - 7)
     mov ax,12
     sub ax,7
     ;(12 - 7) x ((1920 - 820) / (120 - 10))
     mov bx,ax
     pop ax
     imul bx
     ;((12 - 7) x ((1920 - 820) / (120 - 10))) + ((12 - 10) x (12 x 14))
     mov bx,ax
     pop ax
     add ax,bx
     ;b end---------------------------------------------------------
     ;print b
     mov data,ax
     call DISP
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
     ;--- Получаем десятки тысяч ---------------
     @m1: mov ax,data
     @m2: cwd
     mov bx,10000
     idiv bx
     mov T_Th,al
     ;------- Получаем тысячи ------------------------------
     mov ax,dx
     cwd
     mov bx,1000
     idiv bx
     mov Th,al
     ;------ Получаем сотни ---------------
     mov ax,dx
     mov bl,100
     idiv bl
     mov Hu,al
     ;---- Получаем десятки и единицы ----------------------
     mov al,ah
     cbw
     mov bl,10
     idiv bl
     mov Tens,al
     mov Ones,ah
     ;--- Выводим знак -----------------------
     cmp my_s,'+'
     je @m500
     mov ah,02h
     mov dl,my_s
     int 21h
     ;---------- Выводим цифры -----------------
     @m500: cmp T_TH,0 ; проверка на ноль
     je @m200
     mov ah,02h ; выводим на экран, если не ноль
     mov dl,T_Th
     add dl,48
     int 21h
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
     int 21h
     mov ah,02h
     mov dl,10
     int 21h
     mov ah,02h
     mov dl,13
     int 21h
     ;-------------------------------------
     mov ah,08
     int 21h
     ret
DISP endp
LAB3 ends
end begin