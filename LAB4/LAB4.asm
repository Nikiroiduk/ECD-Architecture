LAB4 segment 'code'
assume cs:LAB4, ds:LAB4, ss:LAB4, es:LAB4
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
       count dw ?
       character dw ?
       Z dw ?
       X dw ?
       Y dw ?
       A dw ?
       B dw ?
       Y1 dw ?
       Y2 dw ?
       A1 dw ?
       A2 db ?
       address dw ?

MAIN proc near
     ; Variant №5
; Exercise 1
     ; 5A4B
     call EXERCISE1
;
; Exercise 2
     ; Z = (A – B) / 5, X
     mov A,10
     mov B,3
     mov X,5
     ; calc Z
     mov ax,A
     sub ax,B
     mov bl,5
     idiv bl
     cbw
     mov Z,ax
     ;
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
;    
     mov ah,04CH
     int 21H
     ret
MAIN endp

EXERCISE1 proc near
          ; 0, if i = 0 and i + 1 = 0
          ; 1, if i = 0 and i + 1 = 1
          ; 2, if i = 1 and i + 1 = 0
          ; 3, if i = 1 and i + 1 = 1, i = variant = 5
          mov ax,5A4BH
          and ax,0000000000110000B ; ax * mask  == 0000 0000 00XX 0000
          cmp ax,0
          jz zz                    ; jump if ax == 0000 0000 0000 0000
          cmp ax,10H
          jz zo                    ; jump if ax == 0000 0000 0001 0000
          cmp ax,20H
          jz oz                    ; jump if ax == 0000 0000 0010 0000
          cmp ax,30H
          jz oo                    ; jump if ax == 0000 0000 0011 0000

zz:       mov ax,0
          jmp fin
zo:       mov ax,1
          jmp fin
oz:       mov ax,2
          jmp fin
oo:       mov ax,3
          jmp fin
fin:      mov data,ax
          call DISP 
          ret
EXERCISE1 endp

EXERCISE2 proc near
          pop address
          pop X
          pop Z

          ; Y1=(100+A1)/A2
          mov A1,12
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
          jz zez    ; if Z and X = 0
          jl zlz    ; if Z and X < 0
          jg zhz    ; if Z and X > 0

zez:      cmp X,0
          jz xez
          jmp els
xez:      mov Y,1
          jmp finex2

zlz:      cmp X,0
          jl xlz
          jmp els
xlz:      mov Y,0
          jmp finex2

zhz:      cmp X,0
          jg xhz
          jmp els
xhz:      mov Y,2
          jmp finex2

els:      mov Y,3   ; else
          jmp finex2

finex2:   push Y
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
               jnz nz      ; if Y1 <> 0
ez:            mov Y2,'AA'
nz:            mov Y2,'BB'

               push address

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
LAB4 ends
end begin