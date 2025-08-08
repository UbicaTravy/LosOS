check_ver:
    mov di, .command
    call strcmp
    jne .skip
    
    mov si, .version_msg
    call print
    mov byte [cmd_handled], 1
.skip:
    ret

.command db "ver", 0
.version_msg db "Los OS v1.0", 0x0D, 0x0A
            db "Based on Pid OS", 0x0D, 0x0A
            db "Powered by KillerGrass OS", 0x0D, 0x0A
            db "Created by KillerGrass, losos, Findix", 0x0D, 0x0A
            db "License: GNU GPL v3", 0x0D, 0x0A, 0 