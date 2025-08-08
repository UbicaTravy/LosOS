bits 16
extern paint_program

check_paint:
    mov di, .command
    call strcmp
    jne .skip
    
    ; запускаем программу рисовалки
    call paint_program
    mov byte [cmd_handled], 1
.skip:
    ret

.command db "paint", 0 