; Variant #5
; Ввести строку. Найти слово, стоящее в тексте под третьим номером,
; вывести его первую букву и количество букв в нем.

.686p
.model flat, stdcall
option casemap : none

GetStdHandle  proto :dword
WriteConsoleA proto :dword, :dword, :dword, :dword, :dword
ReadConsoleA  proto :dword, :dword, :dword, :dword, :dword
ExitProcess   proto :dword

.data
    message db "Hello World!", 0DH, 0AH
    ;lmessage equ $ - message
    lmessage equ 100
.data?
    consoleOutHandle dd ?
    consoleInHandle  dd ?
    bytesWritten     dd ?
    byteArray        db ?
.const
    STD_OUTPUT_HANDLE equ -11
    STD_INPUT_HANDLE  equ -10

.code
lab4:

    call readFromConsole
    
    ; TODO: should found third word in byteArray
    ; TODO: print first symbol of this word
    ; TODO: print length of this word

    call writeOnConsole

    invoke ExitProcess, 0 

    readFromConsole proc
        pushad
        invoke GetStdHandle, STD_INPUT_HANDLE
        mov consoleInHandle, eax

        invoke ReadConsoleA, \
               consoleInHandle, \
               offset byteArray, \
               lmessage, \
               offset bytesWritten, \
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
               offset byteArray, \
               lmessage, \
               offset bytesWritten, \
               0
        popad
        ret
    writeOnConsole endp
end lab4