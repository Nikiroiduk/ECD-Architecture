; Variant #5
; a) x = 3 * (125 - 100) / 5 + 5 + 856
; b) y = (1214 - 1014) * ((351 + 49) / (1214 - 814)) * (40 / (10 + 10))

.686p
.model flat, stdcall
option casemap : none

ExitProcess proto stdcall :dword
MessageBoxA proto stdcall :dword, :dword, :dword, :dword
wsprintfA proto c :vararg



.data
    TitleMsg db 'Result', 0
    buffer db 128 dup(0)
    format db 'x = 3 * (125 - 100) / 5 + 5 + 856 = %d', 0AH, 0DH,
              'y = (1214 - 1014) * ((351 + 49) / (1214 - 814)) * (40 / (10 + 10)) = %d', 0
.data?
    x dword ?
    y dword ?
.const

.code
lab2:
    call taskA
    call taskB
    invoke wsprintfA, addr buffer, addr format, x, y
    invoke MessageBoxA, 0, addr buffer, addr TitleMsg, 0
    invoke ExitProcess, 0

    taskA proc
        ; x = 3 * (125 - 100) / 5 + 5 + 856
        mov eax, 125
        sub eax, 100
        mov ebx, 3
        mul ebx
        mov bx, 5
        idiv bx
        add eax, 5
        add eax, 856
        mov x, eax
        ret
    taskA endp

    taskB proc
        ; y = (1214 - 1014) * ((351 + 49) / (1214 - 814)) * (40 / (10 + 10))
        mov eax, 1214
        sub eax, 1014
        mov ebx, 351
        add ebx, 49
        mul ebx
        mov ebx, 1214
        sub ebx, 814
        cdq
        idiv ebx
        mov ebx, 40
        mul ebx
        mov ebx, 10
        add ebx, 10
        cdq
        idiv ebx
        mov y, eax
        ret
    taskB endp
end lab2