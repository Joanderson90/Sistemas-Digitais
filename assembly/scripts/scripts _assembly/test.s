.equ pagelen, 4096
.equ setregoffset, 28
.equ clrregoffset, 40
.equ prot_read, 1
.equ prot_write, 2
.equ map_shared, 1
.equ sys_open, 5
.equ sys_map, 192
.equ nano_sleep, 162
.equ level, 0x034

.global MapAddressGpio

MapAddressGpio:
        LDR R0, = fileName
        MOV R1, #0x1b0
        ORR R1, #0x006
        MOV R2, R1
        MOV R7, #sys_open
        SVC 0
        MOVS R4, R0

        LDR R5, =gpioaddr
        LDR R5, [R5]
        MOV R1, #pagelen
        MOV R2, #(prot_read + prot_write)
        MOV R3, #map_shared
        MOV R0, #0
        MOV R7, #sys_map
        SVC 0
        MOVS R8, R0


.globl SetGpioFunction
SetGpioFunction:
        pinNum .req r0
        pinFunc .req r1
	cmp pinNum,#53
	cmpls pinFunc,#7
	movhi pc,lr

	push {lr}
	mov r2,pinNum
	.unreq pinNum
	pinNum .req r2
	bl MapAddressGpio
	gpioAddr .req r8

	functionLoop$:
		cmp pinNum,#9
		subhi pinNum,#10
		addhi gpioAddr,#4
		bhi functionLoop$

	auxPinNum .req r3
	mov auxPinNum, pinNum
	lsl pinNum, #1
	add pinNum, pinNum, auxPinNum
	lsl pinFunc,pinNum
	.unreq auxPinNum

	mask .req r3
	mov mask,#7					/* r3 = 111 in binary */
	lsl mask,pinNum				/* r3 = 11100..00 where the 111 is in the same position as the function in r1 */
	.unreq pinNum

	mvn mask,mask				/* r3 = 11..1100011..11 where the 000 is in the same poisiont as the function in r1 */
	oldFunc .req r2
	ldr oldFunc,[gpioAddr]		/* r2 = existing code */
	and oldFunc,mask			/* r2 = existing code with bits for this pin all 0 */
	.unreq mask

	orr pinFunc,oldFunc			/* r1 = existing code with correct bits set */
	.unreq oldFunc

	str pinFunc,[gpioAddr]
	.unreq pinFunc
	.unreq gpioAddr
	pop {pc}


.globl SetGpioValue
SetGpioValue:	
        pinNum .req r0
        pinVal .req r1

        cmp pinNum,#53
	movhi pc,lr
	push {lr}
	mov r2,pinNum	
        .unreq pinNum	
        pinNum .req r2
	bl MapAddressGpio
        gpioAddr .req r8

	pinBank .req r3
	lsr pinBank,pinNum,#5
	lsl pinBank,#2
	add gpioAddr,pinBank
	.unreq pinBank

	and pinNum,#31
	setBit .req r3
	mov setBit,#1
	lsl setBit,pinNum
	.unreq pinNum

	teq pinVal,#0
	.unreq pinVal
	streq setBit,[gpioAddr,#40]
	strne setBit,[gpioAddr,#28]
	.unreq setBit
	.unreq gpioAddr
	pop {pc}



.global GetPinValue
GetPinValue:
    pinNum .req r0
    cmp pinNum,#53
	movhi pc,lr
    .unreq pinNum
        
	push {lr}
	bl MapAddressGpio
    gpioAddr .req r8

	
	ldr r1,[gpioAddr,#34]
	.unreq gpioAddr
    mov r0, r1
	pop {pc}



.data
fileName: .asciz "/dev/mem"
gpioaddr: .word 0x20200