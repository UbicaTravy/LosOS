bits 16
global kg_editor

kg_editor:
    ; очистка экрана
    mov ax, 0x0003
    int 0x10

    ; вывод заголовка
    mov si, kg_header
    call print

.input_loop:
    ; чтение клавиши с клавиатуры
    mov ah, 0x00
    int 0x16

    ; выход по Ctrl+X (традиционно для текстовых редакторов)
    cmp al, [exit_key_ctrl_x]
    je .exit_editor
    
    ; обработка backspace - удаляем символ
    cmp al, 0x08
    je .backspace

    ; обработка enter - перевод строки
    cmp al, 0x0D
    je .newline

    ; обычный символ - выводим на экран
    mov ah, 0x0E
    int 0x10
    jmp .input_loop

.backspace:
    ; удаляем символ: backspace, пробел, backspace
    mov ah, 0x0E
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    jmp .input_loop

.newline:
    ; перевод строки: CR + LF
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    jmp .input_loop

.exit_editor:
    ; очистка экрана перед выходом
    mov ax, 0x0003
    int 0x10
    
    mov si, kg_exit_msg
    call print
    ret

kg_header db "KG Editor (Ctrl+X to exit)", 0x0D, 0x0A, 0x0A, 0
kg_exit_msg db "KG Editor closed.", 0x0D, 0x0A, 0