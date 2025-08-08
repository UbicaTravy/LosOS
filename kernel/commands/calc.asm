bits 16

extern calc_program

check_calc:
    mov di, .command
    call strcmp
    jne .skip
    
    ; запускаем программу калькулятора
    mov byte [cmd_handled], 1
    call calc_program
    
.skip:
    ret

.command db "calc", 0 