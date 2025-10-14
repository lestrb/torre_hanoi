; Hello World in Assembly (Pure System Calls)
section .data
    msg db 'Hello, World!', 10, 0
    msg_len equ $ - msg - 1

section .text
    global _start

_start:
