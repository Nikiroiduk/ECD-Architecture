LAB4_1 segment 'code'
assume cs:LAB4_1, ds:LAB4_1, ss:LAB4_1, es:LAB4_1
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
       address dw ?
       addressSupp dw ?
       variant db ?
       number dw ?

MAIN proc near
     ; Exercise 1
     ; Variant №5
     call EXERCISE1

     mov ah,04CH
     int 21H
     ret
MAIN endp

EXERCISE1 proc near
          ; 0, if i = 0 and i + 1 = 0
          ; 1, if i = 0 and i + 1 = 1
          ; 2, if i = 1 and i + 1 = 0
          ; 3, if i = 1 and i + 1 = 1,
          ; i = variant
          pop address

          mov variant,5
          mov number,5A4BH
          call GENBITS

          pop bx
          mov ax,number  ; 5A4B       == 0101 1010 0100 1011
          and ax,bx      ; ax * mask  == 0000 0000 0XX0 0000

          mov cx,3
          cmp ax,bx
          jz fin         ; jump if ax == 0000 0000 0110 0000

          pop bx
          mov cx,2
          cmp ax,bx
          jz fin         ; jump if ax == 0000 0000 0100 0000

          pop bx
          mov cx,1
          cmp ax,bx
          jz fin         ; jump if ax == 0000 0000 0010 0000

          mov cx,0       
          cmp ax,0
          jz fin         ; jump if ax == 0000 0000 0000 0000

fin:      mov data,cx
          call DISP 

          push address
          ret
EXERCISE1 endp

GENBITS proc near

        pop addressSupp

        mov cl,variant
        mov bx,1
        rcl bx,cl
        push bx

        mov bx,2
        rcl bx,cl
        push bx

        mov bx,3
        rcl bx,cl
        push bx

        push addressSupp
        ret

GENBITS endp

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
     je @m500
     mov ah,02h
     mov dl,my_s
     int 21h
@m500: cmp T_TH,0
     je @m200
 
     mov ah,02h
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
     mov ah,08
     int 21h
     ret
DISP endp

LAB4_1 ends
end begin