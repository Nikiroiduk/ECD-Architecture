; Variant #5
; Параметры в первую процедуру передаются через стек, результат
; возвращается через регистр EAX. Соглашение о вызовах – stdcall.
; Параметры во вторую процедуру передаются через стек, включая адрес
; ячейки памяти для результата, результат возвращается по адресу. Соглашение
; о вызовах – cdecl.
;
; Proc 1
; Z = (A - B) / 5
; X
; Y = 0, if Z < 0 and X < 0
; Y = 1, if Z = 0 and X = 0
; Y = 2, if Z > 0 and X > 0
; else Y = 3
;
; Proc 2
; Y1 = (100 + A1) / A2
; Y2 = 101, if Y1 = 0
; Y2 = 111, if Y1 <> 0

.686p
.model flat, stdcall
option casemap : none

MessageBoxA proto stdcall :dword, :dword, :dword, :dword
wsprintfA proto c :vararg
ExitProcess proto stdcall :dword

.data
    TitleMsg db 'Result', 0
    buffer db 128 dup(0)
    format db 'Proc 1: Y = %d', 0AH, 0DH,
              'Proc 2: Y2 = %d', 0

    A dd 5
    B dd 0
    X dd 1

    A1 dd 10
    A2 dd 200
.data?
    Y dd ?
    Y2 dd ?
.const

.code
lab3:
    push X
    push B
    push A
    call task1
    mov Y, eax

    push A1
    push A2
    push offset Y2
    call task2
    add esp, 12

    invoke wsprintfA, addr buffer, addr format, Y, Y2
    invoke MessageBoxA, 0, addr buffer, addr TitleMsg, 0
    invoke ExitProcess, 0

    task1 proc
        mov eax, [esp +  4]  ; A
        mov ebx, [esp +  8]  ; B
        mov ecx, [esp + 12]  ; X

        sub eax, ebx
        mov ebx, 5
        cdq
        idiv ebx

        push eax

        call getSF
        mov edx, eax

        mov eax, ecx
        call getSF
        mov esi, eax

        pop eax

        .if edx == 80H && esi == 80H
            mov eax, 0
        .elseif eax == 0 && ecx == 0
            mov eax, 1
        .elseif edx != 80H && esi != 80H
            mov eax, 2
        .else
            mov eax, 3
        .endif

        ret 12
    task1 endp

    task2 proc
        mov ecx, [esp + 4]  ; Y2
        mov ebx, [esp + 8]  ; A2
        mov eax, [esp + 12] ; A1

        add eax, 100
        cdq
        idiv ebx

        .if eax == 0
            mov eax, 101
            mov [ecx], eax
        .elseif eax != 0
            mov eax, 111
            mov [ecx], eax
        .endif

        ret
    task2 endp

    getSF proc
    test eax, eax
    pushfd
    pop eax
    and eax, 80H
    ret
    getSF endp

end lab3