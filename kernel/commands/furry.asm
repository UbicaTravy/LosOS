check_furry:
    mov di, furry_command
    call strcmp
    jne .skip
    
    ; показываем агрессивное сообщение
    mov si, furry_enabled_msg
    call print
    
    ; ждем нажатия enter
    mov si, press_enter_msg
    call print
    
.wait_enter:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0D  ; enter key
    jne .wait_enter
    
    ; выполняем команду mge
    mov si, mge_command
    call execute_command
    
    mov byte [cmd_handled], 1
.skip:
    ret

; функция для показа фурри сообщения (если режим включен)
show_furry_art:
    cmp byte [furry_mode], 0
    je .skip_art
    
    ; показываем сообщение
    mov si, furry_message
    call print
    
.skip_art:
    ret

furry_command db "furry", 0
furry_enabled_msg db "AHA! Got you, furry wanker? Maybe I should show your mom what you're doing here? TURN OFF THE COMPUTER FAST!", 0x0D, 0x0A, 0
press_enter_msg db "Press ENTER to continue...", 0x0D, 0x0A, 0
mge_command db "mge", 0
furry_mode db 0
furry_message db "FURRY DETECTED! TURN OFF THE COMPUTER NOW!", 0x0D, 0x0A, 0 