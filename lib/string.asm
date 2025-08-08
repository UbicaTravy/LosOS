; сравнение строк (возвращает ZF=1 если равны, ZF=0 если не равны)
strcmp:
    ; сохраняем регистры чтобы не сломать вызывающий код
    push si
    push di
    
.loop:
    mov al, [si]
    cmp al, [di]
    jne .not_equal
    test al, al
    jz .equal
    inc si
    inc di
    jmp .loop
.equal:
    ; восстанавливаем регистры
    pop di
    pop si
    xor ax, ax  ; устанавливаем флаг нуля (ZF=1) - строки равны
    ret
.not_equal:
    ; восстанавливаем регистры
    pop di
    pop si
    mov ax, 1   ; сбрасываем флаг нуля (ZF=0) - строки не равны
    ret