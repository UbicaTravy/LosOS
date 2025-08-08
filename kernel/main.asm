bits 16
org 0x8000

; это - ядро ОС

; точка входа ядра - тут начинается вся эта нагромождённая шизофрения
start:
    ; инициализация сегментов чтобы всё работало как надо
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00  ; используем стек ниже загрузчика

    ; очистка экрана чтобы было красиво
    mov ax, 0x0003
    int 0x10

    ; вывод приветствия
    mov si, os_name
    call print

    ; переход к основному циклу
    jmp main_loop

; подключаем библиотеки
%include "../lib/io.asm"
%include "../lib/string.asm"
%include "../lib/random.asm"

; подключаем программы
%include "programs/kg.asm"
%include "programs/calc.asm"
%include "programs/paint.asm"
%include "programs/guess.asm"

; подключаем команды (здесь есть секретки)
%include "commands/help.asm"
%include "commands/exit.asm"
%include "commands/reboot.asm"
%include "commands/clear.asm"
%include "commands/info.asm"
%include "commands/mem.asm"
%include "commands/time.asm"
%include "commands/kg.asm"
%include "commands/test.asm"
%include "commands/mge.asm"
%include "commands/furry.asm"
%include "commands/pornogayfurry.asm"
%include "commands/date.asm"
%include "commands/ver.asm"
%include "commands/cpu.asm"
%include "commands/disk.asm"
%include "commands/bios.asm"
%include "commands/calc.asm"
%include "commands/paint.asm"
%include "commands/guess.asm"
%include "commands/bolgen.asm"

main_loop:
    ; проверка целостности стека чтобы не упало всё
    cmp sp, 0x7C00
    jae .stack_ok
    mov si, stack_error_msg
    call print
    mov sp, 0x7C00
.stack_ok:

    ; вывод промпта
    mov si, prompt
    call print

    ; чтение команды
    mov di, cmd_buffer
    call read_string

    ; обработка команд
    call handle_command
    
    ; показываем фурри арт если режим включен
    call show_furry_art
    
    jmp main_loop

handle_command:
    ; сброс флага обработки
    mov byte [cmd_handled], 0
    
    ; проверяем, не пустая ли команда
    mov si, cmd_buffer
    lodsb
    test al, al
    jz .done  ; если команда пустая, просто возвращаемся
    
    ; устанавливаем si обратно на cmd_buffer для сравнения строк
    mov si, cmd_buffer
    
    ; проверяем все команды
    call check_exit
    call check_reboot
    call check_help
    call check_clear
    call check_info
    call check_mem
    call check_time
    call check_kg
    call check_mge
    call check_furry
    call check_pornogayfurry
    call check_date
    call check_ver
    call check_cpu
    call check_disk
    call check_calc
    call check_bios
    call check_paint
    call check_guess
    call check_bolgen
    call check_test
    
    ; если команда не распознана
    cmp byte [cmd_handled], 1
    je .done
    
    mov si, unknown_cmd
    call print
    
.done:
    ret

; функция для выполнения команды из другой команды
; вход: si - указатель на строку команды
execute_command:
    ; сохраняем текущий буфер команд
    push si
    push di
    mov si, cmd_buffer
    mov di, cmd_buffer_backup
    call copy_string_backup
    
    ; копируем новую команду в буфер
    pop di
    pop si
    mov di, cmd_buffer
    call copy_string_to_buffer
    
    ; выполняем команду
    call handle_command
    
    ; восстанавливаем оригинальный буфер
    mov si, cmd_buffer_backup
    mov di, cmd_buffer
    call copy_string_to_buffer
    
    ret

; копирование строки в буфер команд
copy_string_to_buffer:
    lodsb
    stosb
    test al, al
    jnz copy_string_to_buffer
    ret

; копирование строки для бэкапа
copy_string_backup:
    lodsb
    stosb
    test al, al
    jnz copy_string_backup
    ret

; функция для получения аргументов команды
; вход: si - указатель на команду в cmd_buffer
; выход: si - указатель на первый аргумент (или 0 если нет аргументов)
;        di - указатель на второй аргумент (или 0 если нет второго аргумента)
get_command_args:
    ; ищем первый пробел после команды
    mov di, si
