.data

rect1: .word 28, 9, 73 ,50
rect2: .word 58, 61, 107,69

#rect1: .word 0, 10, 7 ,50
#rect2: .word 58, 27, 107,69

player_hitbox: .word 3, 1, 5, 3

hitboxes: .word 2,
1,  
teste1: 1, 4, 3, 7
2,  
teste2: .word 1, 2, 3, 4


.text

#la a0, player_hitbox
#la a1, teste2

#la a0, rect1
#la a1, rect2
#jal doOverlap

# lw a0,8(a1)

#li a7,1
#ecall

la a0, player_hitbox
la a1, hitboxes
jal player_hitbox_interaction


li a7,10
ecall

player_hitbox_interaction:
        lw      a2,0(a1)
        addi    a1,a1,4
        ble     a2,zero,PHI7
        li      a5,0
        j       PHI11
PHI13:
        lw      a3,4(a1)
        lw      a4,8(a0)
        bgt     a3,a4,PHI9
        lw      a3,12(a0)
        lw      a4,8(a1)
        blt     a3,a4,PHI9
        lw      a3,16(a1)
        lw      a4,4(a0)
        blt     a3,a4,PHI9
        lw      a4,0(a1)
        addi sp,sp,-4
        sw a0,0(sp)
        mv a0,a4 
        li a7, 1
        ecall
        lw a0,0(sp)
        addi sp,sp,4
        addi    a5,a5,1
        addi    a1,a1,20
        beq     a2,a5,PHI7
PHI11:
        lw      a3,0(a0)
        lw      a4,12(a1)
        ble     a3,a4,PHI13
PHI9:
        addi sp,sp,-4
        sw a0,0(sp)
        li a0,-1 
        li a7, 1
        ecall
        lw a0,0(sp)
        addi sp,sp,4
        addi    a5,a5,1
        addi    a1,a1,20
        bne     a2,a5,PHI11
PHI7:
        ret


doOverlap:
        lw      a3,0(a0)
        lw      a4,8(a1)
        mv      a5,a0
        bgt     a3,a4,.L3
        lw      a4,8(a0)
        lw      a3,0(a1)
        li      a0,0
        bgt     a3,a4,.L2
        lw      a3,12(a5)
        lw      a4,4(a1)
        blt     a3,a4,.L2
        lw      a0,12(a1)
        lw      a5,4(a5)
        slt     a0,a0,a5
        xori    a0,a0,1
        ret
.L3:
        li      a0,0
.L2:
        ret