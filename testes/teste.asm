; Hanoi
; ah -> guarda número do input em ascii
; bh -> guarda número do input "normal"

section .data
    msg_discos db 'Digite o numero de discos (entre 0 e 9): ', 10
    msg_discos_len equ $ - msg_discos

    msg_inicial db 'Algoritmo da Torre de Hanoi com X discos', 10
    msg_inicial_len equ $ - msg_inicial

    msg_movimentos db 'Mova disco X da Torre Y para a Torre Z', 10 ; posições: x-11, y-22, z-37
    msg_movimentos_len equ $ - msg_movimentos
    
section .bss
    numero resb 1
    ;numero_ascii resb 2     ; caractere + '\n'

section .text
    global _start

_print:
    mov rax, 1              ; syscall: write
    mov rdi, 1              ; stdout
    mov rsi, rbx            ; rbx -> mensagem a ser printada
    mov rdx, rcx            ; rcx -> tamanho da mensagem
    syscall
    ret

_start:
    ; output pedindo número de discos
    mov rbx, msg_discos
    mov rcx, msg_discos_len
    call _print

    ; le número de discos
    mov rax, 0              ; syscall: read
    mov rdi, 0              ; stdin
    mov rsi, numero        
    mov rdx, 1              ; le 1 byte
    syscall 
    
    ; converte número ascii do input em numero
    mov bh, [numero]        ; bh guarda caractere em ascii (pro print)
    mov ah, [numero]        
    sub ah, '0'             ; converte em numero e fica em ah (pra decrementar e incrementar)
    
    ; output indicando número de discos
    mov byte [msg_inicial + 32], bh   ; substitui o 'X' pelo número 
    mov rbx, msg_inicial
    mov rcx, msg_inicial_len
    call _print




    syscall
    
    ; exit system call
    mov rax, 60         ; sys_exit
    mov rdi, 0          ; exit status
    syscall
