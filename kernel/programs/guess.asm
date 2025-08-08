bits 16
global guess_game

guess_game:
    ; очистка экрана, потому что нужно начать с чистого листа
    mov ax, 0x0003
    int 0x10
    
    ; выводим заголовок, чтобы пользователь понял, что это за игра
    mov si, game_header
    call print
    
    ; генерируем случайное число от 1 до 10, потому что так заданы правила игры
    mov al, 10
    call random_range_1
    mov [secret_number], al
    
    ; основной игровой цикл, где происходит вся магия
.game_loop:
    ; просим пользователя ввести число
    mov si, guess_prompt
    call print
    
    ; читаем ввод пользователя в буфер
    mov di, input_buffer
    call read_string
    
    ; проверяем специальные клавиши выхода
    ; используем внешние переменные через EXTERN, потому что они объявлены в другом месте
    mov si, input_buffer
    lodsb
    cmp al, [exit_key]    ; используем 'q' для выхода
    je .exit
    cmp al, [exit_key_ctrl_x]  ; используем Ctrl+X для выхода
    je .exit
    
    ; преобразуем строку в число, потому что ввод всегда идет как строка
    mov si, input_buffer
    call parse_number
    mov [user_guess], al
    
    ; сравниваем с загаданным числом
    mov al, [user_guess]
    cmp al, [secret_number]
    je .correct
    jg .too_high
    jl .too_low
    
.correct:
    ; показываем сообщение о победе
    mov si, correct_msg
    call print
    
    ; ждем любую клавишу, чтобы пользователь успел увидеть результат
    mov si, press_any_key_msg
    call print
    call wait_for_key
    jmp .exit
    
.too_high:
    ; говорим что число слишком большое
    mov si, too_high_msg
    call print
    jmp .game_loop
    
.too_low:
    ; говорим что число слишком маленькое
    mov si, too_low_msg
    call print
    jmp .game_loop
    
.exit:
    ; очищаем экран перед выходом, чтобы не было мусора
    mov ax, 0x0003
    int 0x10
    
    ; сообщаем о завершении игры
    mov si, guess_exit_msg
    call print
    ret

; функция ожидания нажатия клавиши
; это самый простой способ
wait_for_key:
    mov ah, 0x00
    int 0x16
    ret

; преобразуем строку в число
; ввод идет посимвольно
parse_number:
    xor ax, ax
    mov byte [temp_number], 0  ; обнуляем перед началом
.loop:
    lodsb
    cmp al, 0        ; проверяем конец строки
    je .done
    cmp al, '0'      ; проверяем что символ - цифра
    jb .invalid
    cmp al, '9'
    ja .invalid
    
    ; преобразуем символ в число и добавляем к результату
    sub al, '0'
    mov bl, al
    mov al, [temp_number]
    mov cl, 10       ; это десятичная система
    mul cl
    add al, bl
    mov [temp_number], al
    jmp .loop
    
.invalid:
    ; если символ не цифра - считаем что ввод закончен
.done:
    mov al, [temp_number]
    ret

; данные игры
game_header db "=== Los OS Number Guessing Game ===", 0x0D, 0x0A, 0x0D, 0x0A, 0
guess_prompt db "Guess a number (1-10): ", 0
correct_msg db "Correct! You guessed it!", 0x0D, 0x0A, 0
too_high_msg db "Too high! Try again.", 0x0D, 0x0A, 0
too_low_msg db "Too low! Try again.", 0x0D, 0x0A, 0
guess_exit_msg db "Number guessing game closed.", 0x0D, 0x0A, 0
press_any_key_msg db "Press any key to continue...", 0x0D, 0x0A, 0

; игровые переменные
secret_number db 0
user_guess db 0
temp_number db 0
input_buffer times 16 db 0