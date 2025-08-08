bits 16
extern guess_game

check_guess:
    mov di, .command
    call strcmp
    jne .skip
    
    ; запускаем игру
    call guess_game
    mov byte [cmd_handled], 1
    
.skip:
    ret

.command db "guess", 0 