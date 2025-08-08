bits 16
global calc_program

calc_program:
    ; очистка экрана
    mov ax, 0x0003
    int 0x10
    
    ; вывод заголовка
    mov si, calc_header
    call print
    
.calc_loop:
    ; вывод промпта калькулятора
    mov si, calc_prompt
    call print
    
    ; чтение выражения
    mov di, expression_buffer
    call read_string
    
    ; проверяем выход
    mov si, expression_buffer
    lodsb
    cmp al, [exit_key]
    je .exit_calc
    cmp al, [exit_key_ctrl_x]
    je .exit_calc
    
    ; парсим и вычисляем выражение
    mov si, expression_buffer
    call parse_and_calculate
    
    ; выводим результат
    mov si, calc_result_msg
    call print
    call print_number
    mov si, crlf
    call print
    
    jmp .calc_loop
    
.exit_calc:
    ; очистка экрана перед выходом
    mov ax, 0x0003
    int 0x10
    
    mov si, calc_exit_msg
    call print
    ret

; функция парсинга и вычисления выражения
; вход: si - указатель на строку выражения
parse_and_calculate:
    ; пропускаем пробелы в начале
    call skip_spaces
    
    ; читаем первое число
    call read_number
    mov [num1], ax
    
    ; пропускаем пробелы между числами и операцией
    call skip_spaces
    
    ; читаем операцию (+, -, *, /)
    lodsb
    mov [operation], al
    
    ; пропускаем пробелы между операцией и вторым числом
    call skip_spaces
    
    ; читаем второе число
    call read_number
    mov [num2], ax
    
    ; выполняем операцию и сохраняем результат
    call perform_calculation
    ret

; пропуск пробелов в строке
skip_spaces:
.loop:
    lodsb
    cmp al, ' '
    je .loop
    dec si  ; возвращаемся к символу (не пробелу)
    ret

; чтение числа из строки
read_number:
    xor ax, ax
    xor bx, bx
.loop:
    lodsb
    cmp al, '0'
    jb .done
    cmp al, '9'
    ja .done
    
    ; конвертируем символ в число и добавляем к результату
    sub al, '0'
    mov bl, al
    mov al, [current_num]
    mov cl, 10
    mul cl
    add al, bl
    mov [current_num], al
    jmp .loop
.done:
    dec si  ; возвращаемся к символу (не цифре)
    mov al, [current_num]
    mov ah, 0
    mov word [current_num], 0  ; сброс для следующего числа
    ret

; выполнение арифметической операции
perform_calculation:
    mov al, [operation]
    cmp al, '+'
    je .add
    cmp al, '-'
    je .sub
    cmp al, '*'
    je .mul
    cmp al, '/'
    je .div
    jmp .error

.add:
    mov ax, [num1]
    add ax, [num2]
    jmp .done
.sub:
    mov ax, [num1]
    sub ax, [num2]
    jmp .done
.mul:
    mov ax, [num1]
    mul word [num2]
    jmp .done
.div:
    mov ax, [num1]
    mov dx, 0
    div word [num2]
    jmp .done

.error:
    mov ax, 0
.done:
    mov [result], ax
    ret

; вывод числа на экран
print_number:
    mov ax, [result]
    cmp ax, 0
    jge .positive
    ; если число отрицательное, выводим минус
    mov al, '-'
    mov ah, 0x0E
    int 0x10
    neg ax
.positive:
    mov bx, 10
    xor cx, cx
.loop:
    ; делим число на 10 и сохраняем остатки
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz .loop
.print:
    ; выводим цифры в правильном порядке
    pop ax
    add al, '0'
    mov ah, 0x0E
    int 0x10
    loop .print
    ret

calc_header db "=== Los OS Calculator ===", 0x0D, 0x0A
            db "Enter expressions like: 5 + 3", 0x0D, 0x0A
            db "Supported: +, -, *, /", 0x0D, 0x0A
            db "Type 'q' or Ctrl+X to exit. Max result - 255.", 0x0D, 0x0A, 0x0A, 0
calc_prompt db "calc> ", 0
calc_result_msg db "Result: ", 0
calc_exit_msg db "Calculator closed.", 0x0D, 0x0A, 0
crlf db 0x0D, 0x0A, 0
expression_buffer times 64 db 0
num1 dw 0
num2 dw 0
operation db 0
result dw 0
current_num dw 0