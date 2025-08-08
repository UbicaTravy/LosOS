check_info:
    mov di, info_cmd
    call strcmp
    jne .not_info
    
    mov si, info_info
    call print
    mov byte [cmd_handled], 1
    
.not_info:
    ret

info_cmd db "info", 0
info_info:
    db "/==================================================================\", 0x0D, 0x0A
    db "|      __         ______     ______        ______     ______       |", 0x0D, 0x0A
    db "|     /\ \       /\  __ \   /\  ___\      /\  __ \   /\  ___\      |", 0x0D, 0x0A
    db "|     \ \ \____  \ \ \/\ \  \ \___  \     \ \ \/\ \  \ \___  \     |", 0x0D, 0x0A
    db "|      \ \_____\  \ \_____\  \/\_____\     \ \_____\  \/\_____\    |", 0x0D, 0x0A
    db "|       \/_____/   \/_____/   \/_____/      \/_____/   \/_____/    |", 0x0D, 0x0A
    db "|                                                                  |", 0x0D, 0x0A
    db "|==================================================================|", 0x0D, 0x0A
    db "|                              Los OS v1.0                         |", 0x0D, 0x0A
    db "|==================================================================|", 0x0D, 0x0A
    db "|  Official Pid OS Distribution                                    |", 0x0D, 0x0A
    db "|  Based on: KillerGrass OS                                        |", 0x0D, 0x0A
    db "|  Architecture: x86 (16-bit)                                      |", 0x0D, 0x0A
    db "|  Language: Assembly (NASM)                                       |", 0x0D, 0x0A
    db "|  License: GNU GPL v3                                             |", 0x0D, 0x0A
    db "|  Creators: KillerGrass, losos, Findix                            |", 0x0D, 0x0A
    db "|==================================================================|", 0x0D, 0x0A
    db "|                       THANKS KillerGrass OS!                     |", 0x0D, 0x0A
    db "\==================================================================/", 0x0D, 0x0A, 0 
    