check_bios:
    mov di, .command
    call strcmp
    jne .skip
    
    mov si, .bios_msg
    call print
    
    ; получаем информацию о BIOS (статическая информация)
    mov si, .vendor_msg
    call print
    mov si, .vendor_info
    call print
    
    mov si, .version_msg
    call print
    mov si, .version_info
    call print
    
    mov si, .date_msg
    call print
    mov si, .date_info
    call print
    
    mov byte [cmd_handled], 1
.skip:
    ret

.command db "bios", 0
.bios_msg db "BIOS Information:", 0x0D, 0x0A, 0
.vendor_msg db "Vendor: ", 0
.vendor_info db "Generic BIOS", 0x0D, 0x0A, 0
.version_msg db "Version: ", 0
.version_info db "Unknown", 0x0D, 0x0A, 0
.date_msg db "Date: ", 0
.date_info db "Unknown", 0x0D, 0x0A, 0 