

vgaPrintPM:
    push ebp
    mov ebp,esp

    mov ebx,[ebp+8]         ;[ebp+8] String pointer
    mov edx, VIDEO_MEMORY
    mov ah, VIDEO_MODE
vgaPrintPM_loop:
    mov al,[ebx]
    cmp al,0
    je vgaPrintPM_end
    inc ebx
    mov word [edx],ax       ;[ASCII:MODE]
    add edx,2

    jmp vgaPrintPM_loop
vgaPrintPM_end:
    pop ebp

    ret 4