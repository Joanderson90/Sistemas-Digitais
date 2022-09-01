@Comments


.global _start

._start:
    mov R0, #1
    ldr R1, =helloworld
    mov R2, #13
    mov R7, #4
    svc 0

.data
    helloworld: .ascii "Hello World!\n"