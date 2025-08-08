check_reboot:
    mov di, .command
    call strcmp
    jne .skip
    mov si, .reboot_msg
    call print
	mov byte [cmd_handled], 1
    ; триггер 8042 контроллера клавиатуры для перезагрузки
    mov al, 0xFE
    out 0x64, al
    ret
.skip:
    ret

.command db "reboot", 0
.reboot_msg db "Restarting system...", 0x0D, 0x0A, 0