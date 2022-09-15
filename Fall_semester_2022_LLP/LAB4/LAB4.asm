; Variant #2
; Ввести строку, состоящую из слов, разделенных одним пробелом.
; Определить количество слов и количество буквы «а» в строке.

.686p
.model flat, stdcall
option casemap : none

GetStdHandle  proto   :dword
WriteConsoleA proto   :dword, :dword, :dword, :dword, :dword
ReadConsoleA  proto   :dword, :dword, :dword, :dword, :dword
ExitProcess   proto   :dword
wsprintfA     proto c :vararg

.data
    lmessage     equ 100
    resultString db  'Number of words: %d', 0AH, 0DH,
                     'Quantity "a-A": %d', 0
.data?
    consoleOutHandle dd ?
    consoleInHandle  dd ?
    bytesWritten     dd ?
    inputData        db lmessage dup(?)
    buffer           db lmessage dup(?)
    spaces           db ?
    as               db ?

.const
    STD_OUTPUT_HANDLE equ -11
    STD_INPUT_HANDLE  equ -10

.code
lab4:

    call readFromConsole

    xor eax, eax
    mov al, ' '
    push eax
    call countMatches
    mov spaces, dl
    .if bytesWritten > 2
        inc spaces
    .endif

    xor eax, eax
    mov al, 'a'
    push eax
    call countMatches
    mov as, dl

    xor eax, eax
    mov al, 'A'
    push eax
    call countMatches
    add as, dl

    invoke wsprintfA, addr buffer, addr resultString, spaces, as

    call writeOnConsole

    invoke ExitProcess, 0 

    countMatches proc
        .if bytesWritten <= 2
            mov dsl, 0
            ret
        .endif

        mov eax, [esp + 4]
        xor edx, edx
        mov ecx, bytesWritten
        mov ebx, 0

        meh:
            .if [inputData + ebx] == al
                inc dl
            .endif
        inc ebx
        loop meh

        ret
    countMatches endp

    readFromConsole proc
        pushad
        invoke GetStdHandle, STD_INPUT_HANDLE
        mov consoleInHandle, eax

        invoke ReadConsoleA, \
            consoleInHandle, \
            addr inputData, \
            lmessage, \
            addr bytesWritten, \
            0
        popad
        ret
    readFromConsole endp

    writeOnConsole proc
        pushad
        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov consoleOutHandle, eax

        invoke WriteConsoleA, \
            consoleOutHandle, \
            addr buffer, \
            lmessage, \
            addr bytesWritten, \
            0
        popad
        ret
    writeOnConsole endp
end lab4