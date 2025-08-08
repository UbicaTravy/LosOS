check_disk:
    mov di, .command
    call strcmp
    jne .skip
    
    mov si, .disk_msg
    call print
    
    ; получаем информацию о диске через BIOS
    mov ah, 0x08
    mov dl, 0x80  ; первый жесткий диск
    int 0x13
    jc .error
    
    ; выводим количество головок
    mov si, .heads_msg
    call print
    mov al, dh
    inc al  ; нумерация с 0
    call .print_dec
    mov si, .crlf
    call print
    
    ; выводим количество секторов на дорожку
    mov si, .sectors_msg
    call print
    mov al, cl
    and al, 0x3F  ; младшие 6 бит
    call .print_dec
    mov si, .crlf
    call print
    
    ; выводим количество цилиндров
    mov si, .cylinders_msg
    call print
    mov al, cl
    shr al, 6
    mov ah, ch
    mov al, ah
    call .print_dec
    mov si, .crlf
    call print
    
    jmp .done
    
.error:
    mov si, .error_msg
    call print
.done:
    mov byte [cmd_handled], 1
.skip:
    ret

.print_dec:
    mov ah, 0
    mov bl, 10
    div bl
    mov bx, ax
    mov al, bl
    add al, '0'
    mov ah, 0x0E
    int 0x10
    mov al, bh
    add al, '0'
    mov ah, 0x0E
    int 0x10
    ret

.command db "disk", 0
.disk_msg db "Disk Information:", 0x0D, 0x0A, 0
.heads_msg db "Heads: ", 0
.sectors_msg db "Sectors per track: ", 0
.cylinders_msg db "Cylinders: ", 0
.error_msg db "Error reading disk info", 0x0D, 0x0A, 0
.crlf db 0x0D, 0x0A, 0 