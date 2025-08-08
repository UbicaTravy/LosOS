check_exit:
    mov di, .command
    call strcmp
    jne .skip
    mov si, .exit_msg
    call print
    mov byte [cmd_handled], 1
    
    ; попытка выключения через APM
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15
    
    ; если не сработало - зависаем
    cli
    hlt
.skip:
    ret

.command db "exit", 0
.exit_msg db "Shutting down...", 0x0D, 0x0A, 0