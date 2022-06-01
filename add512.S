#include <atmega32/asm/io.h>

.global add512

add512:
; the pointer should point to the sram
; the sram has 16 bit address
; the address of sram from 0x0060 to 0x085F
; to access sram (indirectly by using pointer registers), we should use the instruction LD and ST
; in total, we need 192 bytes to store all the 3 numbers


;// ptr to a is in R23:R22
;// ptr to b is in R21:R20
;// ptr to c is in R25:R24
    init:
    ; use pointer register X for a
        mov r26,   r22
        mov r27,   r23
    ; use pointer register Y for b
        mov r28,   r20
        mov r29,   r21
    ; use pointer register Z for c
        mov r30,   r24
        mov r31,   r25
    ; read the number a from sram
    ; at each address there's one byte stored
        ld r18,   X      ; read the LS 8 bits of a from sram
        ld r19,   Y      ; read the LS 8 bits of b from sram
        add r18,   r19
        st Z,     r18    ; store the result of LS 8 bits to sram
    ; increment of the address to the next byte
        inc r26
        inc r28
        inc r30
    
    ; the for loop from 2 to 64 (0 to 62)
    ldi r21, 0
    loop:
        out PORTB, r21
        inc r21

        ld r18, X
        ld r19, Y

        add r18, r19
        adc r18, r20
        st  Z,   r18

        inc r26
        inc r28
        inc r30

        in   r20,   SREG ; store the sreg in register r20
        andi r20,   0b00000001 ; we only take the carry bit

        cpi r21, 63 ; if r16-63=0, then no branch in the next column
        brne loop

    ret

.end


