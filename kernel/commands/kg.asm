bits 16

extern kg_editor

check_kg:
    mov di, cmd_kg
    call strcmp
    jne .skip
    ; запускаем текстовый редактор
    mov byte [cmd_handled], 1
    call kg_editor
.skip:
    ret

cmd_kg db "kg", 0