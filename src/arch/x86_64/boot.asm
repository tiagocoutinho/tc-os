global start                           ; start will be the entry point of our kernel, it needs to be public.

section .text                          ; default section for executable code
bits 32                                ; 32-bit instructions. It’s needed because the CPU is still in Protected mode
                                       ; when GRUB starts our kernel.
start:
    mov dword [0xb8000], 0x2f4b2f4f    ; print `OK` to screen
    hlt
