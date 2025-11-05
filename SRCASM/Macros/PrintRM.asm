printRM:
    push bp
    mov bp,sp
    mov si,[bp+4]
    mov ah,0xe
printRM_loop:
    lodsb
    cmp al,'$'
    je printRM_done
    int 0x10
    jmp printRM_loop
printRM_done:
    pop bp
    ret 2