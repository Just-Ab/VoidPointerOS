[org 0x8000]

jmp main

constword db 'Moved out of the boot sector successfuly!',0x0d,0x0a,'$'

section .text


%include "SRCASM/Macros/PrintRM.asm"


segments_init:
    cli
    xor ax,ax
    
    mov es,ax
    mov ds,ax

    pop bx
    mov ax,0x0050
    mov ss,ax
    mov ax,0x7eff
    sub ax,0x0500
    mov sp,ax
    push bx
    sti

    ret

main:
    call segments_init

    mov ax,constword
    push ax
    call printRM
    jmp switch_to_32_protected_mode
    
gdt_start:

gdt_null:
    dd 0x0
    dd 0x0

gdt_code: 

    dw 0xffff           ;segment limit  0-15 bits
    dw 0x0000           ;segment base   0-15 bits
    db 0x0000           ;segment base   16-23 bits
;--------------------------------------------------------------------------------------------------------
    db 10011010b        ;first flags 
    
                        ;present|privilege(2 bits)|descriptor-type|code|conforming|readable|accessed

    db 11001111b       ;second flags | segment limit   16-19 bits

                        ;granularity|32-bit default|64-bit seg|avl
;--------------------------------------------------------------------------------------------------------
    db 0x0000           ;segment base   24-31 bits

gdt_data:

    dw 0xffff           ;segment limit  0-15 bits
    dw 0x0000           ;segment base   0-15 bits
    db 0x0000           ;segment base   16-23 bits
;--------------------------------------------------------------------------------------------------------
    db 10010010b        ;first flags 
    
                        ;present|privilege(2 bits)|descriptor-type|code|conforming|readable|accessed

    db 11001111b        ;second flags | segment limit   16-19 bits

                        ;granularity|32-bit default|64-bit seg|avl
;--------------------------------------------------------------------------------------------------------
    db 0x0000           ;segment base   24-31 bits
    
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

switch_to_32_protected_mode:
    cli
    lgdt [gdt_descriptor]
    mov eax , cr0
    or eax,0x1
    mov cr0,eax
    jmp CODE_SEG:start_protected_mode




[bits 32]
    VIDEO_MEMORY equ 0xb8000
    VIDEO_MODE equ 00001111b

protected_mode_success_text db 'You are in 32-bit protected_mode!',0

%include "SRCASM/Macros/VGAPrintPM.asm"
%include "SRCASM/Macros/VGAClearPM.asm"

start_protected_mode:
    mov ax,DATA_SEG
    mov ds,ax
    mov ss,ax
    mov es,ax
    mov fs,ax
    mov gs,ax

    mov ebp,0x90000
    mov esp,ebp

    call protected_mode

OFFSET db 2 dup(0)

protected_mode:
    call vgaClearPM
    mov al,$
    sub al,$$
    mov [OFFSET],al

    mov eax,protected_mode_success_text
    push eax
    call vgaPrintPM
    call vgaClearPM
    call 0x1000

    hlt
    jmp $

times 1024 - ($ - $$) db 0 