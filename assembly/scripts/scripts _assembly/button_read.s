.include "gpio.s"

.equ PIN_NUM_BUTTON, 5
.equ PIN_NUM_LED, 6

.global main

main:
    mov r0, #PIN_NUM_BUTTON
    mov r1, #0
    bl SetGpioFunction
    b loop$


loop$:
    mov r0, #PIN_NUM_BUTTON
    bl GetPinValue:
    tst r0, #1 << PIN_NUM_BUTTON
    beq onLed
    b loop$ 


onLed:
    
    mov r0, #PIN_NUM_LED
    mov r1, #1
    bl SetGpioFunction

    mov r0, #PIN_NUM_LED
    mov r1, #0
    bl SetGpioValue

    b loop$ 
