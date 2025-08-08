bits 16
global paint_program
%pragma warning -w+number-overflow
%pragma warning -w+overflow

paint_program:
    ; очистка экрана
    mov ax, 0x0003
    int 0x10
    
    ; вывод заголовка
    mov si, paint_header
    call print
    
    ; запрос размера холста у пользователя
    mov si, size_prompt
    call print
    
    ; читаем размер с клавиатуры
    mov di, size_buffer
    call read_string
    
    ; парсим размер (простой - берем первое число)
    mov si, size_buffer
    call parse_size
    mov [canvas_width], al
    mov [canvas_height], al
    
    ; инициализация позиции курсора в центре
    mov word [cursor_x], 0
    mov word [cursor_y], 0
    
    ; очистка холста (заполняем нулями)
    call clear_canvas
    
    ; основной цикл рисования
.paint_loop:
    ; отрисовка холста на экране
    call draw_canvas
    
    ; обработка ввода пользователя
    mov ah, 0x00
    int 0x16
    
    ; проверяем клавиши управления
    cmp ah, 0x48  ; стрелка вверх
    je .move_up
    cmp ah, 0x50  ; стрелка вниз
    je .move_down
    cmp ah, 0x4B  ; стрелка влево
    je .move_left
    cmp ah, 0x4D  ; стрелка вправо
    je .move_right
    cmp al, [use_key]   ; пробел - рисовать пиксель
    je .draw
    cmp al, 'c'   ; c - очистить весь холст
    je .clear
    cmp al, [exit_key]   ; q - выход из программы
    je .exit
    cmp al, [exit_key_ctrl_x]  ; Ctrl+X - альтернативный выход
    je .exit
    jmp .paint_loop
    
.move_up:
    cmp word [cursor_y], 0
    je .paint_loop
    dec word [cursor_y]
    jmp .paint_loop
    
.move_down:
    mov ax, [canvas_height]
    dec ax
    cmp word [cursor_y], ax
    jae .paint_loop
    ; Проверяем, не выходит ли за границы экрана
    mov ax, [cursor_y]
    inc ax
    cmp ax, 15  ; Максимум 15 строк на экране
    jae .paint_loop
    inc word [cursor_y]
    jmp .paint_loop
    
.move_left:
    cmp word [cursor_x], 0
    je .paint_loop
    dec word [cursor_x]
    jmp .paint_loop
    
.move_right:
    mov ax, [canvas_width]
    dec ax
    cmp word [cursor_x], ax
    jae .paint_loop
    ; Проверяем, не выходит ли за границы экрана
    mov ax, [cursor_x]
    inc ax
    cmp ax, 15  ; Максимум 15 столбцов на экране
    jae .paint_loop
    inc word [cursor_x]
    jmp .paint_loop
    
.draw:
    call draw_pixel
    jmp .paint_loop
    
.clear:
    call clear_canvas
    jmp .paint_loop
    
.exit:
    ; очистка экрана перед выходом
    mov ax, 0x0003
    int 0x10
    
    mov si, paint_exit_msg
    call print
    ret

; парсинг размера
parse_size:
    xor ax, ax
.loop:
    lodsb
    cmp al, '0'
    jb .done
    cmp al, '9'
    ja .done
    
    sub al, '0'
    mov bl, al
    mov al, [temp_size]
    mov cl, 10
    mul cl
    add al, bl
    mov [temp_size], al
    jmp .loop
.done:
    mov ax, [temp_size]
    cmp ax, 0
    jne .ok
    mov ax, 10  ; по умолчанию 10x10
.ok:
    cmp ax, 15  ; максимум 15x15
    jbe .ok2
    mov ax, 15
.ok2:
    ; ограничиваем размер холста для экрана
    cmp ax, 15  ; максимум 15x15 для экрана
    jbe .ok3
    mov ax, 15
.ok3:
    mov word [temp_size], 0  ; сброс
    ret

; очистка холста
clear_canvas:
    mov di, canvas
    mov cx, 400  ; 20x20 = 400 байт
    mov al, 0
    rep stosb
    ret

; отрисовка холста
draw_canvas:
    ; перемещаем курсор в начало
    mov ah, 0x02
    mov bh, 0
    mov dh, 3
    mov dl, 0
    int 0x10
    
    ; отрисовываем холст
    mov si, canvas
    mov cx, [canvas_height]
    
    ; добавляем пустые строки перед холстом
    mov cx, 5
.clear_lines:
    mov al, 0x0D
    mov ah, 0x0E
    int 0x10
    mov al, 0x0A
    int 0x10
    loop .clear_lines
    
    ; перемещаем курсор в начало холста
    mov ah, 0x02
    mov bh, 0
    mov dh, 8  ; начинаем с 8-й строки
    mov dl, 0
    int 0x10
    
    ; отрисовываем холст
    mov si, canvas
    mov cx, [canvas_height]
.row_loop:
    push cx
    push si
    
    ; Начало строки
    mov al, '['
    mov ah, 0x0E
    int 0x10
    
    ; Отрисовка строки
    mov cx, [canvas_width]
.col_loop:
    lodsb
    test al, al
    jz .empty
    mov al, '#'
    jmp .print
.empty:
    mov al, '.'
.print:
    mov ah, 0x0E
    int 0x10
    loop .col_loop
    
    ; Конец строки
    mov al, ']'
    mov ah, 0x0E
    int 0x10
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    
    pop si
    add si, 20  ; Следующая строка
    pop cx
    loop .row_loop
    
    ; Показываем курсор
    call show_cursor
    ret

; Показать курсор
show_cursor:
    ; Вычисляем позицию курсора на экране
    mov ax, [cursor_y]
    add ax, 8  ; cмещение от заголовка (8-я строка)
    cmp ax, 255
    jbe .ok1
    mov ax, 255
.ok1:
    mov dh, al
    mov ax, [cursor_x]
    add ax, 1  ; Смещение от '['
    cmp ax, 255
    jbe .ok2
    mov ax, 255
.ok2:
    mov dl, al
    
    ; Перемещаем курсор
    mov ah, 0x02
    mov bh, 0
    int 0x10
    
    ; Показываем курсор
    mov al, [cursor_symbol]
    mov ah, 0x0E
    int 0x10
    ret

; Рисовать пиксель
draw_pixel:
    ; Вычисляем адрес в холсте
    mov ax, [cursor_y]
    mov bx, 20
    mul bx
    add ax, [cursor_x]
    mov di, canvas
    add di, ax
    
    ; Рисуем пиксель
    mov byte [di], 1
    ret

paint_header db "=== Otsos OS Paint ===", 0x0D, 0x0A
             db "Controls:", 0x0D, 0x0A
             db "Arrows - Move cursor", 0x0D, 0x0A
             db "Space - Draw pixel", 0x0D, 0x0A
             db "C - Clear canvas", 0x0D, 0x0A
             db "Q or Ctrl+X - Exit", 0x0D, 0x0A, 0x0A, 0
size_prompt db "Enter canvas size (5-15): ", 0
paint_exit_msg db "Paint closed.", 0x0D, 0x0A, 0
size_buffer times 8 db 0
canvas_width dw 10
canvas_height dw 10
cursor_x dw 0
cursor_y dw 0
temp_size dw 0
canvas times 400 db 0  ; 20x20 холст 