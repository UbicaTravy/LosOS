check_pornogayfurry:
    mov di, .command
    call strcmp
    jne .skip
    
    mov si, .loading_msg
    call print
    
    ; бесконечный цикл загрузки
.loading_loop:
    ; очистка строки загрузки
    mov si, .clear_line
    call print
    
    ; показываем прогресс
    mov si, .loading_text
    call print
    
    ; анимация точек
    mov cx, 0
.dot_loop:
    mov al, '.'
    mov ah, 0x0E
    int 0x10
    
    ; небольшая задержка для анимации
    push cx
    mov cx, 0xFFFF
.delay:
    loop .delay
    pop cx
    
    inc cx
    cmp cx, 4
    jb .dot_loop
    
    ; проверяем, не нажата ли клавиша для выхода
    mov ah, 0x01
    int 0x16
    jz .loading_loop  ; если нет нажатия, продолжаем
    
    ; если нажата клавиша - читаем её
    mov ah, 0x00
    int 0x16
    
    ; проверяем ctrl+c для выхода
    cmp al, 0x03
    je .exit
    
    jmp .loading_loop
    
.exit:
    mov si, .exit_msg
    call print
    mov byte [cmd_handled], 1
.skip:
    ret

.command db "pornogayfurry", 0
.loading_msg db "Starting furry content download...", 0x0D, 0x0A, 0
.loading_text db "Loading furry content"
.clear_line db 0x0D, 0x1B, "[K", 0  ; очистка строки
.exit_msg db 0x0D, 0x0A, "Download cancelled by user.", 0x0D, 0x0A, 0 