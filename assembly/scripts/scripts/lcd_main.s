
.include "gpio.s"
.data
.equ RS_NUM_PIN, 25
.equ EN_NUM_PIN, 1
.equ D4_NUM_PIN, 12
.equ D5_NUM_PIN, 16
.equ D6_NUM_PIN, 20
.equ D7_NUM_PIN, 21


.global write_mode_4b
write_mode_4b:

    push {lr}
    bl clear_display
    pop {pc}


clear_display:

    push {lr}
    bl set_rs_high
    bl set_d4_d7
    bl pulse_en
    bl set_d0_d3
    bl pulse_en
    pop {pc}    

set_rs_high:
    push {lr}

    mov r0, #RS_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #RS_NUM_PIN
    mov r1, #1
    bl SetGpioValue

    pop {pc}


set_d4_d7:
    push {lr}

    mov r0, #D4_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #D4_NUM_PIN
    mov r1, #0
    bl SetGpioValue

    mov r0, #D5_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #D5_NUM_PIN
    mov r1, #0
    bl SetGpioValue

    mov r0, #D6_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #D6_NUM_PIN
    mov r1, #0
    bl SetGpioValue

    mov r0, #D7_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #D7_NUM_PIN
    mov r1, #0
    bl SetGpioValue

    pop {pc}

pulse_en:
    push {lr}

    mov r0, #EN_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #EN_NUM_PIN
    mov r1, #0
    bl SetGpioValue

    bl delay
    
    mov r0, #EN_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #EN_NUM_PIN
    mov r1, #1
    bl SetGpioValue

    bl delay

    mov r0, #EN_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #EN_NUM_PIN
    mov r1, #0
    bl SetGpioValue

    pop {pc}

delay:
    mov r3,#0x3F0000
    loop$:
        sub r3,#1
        cmp r3,#0
        bne loop$

    pop {pc}
    
set_d0_d3:
    push {lr}

    mov r0, #D4_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #D4_NUM_PIN
    mov r1, #1
    bl SetGpioValue

    mov r0, #D5_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #D5_NUM_PIN
    mov r1, #0
    bl SetGpioValue

    mov r0, #D6_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #D6_NUM_PIN
    mov r1, #0
    bl SetGpioValue

    mov r0, #D7_NUM_PIN
    mov r1, #1
    bl SetGpioFunction
    mov r0, #D7_NUM_PIN
    mov r1, #0
    bl SetGpioValue

    pop {pc}


