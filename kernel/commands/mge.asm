check_mge:
    mov di, .command
    call strcmp
    jne .skip
    
    mov si, .lock_msg
    call print
    
    ; сохраняем текущее время для отсчета 10 минут
    mov ah, 0x00
    int 0x1A
    mov [.start_time], cx
    mov [.start_time+2], dx
    
    ; очистка экрана и вывод сообщения о блокировке
    mov ax, 0x0003
    int 0x10
    mov si, .locked_msg
    call print
    
.lock_loop:
    
    ; проверяем, прошло ли 10 минут (600 секунд)
    mov ah, 0x00
    int 0x1A
    sub cx, [.start_time]
    sbb dx, [.start_time+2]
    
    ; конвертируем в секунды (примерно, я вам не хранитель времени блять)
    mov ax, cx
    mov bx, 18  ; примерно 18 тиков в секунду
    mul bx
    cmp ax, 10800  ; 10 минут * 60 секунд * 18 тиков
    jae .auto_unlock
    
    ; просто ждем и продолжаем цикл
    jmp .lock_loop
    
.auto_unlock:
    mov si, .auto_unlock_msg
    call print
    
.done:
    mov byte [cmd_handled], 1
.skip:
    ret

.command db "mge", 0
.lock_msg db "Computer locked! Auto-unlock in 10 minutes...", 0x0D, 0x0A, 0
.locked_msg db "+=============================================================================+", 0x0D, 0x0A
            db "|                                                                             |", 0x0D, 0x0A
            db "|                               COMPUTER LOCKED                               |", 0x0D, 0x0A
            db "|                                                                             |", 0x0D, 0x0A
            db "|                          Auto-unlock in 10 minutes                          |", 0x0D, 0x0A
            db "|                                                                             |", 0x0D, 0x0A
            db "|=============================================================================|", 0x0D, 0x0A
            db "|                                                                             |", 0x0D, 0x0A
            db "|                     If you don't wait - you are a FURRY!                    |", 0x0D, 0x0A
            db "|                                                                             |", 0x0D, 0x0A
            db "|                        Authors: KillerGrass, losos, Findix                  |", 0x0D, 0x0A
            db "|                                 Made in Russia!                             |", 0x0D, 0x0A
            db "|                                                                             |", 0x0D, 0x0A
            db "|=============================================================================|", 0x0D, 0x0A
            db "|           __         ______     ______        ______     ______             |", 0x0D, 0x0A
            db "|          /\ \       /\  __ \   /\  ___\      /\  __ \   /\  ___\            |", 0x0D, 0x0A
            db "|          \ \ \____  \ \ \/\ \  \ \___  \     \ \ \/\ \  \ \___  \           |", 0x0D, 0x0A
            db "|           \ \_____\  \ \_____\  \/\_____\     \ \_____\  \/\_____\          |", 0x0D, 0x0A
            db "|            \/_____/   \/_____/   \/_____/      \/_____/   \/_____/          |", 0x0D, 0x0A
            db "|                                                                             |", 0x0D, 0x0A
            db "|                             THANKS KillerGrass OS!                          |", 0x0D, 0x0A
            db "|                                                                             |", 0x0D, 0x0A
            db "+=============================================================================+", 0x0D, 0x0A, 0

.auto_unlock_msg db "Auto-unlock activated! Welcome back.", 0x0D, 0x0A, 0
.start_time times 4 db 0 

