global _start:

_start:
    mov r0, #1
    ldr r1, =msg
    ldr r2, =lenmsg
    mov r7, #4
    svc 0

    mov r0, #0
    ldr r1, =input
    mov r2, #10
    mov r7, #3
    svc 0

    mov r0, #8
    mov r7, #1
    svc 0

.bss
    input: .ascii ""

    
.data
    msg: .ascii "Type something:\n"
    lenmsg = .-msg
