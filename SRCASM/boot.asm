[org 0x7c00]
bits 16

jmp start

%include "SRCASM/Macros/LoadDriveRM.asm"

start:
mov bx,0x070
mov ss,bx   
mov sp,bx
mov [drive_number],dl       ;save which drive we are working on in DL

;Load Post Boot

push [drive_number]  ; drive
push 0x0000          ; head
push 0x0000          ; cylinder
push 0x0002          ; sector start (1-based)
push 0x0001          ; count
push 0x0000          ; segment
push 0x8000          ; offset
call loadDriveRM

;Load Kernel

push [drive_number]  ; drive
push 0x0000          ; head
push 0x0000          ; cylinder
push 0x0003          ; sector start (1-based)
push 0x0005          ; count
push 0x0000          ; segment
push 0x1000          ; offset

call loadDriveRM

jmp 0x0000:0x8000

drive_number db 0

times 510-$+$$ db 0
               dw 0xaa55