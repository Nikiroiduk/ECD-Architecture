org 100h
.model small
.stack 100h
.data
     string db 'Input: ',0AH,'$'
     ; data dt 0FFFFFFFFFFFFFFFFFFFFH
     ; data dt 000000000000000000000H
     ; data dt 000000000000000000001H
     ; data dt 00000000000000000000FH
     ; data dt 0000000000000000000FFH
     ; data dt 000000000000FFF000000H
     data dt 0ABCDEF98765432100000H
     max db 0
     outp dw ?
.code
main:
     ; Variant №5
     ; Подсчитать максимальную длину цепочки, состоящую из единиц,
     ; в элементе данных, определенном директивой DT.

     ; print: "Input: ↵"
     mov ax,@data
     mov ds,ax
     mov dx,offset string
     mov ah,09H
     int 21H

     ; outputs the bits of data by byte
     mov cx,10
     mov si,9
deft:mov bl,byte ptr[data+si]
     push cx
     mov cx,8
byt: test bl,10000000B
     je zero
     jmp one
zero:mov ah,02H
     mov dl,'0'
     int 21H
     jmp lp
one: mov ah,02H
     mov dl,'1'
     int 21H
     jmp lp
lp:  shl bl,1
     loop byt
     mov ah,02H
     mov dl,' '
     int 21H
     dec si
     cmp si,-1
     loopnz deft

     ; counts the longest chain of 1 and writes its length to max
     mov ax,0
     mov cx,10
     mov si,9
m1:  mov bl,byte ptr[data+si]
     push cx
     mov cx,8
m2:  test bl,10000000B
     je iz
     inc al
     jmp m3
iz:  cmp al,max
     jle m4
     mov max,al
m4:  mov al,0
m3:  shl bl,1
     loop m2
     cmp al,max
     jle con
     mov max,al
con: dec si
     cmp si,-1
     loopnz m1

     mov dl,0AH
     mov ah,02H
     int 21H
     mov al,max
     cbw
     call printNum

     mov ah,04CH
     int 21H
     ret

; printNum proc
;      mov ah,02H
;      mov dl,0AH
;      int 21H
;      mov ax,outp
;      aam 
;      add ax,3030H
;      mov dl,ah 
;      mov dh,al 
;      mov ah,02H
;      int 21H
;      mov dl,dh 
;      int 21H
;      ret
; printNum endp

printNum proc
     push    ax
     push    bx
     push    cx
     push    dx
     mov     bx,10 
     mov     cx,0  
fr:  xor     dx,dx 
     div     bx
     add     dl,'0'
     push    dx    
     inc     cx    
     test    ax,ax 
jnz  fr            
show:mov     ah,02H
     pop     dx    
     int     21H   
     loop    show  
     pop     dx
     pop     cx
     pop     bx
     pop     ax
     ret
printNum endp

end main