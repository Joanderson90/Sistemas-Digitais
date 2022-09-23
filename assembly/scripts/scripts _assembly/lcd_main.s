.equ pagelen, 4096	
.equ setregoffset, 28	
.equ clrregoffset, 40	
.equ prot_read, 1 	
.equ prot_write, 2 
.equ map_shared, 1 
.equ sys_open, 5	
.equ sys_map, 192	
.equ nano_sleep, 162	
.equ level, 52



.macro nanoSleep time
        LDR R0,=\time  
        LDR R1,=\time 
        MOV R7, #nano_sleep
        SVC 0
.endm

.macro GPIODirectionOut pin
        LDR R2, =\pin 	 
        LDR R2, [R2] 	
        LDR R1, [R8, R2] 
        LDR R3, =\pin 	
        ADD R3, #4 	 
        LDR R3, [R3] 	 
        MOV R1, #0b111 	
        LSL R1, R3 	 
        BIC R1, R1 	 
        MOV R1, #1 	
        LSL R1, R3 	
        ORR R1, R1 	 
        STR R1, [R8, R2]
.endm

.macro GPIOTurnOn pin
        MOV R2, R8 	      
        ADD R2, #setregoffset 
        MOV R1, #1 	     
        LDR R3, =\pin 	     
        ADD R3, #8 	      
        LDR R3, [R3] 	     
        LSL R1, R3 	      
        STR R1, [R2] 	      


.macro GPIOTurnOff pin
        MOV R2, R8 	     
        ADD R2, #clrregoffset 
        MOV R1, #1 	      
        LDR R3, =\pin 	     
        ADD R3, #8	     
        LDR R3, [R3]	    
        LSL R1, R3	      
        STR R1, [R2]	     
.endm


.macro SetValueGPIO pin, value
        MOV R2, R8 
        CMP value, #0
        ADDEQ R2, #clrregoffset 
        CMP value, #1
        ADDEQ R2, #setregoffset 
        MOV R1, #1 
        LDR R3, =\pin 
        ADD R3, #8
        LDR R3, [R3]
        LSL R1, R3
        STR R1, [R2]
.endm


.macro SetPinsDisplayOut
        GPIODirectionOut pinD7
        GPIODirectionOut pinD6
        GPIODirectionOut pinD5
        GPIODirectionOut pinD4
        GPIODirectionOut pinEN
        GPIODirectionOut pinRS
       
.endm

.macro SetEnable
        GPIOTurnOff pinEN
        nanoSleep time1ms
        GPIOTurnOn pinEN
        nanoSleep time1ms
        GPIOTurnOff pinEN
.endm

.macro  FunctionSet
        GPIOTurnOff pinRS
        GPIOTurnOff pinD7
        GPIOTurnOff pinD6
        GPIOTurnOn pinD5
        GPIOTurnOff pinD4
        enable
.endm


.macro OnDisplay
        GPIOTurnOff pinRS
        GPIOTurnOff pinD7
        GPIOTurnOff pinD6
        GPIOTurnOff pinD5
        GPIOTurnOff pinD4
        enable

        GPIOTurnOff pinRS
        GPIOTurnOn pinD7
        GPIOTurnOn pinD6
        GPIOTurnOn pinD5
        GPIOTurnOn pinD4
        enable
.endm


.macro  OffDisplay
        GPIOTurnOff pinRS
        GPIOTurnOff pinD7
        GPIOTurnOff pinD6
        GPIOTurnOff pinD5
        GPIOTurnOff pinD4
        enable

        GPIOTurnOff pinRS
        GPIOTurnOn pinD7
        GPIOTurnOff pinD6
        GPIOTurnOff pinD5
        GPIOTurnOff pinD4
        enable	
.endm

.macro  ClearDisplay
        GPIOTurnOff pinRS
        GPIOTurnOff pinD7
        GPIOTurnOff pinD6
        GPIOTurnOff pinD5
        GPIOTurnOff pinD4
        enable

        GPIOTurnOff pinRS
        GPIOTurnOff pinD7
        GPIOTurnOff pinD6
        GPIOTurnOff pinD5
        GPIOTurnOn pinD4
        enable
.endm

.macro  EntrySetMode
        GPIOTurnOff pinRS
        GPIOTurnOff pinD7
        GPIOTurnOff pinD6
        GPIOTurnOff pinD5
        GPIOTurnOff pinD4
        enable

        GPIOTurnOff pinRS
        GPIOTurnOff pinD7
        GPIOTurnOn pinD6
        GPIOTurnOn pinD5
        GPIOTurnOff pinD4
        enable

.endm


.macro WriteNumber number

        LDR R9, =\number

        SetUpperBitsDefaultNumber

        MOV R2, R9
        LSR R2, R2, #3 
        AND R1, R2, #1
        SetValueGPIO pinD7, R1

        MOV R2, R9
        LSR R2, R2, #2 
        AND R1, R2, #1
        SetValueGPIO pinD6, R1

        MOV R2, R9
        LSR R2, R2, #1 
        AND R1, R2, #1
        SetValueGPIO pinD5, R1

        MOV R2, R9
        AND R1, R2, #1
        SetValueGPIO pinD4, R1

        enable
	
.endm

.macro  SetUpperBitsDefaultNumber
        GPIOTurnOn pinRS
        GPIOTurnOff pinD7
        GPIOTurnOff pinD6
        GPIOTurnOn pinD5
        GPIOTurnOn pinD4

        enable
        GPIOTurnOn pinRS
.endm

.macro WriteNumber9

        SetUpperBitsDefaultNumber

        GPIOTurnOn pinD7
        GPIOTurnOff pinD6
        GPIOTurnOff pinD5
        GPIOTurnOn pinD4
        enable
	
.endm


.macro InitDisplay 
       
       SetPinsDisplayOut
       ClearDisplay
       FunctionSet
       FunctionSet
       FunctionSet
       OnDisplay
       EntrySetMode
	
.endm


.global _start


_start:
        InitDisplay
        WriteNumber9

end:
        MOV R7, #1
        SVC 0


.data

fileName: .asciz "/dev/mem"
gpioaddr: .word 0x20200

time1ms:
        .word 0
        .word 070000000

time1s:
        .word 1
        .word 000000000


pinD4:	
	.word 4  
	.word 6  
	.word 12 

pinD5:	
	.word 4  
	.word 18 
	.word 16 

pinD6:	
	.word 8  
	.word 0  
	.word 20

pinD7:	
	.word 8   
	.word 3  
	.word 21 

pinRS:	
	.word 8	 
	.word 15
	.word 25 

pinEN:	
	.word 0  
	.word 3  
	.word 1  

