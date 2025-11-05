loadDriveRM:
    push bp
    mov  bp, sp

    mov  ah, 0x02              ; BIOS: read sectors
    mov  dh, [bp+14]           ; head
    mov  dl, [bp+16]           ; drive
    mov  ch, [bp+12]           ; cylinder
    mov  cl, [bp+10]           ; sector (1-based)
    mov  al, [bp+8]            ; sector count
    mov  bx, [bp+4]            ; offset
    mov  es, [bp+6]            ; segment

    int  0x13
    jc   loadDriveRM_err       ; if carry, error

    mov  ah, 0x0E
    mov  al, '0'
    int  0x10
    jmp  loadDriveRM_done

loadDriveRM_err:
    mov  ah, 0x0E
    mov  al, '!'
    int  0x10

loadDriveRM_done:
    pop  bp
    ret  14
