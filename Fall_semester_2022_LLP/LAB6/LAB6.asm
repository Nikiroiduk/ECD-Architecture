; Variant #2
; Создать оконное приложение с элементами управления «Кнопки»,
; «Поля редактирования», «Статический текст»
;   Калькулятор, выполняющий операции сложения, вычитания и
; умножения.

.686p
.model flat, stdcall
option casemap : none

GetCommandLineA    proto 
CreateSolidBrush   proto :dword
PostQuitMessage    proto :dword
DispatchMessageA   proto :dword
TranslateMessage   proto :dword
ShowWindow         proto :dword, :dword
DefWindowProcA     proto :dword, :dword, :dword, :dword
GetMessageA        proto :dword, :dword, :dword, :dword
WinMain            proto :dword, :dword, :dword, :dword
CreateWindowExA    proto :dword, :dword, :dword, :dword, \
                         :dword, :dword, :dword, :dword, \
                         :dword, :dword, :dword, :dword
LoadIconA          proto :dword, :dword
LoadCursorA        proto :dword, :dword
UpdateWindow       proto :dword
RegisterClassExA   proto :dword
GetModuleHandleA   proto :dword
ExitProcess        proto :dword


POINT struct
    x dd ?
    y dd ?
POINT ends

MSG struct
    hwnd    dd ?
    message dd ?
    wParam  dd ?
    lParam  dd ?
    time    dd ?
    pt      POINT<>
MSG ends

WNDCLASSEXA struct
    cbSize        dd ?
    style         dd ?
    lpfnWndProc   dd ?
    cbClsExtra    dd ?
    cbWndExtra    dd ?
    hInstance     dd ?
    hIcon         dd ?
    hCursor       dd ?
    hdrBackground dd ?
    lpszMenuName  dd ?
    lpszClassName dd ?
    hIconSm       dd ? 
WNDCLASSEXA ends

.data
    ClassName   db 'WinClass', 0
    AppName     db 'LAB6', 0
    hInstance   dd 0H
    CommandLine dd 0H
.data?
.const
    WM_DESTROY          equ 2H
    WM_KEYDOWN          equ 100H
    WM_LBUTTONDBCLK     equ 203H
    VK_ESCAPE           equ 1BH
    IDI_APPLICATION     equ 7F00H
    IDC_ARROW           equ 7F00H
    SW_SHOWNORMAL       equ 1H
    CS_HREDRAW          equ 2H
    CS_VREDRAW          equ 1H
    CS_DBLCLKS          equ 8H
    CW_USEDEFAULT       equ 80000000H
    WS_OVERLAPPED       equ 0H
    WS_CAPTION          equ 0C00000H
    WS_SYSMENU          equ 80000H
    WS_THICKFRAME       equ 40000H
    WS_MINIMIZEBOX      equ 20000H
    WS_MAXIMIZEBOX      equ 10000H
    WS_OVERLAPPEDWINDOW equ WS_OVERLAPPED  or \
                            WS_CAPTION     or \
                            WS_SYSMENU     or \
                            WS_THICKFRAME  or \
                            WS_MINIMIZEBOX or \
                            WS_MAXIMIZEBOX
    SW_SHOWDEFAULT      equ 0AH

.code
lab5:

    invoke GetModuleHandleA, 0
    mov hInstance, eax
    invoke GetCommandLineA
    mov CommandLine, eax
    invoke WinMain, hInstance, 0, CommandLine, SW_SHOWDEFAULT
    invoke ExitProcess, eax

    WinMain proc hInst:dword, hPrevInst:dword, CmdLine:dword, CmdShow:dword
        local wc:WNDCLASSEXA
        local msg:MSG
        local hwnd:dword

        mov wc.cbSize, sizeof WNDCLASSEXA
        mov wc.style, CS_HREDRAW or \
                      CS_VREDRAW
        mov wc.lpfnWndProc, offset WndProc
        mov wc.cbClsExtra, 0
        mov wc.cbWndExtra, 0
        push hInst
        pop wc.hInstance
        invoke CreateSolidBrush, 00FFFFFFH
        mov wc.hdrBackground, eax
        mov wc.lpszMenuName, 0
        mov wc.lpszClassName, offset ClassName
        invoke LoadIconA, 0, IDI_APPLICATION
        mov wc.hIcon, eax
        mov wc.hIconSm, eax
        invoke LoadCursorA, 0, IDC_ARROW
        mov wc.hCursor, eax
        invoke RegisterClassExA, addr wc

        invoke CreateWindowExA, 0, addr ClassName, addr AppName, \
               WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, \
               CW_USEDEFAULT, CW_USEDEFAULT, 0, 0, hInst, 0
        mov hwnd, eax

        invoke ShowWindow, hwnd, SW_SHOWNORMAL
        invoke UpdateWindow, hwnd        
        
        .while 1
            invoke GetMessageA, addr msg, 0, 0, 0
            .break .if (!eax)
            invoke TranslateMessage, addr msg
            invoke DispatchMessageA, addr msg
        .endw

        mov eax, msg.wParam
        ret
    WinMain endp

    WndProc proc hWnd:dword, wMsg:dword, wParam:dword, lParam:dword
        .if wMsg==WM_DESTROY
            invoke PostQuitMessage, 0
        .elseif wMsg==WM_KEYDOWN
            .if wParam==VK_ESCAPE
                invoke PostQuitMessage, 0
            .endif
        .else
            invoke DefWindowProcA, hWnd, wMsg, wParam, lParam
            ret
        .endif
        xor eax,eax
        ret
    WndProc endp

end lab5