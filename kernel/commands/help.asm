check_help:
    mov di, .command
    call strcmp
    jne .skip
    mov si, .help_msg
    call print
	mov byte [cmd_handled], 1
.skip:
    ret

.command db "help", 0
.help_msg db "+---------------------------------------+", 0x0D, 0x0A
          db "| Available commands:                   |", 0x0D, 0x0A
          db "+---------------------------------------+", 0x0D, 0x0A
          db "| help   - Show this help               |", 0x0D, 0x0A
          db "| clear  - Clear screen                 |", 0x0D, 0x0A
          db "| info   - System info                  |", 0x0D, 0x0A
          db "| mem    - Memory info                  |", 0x0D, 0x0A
          db "| time   - Show time                    |", 0x0D, 0x0A
          db "| date   - Show date                    |", 0x0D, 0x0A
          db "| ver    - Show version                 |", 0x0D, 0x0A
          db "| cpu    - CPU info                     |", 0x0D, 0x0A
          db "| disk   - Disk info                    |", 0x0D, 0x0A
          db "| bios   - BIOS info                    |", 0x0D, 0x0A
          db "| calc   - Calculator                   |", 0x0D, 0x0A
          db "| paint  - Text Paint Program           |", 0x0D, 0x0A
          db "| kg     - Open KillerGrass Text Editor |", 0x0D, 0x0A
          db "| reboot - Restart system               |", 0x0D, 0x0A
          db "| guess  - guess number game            |", 0x0D, 0x0A
          db "| exit   - Shutdown                     |", 0x0D, 0x0A
          db "| mge    - Lock computer (10 min)       |", 0x0D, 0x0A
          db "| furry  - Enable furry art mode        |", 0x0D, 0x0A
          db "+---------------------------------------+", 0x0D, 0x0A, 0