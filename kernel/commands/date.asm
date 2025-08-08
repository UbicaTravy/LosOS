check_date:
    mov di, .command
    call strcmp
    jne .skip
    
    mov si, .date_msg
    call print
    
    ; получаем дату от BIOS
    mov ah, 0x04
    int 0x1A
    jc .error
    
    ; день недели
    mov al, dl
    call .print_day
    
    ; день
    mov al, dh
    call .print_bcd
    mov al, '/'
    call .print_char
    
    ; месяц
    mov al, cl
    call .print_bcd
    mov al, '/'
    call .print_char
    
    ; год
    mov al, ch
    call .print_bcd
    mov al, '2'
    call .print_char
    mov al, '0'
    call .print_char
    mov al, ch
    call .print_bcd
    
    jmp .done
    
.error:
    mov si, .error_msg
    call print
.done:
    mov si, .crlf
    call print
    mov byte [cmd_handled], 1
.skip:
    ret

.print_day:
    cmp al, 0
    je .sun
    cmp al, 1
    je .mon
    cmp al, 2
    je .tue
    cmp al, 3
    je .wed
    cmp al, 4
    je .thu
    cmp al, 5
    je .fri
    jmp .sat
.sun:
    mov si, .sunday
    jmp .print_day_name
.mon:
    mov si, .monday
    jmp .print_day_name
.tue:
    mov si, .tuesday
    jmp .print_day_name
.wed:
    mov si, .wednesday
    jmp .print_day_name
.thu:
    mov si, .thursday
    jmp .print_day_name
.fri:
    mov si, .friday
    jmp .print_day_name
.sat:
    mov si, .saturday
.print_day_name:
    call print
    mov al, ' '
    call .print_char
    ret

.print_bcd:
    mov ah, al
    shr al, 4
    add al, '0'
    call .print_char
    mov al, ah
    and al, 0x0F
    add al, '0'
.print_char:
    mov ah, 0x0E
    int 0x10
    ret

.command db "date", 0
.date_msg db "Current date: ", 0
.error_msg db "Error reading date", 0x0D, 0x0A, 0
.crlf db 0x0D, 0x0A, 0
.sunday db "Sun", 0
.monday db "Mon", 0
.tuesday db "Tue", 0
.wednesday db "Wed", 0
.thursday db "Thu", 0
.friday db "Fri", 0
.saturday db "Sat", 0 