.find_space:
    lodsb
    test al, al
    jz .no_args      ; конец строки - нет аргументов
    cmp al, ' '
    je .found_space
    jmp .find_space
    
.found_space:
    ; si теперь указывает на первый аргумент
    mov di, si       ; сохраняем указатель на первый аргумент
    
    ; ищем второй пробел
.find_second_space:
    lodsb
    test al, al
    jz .one_arg      ; конец строки - только один аргумент
    cmp al, ' '
    je .found_second_space
    jmp .find_second_space
    
.found_second_space:
    ; заменяем пробел на 0 для разделения аргументов
    mov byte [si-1], 0
    ; si теперь указывает на второй аргумент
    ret
    
.one_arg:
    ; только один аргумент, второй = 0
    xor si, si
    ret
    
.no_args:
    ; нет аргументов
    xor si, si
    xor di, di
    ret

; функция для проверки наличия аргумента
; вход: si - указатель на аргумент
; выход: ZF = 1 если аргумент пустой, ZF = 0 если есть аргумент
check_arg:
    test si, si
    jz .no_arg
    mov al, [si]
    test al, al
.no_arg:
    ret

; функция для сравнения аргумента со строкой
; вход: si - указатель на аргумент, di - указатель на строку для сравнения
; выход: ZF = 1 если равны, ZF = 0 если не равны
compare_arg:
    test si, si
    jz .no_match
    call strcmp
    ret
.no_match:
    mov ax, 1  ; не равны
    ret

; данные
; в os_name пишите чё хотите, если хотите такой же ASCII арт ищите в инете "из текста в ASCII арт"
os_name:
	db "/========================================================================\", 0x0D, 0x0A
    db "|                                                                        |", 0x0D, 0x0A
    db "|         __         ______     ______        ______     ______          |", 0x0D, 0x0A
    db "|        /\ \       /\  __ \   /\  ___\      /\  __ \   /\  ___\         |", 0x0D, 0x0A
    db "|        \ \ \____  \ \ \/\ \  \ \___  \     \ \ \/\ \  \ \___  \        |", 0x0D, 0x0A
    db "|         \ \_____\  \ \_____\  \/\_____\     \ \_____\  \/\_____\       |", 0x0D, 0x0A
    db "|          \/_____/   \/_____/   \/_____/      \/_____/   \/_____/       |", 0x0D, 0x0A
    db "|                                                                        |", 0x0D, 0x0A
    db "|                                                                        |", 0x0D, 0x0A
    db "|========================================================================|", 0x0D, 0x0A
    db "|                             Based on Pid OS                            |", 0x0D, 0x0A
    db "|                  GitHub: https://github.com/Insert42/PidOS             |", 0x0D, 0x0A
    db "|                                                                        |", 0x0D, 0x0A
	db "|    Powered by Fecal OS https://github.com/UbicaTravy/KillerGrassOS     |", 0x0D, 0x0A
    db "|========================================================================|", 0x0D, 0x0A
    db "|                 Created by KillerGrass, losos, Findix                  |", 0x0D, 0x0A
    db "|                           License GNU GPL v3                           |", 0x0D, 0x0A
    db "|                                                                        |", 0x0D, 0x0A
    db "| Full list of commands - help                                           |", 0x0D, 0x0A
    db "\========================================================================/", 0x0D, 0x0A, 0
prompt db "> ", 0
cmd_buffer times 64 db 0
cmd_buffer_backup times 64 db 0
arg1_buffer times 32 db 0
arg2_buffer times 32 db 0
unknown_cmd db "Unknown command", 0x0D, 0x0A, 0
cmd_handled db 0
stack_error_msg db "Stack corruption detected! Reset to 0x7C00", 0x0D, 0x0A, 0

; глобальные переменные для программ
; замените на то что душе угодно
; если нужно поставить на определённый символ в определённой программе - змените в программе к примеру [cursor_symbol] на нужный вам символ
cursor_symbol db '@'  ; символ курсора
use_key db ' '  ; клавиша использования (пробел)
exit_key db 'q'  ; клавиша выхода
exit_key_ctrl_x db 0x18  ; клавиша выхода Ctrl+X