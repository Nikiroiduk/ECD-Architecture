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
                     'Quantity "a" (ascii - 61H): %d', 0
    buffer       db  lmessage dup(?)
.data?
    consoleOutHandle dd ?
    consoleInHandle  dd ?
    bytesWritten     dd ?
    inputData        db lmessage dup(?)
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
    mov spaces, al
    inc spaces

    xor eax, eax
    mov al, 'a'
    push eax
    call countMatches
    mov as,     al

    invoke wsprintfA, addr buffer, addr resultString, spaces, as

    call writeOnConsole

    invoke ExitProcess, 0 

    countMatches proc
        mov eax, [esp + 4]

        xor edx, edx
        dec bytesWritten
        mov ecx, bytesWritten
    meh:
        cmp [inputData + ecx], al
        jz match
        jnz continue
    match:
        inc dl
    continue:
        loop meh
        mov al, dl
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