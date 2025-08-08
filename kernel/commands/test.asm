check_test:
    mov di, .command
    call strcmp
    jne .skip
    mov si, .test_msg
    call print
    mov byte [cmd_handled], 1
.skip:
    ret

.command db "test", 0
.test_msg db "Test command executed!", 0x0D, 0x0A, 0 