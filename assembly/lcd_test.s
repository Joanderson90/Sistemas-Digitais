.include "lcd_main.s"
.global main

main:
    bl write_mode_4b
    b end

end:
    mov r7, #1
    swi 0