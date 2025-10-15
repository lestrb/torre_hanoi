; Hanoi
; al -> número do input em ascii
; ah -> número do input "normal"
; rbx -> mensagem a ser printada
; rcx -> tamanho da mensagem
; r8, r9 e r10 -> discos A, B e C

; tentar dar push antes do syscall e pop depois, usando rax, rbx, rcx e rdx pros registradores de hanoi pra ver se saem mensagens
; NAO TA PRINTANDO FRASE
; CHAT SUGERIU MUDAR AH POR RSI


section .data
    msg_hanoi db 'Torre de Hanoi!', 10
    msg_hanoi_len equ $ - msg_hanoi

    msg_discos db 'Digite o numero de discos (entre 0 e 9): ', 10
    msg_discos_len equ $ - msg_discos

    msg_inicial db 'Algoritmo da Torre de Hanoi com X discos', 10
    msg_inicial_len equ $ - msg_inicial

    msg_movimentos db 'Mova disco X da Torre Y para a Torre Z', 10 ; posições: x-11, y-22, z-37
    msg_movimentos_len equ $ - msg_movimentos

    msg_concluido db 'Concluido!', 10
    msg_concluido_len equ $ - msg_concluido
    
section .bss
    numero resb 1
    pilha resb 4096         ; reserva 4 KB para a pilha

section .text
    global _start

_print:
    mov rax, 1              ; syscall: write
    mov rdi, 1              ; stdout
    mov rsi, rbx            ; rbx -> mensagem a ser printada
    mov rdx, rcx            ; rcx -> tamanho da mensagem
    syscall
    ret

_hanoi:
    ; checa se input (ah) foi diferente de 0 pra printar frase e seguir
    cmp ah, 0               
    je .fim_hanoi          ; se ah == 0, acaba função e retorna nada

    ; caso não seja 0, empilha o estado atual antes da chamada recursiva
    push r9                ; torre origem
    push r10               ; torre destino
    push r11               ; torre auxiliar
    push ax                ; número de discos (ah)

    ; troca os registradores de auxiliar/destino e decrementa num de discos
    mov r12, r10           ; salva destino em r12
    mov r10, r11           ; salva aux no antigo destino
    mov r11, r12           ; salva destino na antiga aux            
    dec ah                 ; n = n - 1

    ; hanoi(n-1, origem, auxiliar, destino)
    call _hanoi

    ; desempilha o estado antes da chamada recursiva
    pop ax            
    pop r11            
    pop r10              
    pop r9               

    ; imprime o movimento atual
    add ah, '0'                               ; converte numero de discos ṕra ASCII
    mov [msg_movimentos + 11], ah        ; número do disco em ASCII
    mov [msg_movimentos + 22], r9        ; torre origem
    mov [msg_movimentos + 37], r10       ; torre destino
    mov rbx, msg_movimentos
    mov rcx, msg_movimentos_len
    call _print

    ; empilha novamente o estado antes da segunda chamada recursiva
    push r9
    push r10
    push r11
    push ax

    ; troca os registradores de auxiliar/destino e decrementa num de discos
    mov r12, r9          ; origem em r12
    mov r9, r11          ; nova origem = auxiliar
    mov r11, r12         ; nova auxiliar = antiga origem
    dec ah               ; n = n - 1

    ; hanoi(n-1, auxiliar, destino, origem)
    call _hanoi

    ; desempilha o estado antes da chamada recursiva
    pop ax
    pop r11
    pop r10
    pop r9

.fim_hanoi: 
    ret

_start:
    ; Inicializa rsp para o topo da pilha
    lea rsp, [pilha + 4096]  ; pilha cresce para baixo (lea calcula o endereço e coloca em rsp)

    ; output dizendo que é torre de hanoi
    mov rbx, msg_hanoi
    mov rcx, msg_hanoi_len
    call _print

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
    mov al, [numero]        ; al guarda caractere em ascii (pro print)
    mov ah, [numero]        
    sub ah, '0'             ; converte em numero e fica em ah (pra decrementar e incrementar)

    ; output indicando número de discos
    mov byte [msg_inicial + 32], al   ; substitui o 'X' pelo número 
    mov rbx, msg_inicial
    mov rcx, msg_inicial_len
    call _print

    ; chama função hanoi (ah -> numero de discos)
    mov r8, 'A'
    mov r9, 'B'
    mov r10, 'C'
    call _hanoi

fim:    
    ; output concluido
    mov rbx, msg_concluido
    mov rcx, msg_concluido_len
    call _print

    ; exit system call
    mov rax, 60         ; sys_exit
    mov rdi, 0          ; exit status
    syscall
