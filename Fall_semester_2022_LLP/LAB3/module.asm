.686p
.model flat, stdcall
option casemap : none

MessageBoxA proto :dword, :dword, :dword, :dword
wsprintfA proto c :vararg
ExitProcess proto :dword

.data
    TitleMsg db 'Result', 0
    buffer db 128 dup(0)
    format db 'Y = %d', 0AH, 0DH,
              'Proc: Z = %d'

    C dd -12
    D dd 48
    Q dd 3
    P1 dd 30
    P2 dd 10
.data?
    Z dd ?
    Y dd ?
.const

.code
module:
    mov eax, D
    cdq
    mov ebx, 4
    idiv ebx
    dec eax
    add eax, 4
    mov Y, eax

    push Y
    push Q
    push P1
    push P2
    push offset Z
    call task
    add esp, 12

    invoke wsprintfA, addr buffer, addr format, Y, Z
    invoke MessageBoxA, 0, addr buffer, addr TitleMsg, 0
    invoke ExitProcess, 0

    task proc
        mov ebx, [esp + 16]  ; Q
        mov eax, [esp + 20] ; Y

        .if ebx > 0
            .if eax > 0
                mov ebx, [esp + 12] ; P1
                mov ecx, [esp + 8] ; P2
                sub ebx, ecx
                mov [esp + 4], ebx
        
        ; и т.д.

        ret
    task endp

end module