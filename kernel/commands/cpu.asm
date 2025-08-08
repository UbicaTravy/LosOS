check_cpu:
    mov di, .command
    call strcmp
    jne .skip
    
    mov si, .cpu_msg
    call print
    
    ; получаем информацию о процессоре через CPUID
    mov eax, 0
    cpuid
    
    ; выводим производителя (первые 4 символа)
    mov si, .vendor_msg
    call print
    mov cx, 4
    mov si, .vendor_buffer
.print_vendor:
    mov al, [si]
    mov ah, 0x0E
    int 0x10
    inc si
    loop .print_vendor
    
    mov si, .crlf
    call print
    
    ; выводим модель процессора
    mov si, .model_msg
    call print
    mov si, .model_info
    call print
    
    mov byte [cmd_handled], 1
.skip:
    ret

.command db "cpu", 0
.cpu_msg db "CPU Information:", 0x0D, 0x0A, 0
.vendor_msg db "Vendor: ", 0
.model_msg db "Model: 8086/8088 compatible", 0x0D, 0x0A, 0
.crlf db 0x0D, 0x0A, 0
.vendor_buffer times 4 db 0
.model_info db "Architecture: x86 (16-bit)", 0x0D, 0x0A, 0 