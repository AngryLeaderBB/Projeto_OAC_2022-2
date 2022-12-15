.text
main:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        lui     s0,%hi(.LANCHOR0)
        li      a1,30
        addi    a0,s0,%lo(.LANCHOR0)
        call    show
        li      a1,30
        addi    a0,s0,%lo(.LANCHOR0)
        call    sort
        li      a1,30
        addi    a0,s0,%lo(.LANCHOR0)
        call    show
        li      a0,0
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        li a7, 10
        ecall
        
show:
         mv     t0,a0 
         mv     t1,a1 
         mv     t2,zero 
loop1:  beq     t2,t1,fim1 
        li      a7,1 
        lw      a0,0(t0) 
        ecall 
        li      a7,11 
        li      a0,9 
        ecall 
        addi    t0,t0,4 
        addi    t2,t2,1 
        j       loop1 
fim1:   li      a7,11 
        li      a0,10 
        ecall 

        ret
swap:
        slli    a1,a1,2
        add     a5,a0,a1
        lw      a4,0(a5)
        addi    a1,a1,4
        add     a0,a0,a1
        lw      a3,0(a0)
        sw      a3,0(a5)
        sw      a4,0(a0)
        ret
sort:
        ble     a1,zero,.L11
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        sw      s1,20(sp)
        sw      s2,16(sp)
        sw      s3,12(sp)
        sw      s4,8(sp)
        sw      s5,4(sp)
        sw      s6,0(sp)
        mv      s2,a0
        mv      s5,a0
        addi    s6,a1,-1
        li      s4,0
        li      s3,-1
        j       .L5
.L6:
        addi    s4,s4,1
        addi    s5,s5,4
.L5:
        mv      s0,s4
        beq     s4,s6,.L14
        blt     s0,zero,.L6
        mv      s1,s5
.L7:
        lw      a4,0(s1)
        lw      a5,4(s1)
        ble     a4,a5,.L6
        mv      a1,s0
        mv      a0,s2
        call    swap
        addi    s0,s0,-1
        addi    s1,s1,-4
        bne     s0,s3,.L7
        j       .L6
.L14:
        lw      ra,28(sp)
        lw      s0,24(sp)
        lw      s1,20(sp)
        lw      s2,16(sp)
        lw      s3,12(sp)
        lw      s4,8(sp)
        lw      s5,4(sp)
        lw      s6,0(sp)
        addi    sp,sp,32
        jr      ra
.L11:
        ret

