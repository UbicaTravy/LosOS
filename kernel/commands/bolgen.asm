check_bolgen:
    mov di, .command
    call strcmp
    jne .skip
    mov si, .bolgen_msg
    call print
	mov byte [cmd_handled], 1
.skip:
    ret

.command db "bolgen", 0
.bolgen_msg db "Otsos OS is the best Linux distro! It is completely written with AI and has nothing of its own, not even a bootloader! NOPE, WE ARE NOT LYING - EVERYTHING IS SO!", 0x0D, 0x0A
          db "", 0x0D, 0x0A
          db "Well, what the fuck, Bolgen OS, did you get the hint?", 0x0D, 0x0A, 0