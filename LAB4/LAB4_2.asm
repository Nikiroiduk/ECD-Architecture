LAB4_2 segment 'code'
assume cs:LAB4_2, ds:LAB4_2, ss:LAB4_2, es:LAB4_2
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
       A dw ?
       B dw ?
       X dw ?
       Z dw ?
       count dw ?
       character dw ?
       A1 dw ?
       A2 db ?
       Y1 dw ?
       Y dw ?
       Y2 dw ?
       address dw ?

MAIN proc near
     ; Exercise 2
     ; Variant №5
     ; Z = (A – B) / 5, X
     mov A,-6
     mov B,3
     mov X,-2
     ; calc Z
     mov ax,A
     sub ax,B
     mov bl,5
     idiv bl
     cbw
     mov Z,ax
     
     push Z
     push X
     call EXERCISE2
     pop ax
     mov data,ax
     call DISP
     call EXERCISE2PART2

     mov count,2
     mov ax,Y2
     mov character,ax
     call DISPchars

     mov ah,04CH
     int 21H
     ret
MAIN endp

EXERCISE2 proc near
          pop address
          pop X
          pop Z

          ; Y1=(100+A1)/A2
          mov A1,-100
          mov A2,5
          mov ax,A1
          add ax,100
          mov bl,A2
          idiv bl
          cbw
          mov Y1,ax
          push Y1

          ; Y = 0, if Z < 0 and X < 0
          ; Y = 1, if Z = 0 and X = 0
          ; Y = 2, if Z > 0 and X > 0
          ; else Y = 3
          cmp Z,0
          jz zez    ; if Z = 0 and X = 0
          jl zlz    ; if Z < 0 and X < 0
          jg zhz    ; if Z > 0 and X > 0

zez:      cmp X,0
          jz xez
          jmp els
xez:      mov Y,1
          jmp fin

zlz:      cmp X,0
          jl xlz
          jmp els
xlz:      mov Y,0
          jmp fin

zhz:      cmp X,0
          jg xhz
          jmp els
xhz:      mov Y,2
          jmp fin

els:      mov Y,3   ; else
          jmp fin

fin:      push Y

          push address
          ret
EXERCISE2 endp

EXERCISE2PART2 proc near
               pop address
               pop Y1

               ; Y2 = AA, if Y1 = 0
               ; Y2 = BB, if Y1 <> 0
               cmp Y1,0
               jz ez       ; if Y1 = 0
               jne nz      ; if Y1 <> 0
ez:            mov Y2,'AA'
               jmp final

nz:            mov Y2,'BB'
               jmp final

final:         push address
               ret
EXERCISE2PART2 endp

DISPchars proc near
          mov cx,count
prnt:     mov dx,character
          mov ah,02H
          int 21H
          inc dx
          loop prnt
          ret
DISPchars endp

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

LAB4_2 ends
end begin