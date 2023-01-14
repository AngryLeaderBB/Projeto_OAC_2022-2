.include "../MACROSv21.s"
.macro image(%imageAddressRegis , %xLower , %yLower)
	#address is the address of the bitmap display

	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	
	jal ra,Image

.end_macro

.macro iterate_animation(%imageAddressRegis , %xLower , %yLower, %should_loop)
	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	mv a3,%should_loop
	
	jal ra,Animation_Iterator
.end_macro

.macro print_regis(%regis,%is_hexa)
	sw a0,-4(sp)
	sw t0,-8(sp)
	li a7,1
	li t0,%is_hexa
	beq t0,zero,Dec
	addi a7,a7,33
Dec:
	lw t0,-8(sp)
	mv a0,%regis
	ecall
	li a0,10
	li a7,11
	ecall
	lw a0,-4(sp)
	
.end_macro

.data

.include "mapaTeste.data"
.include "walk.data"
#.include "pkmnSelect.data"
#.include "stadium.data"
#.include "open1.data"
#.include "open2.data"
.include "stages.data"

CONST_FLOAT: .float 10

imagem: .word 0,0,0
player_real_position: .float 160, 130
player_position: .word 160, 130
player_last_position: .word 0,0

animation_state: .word 0,0

player_hitbox: .word 0,0,0,0
pkmnsSelect: .word 14,
1, 60,16,267,47
1, 60,48,155,55
1, 204,48,267,55
1, 61,64,74,95
1, 188,83,235,107
1, 60,137,139,167
1, 188,137,267,167
1, 60,196,75,223
1, 252,196,268,223
2, 150,211,176,227
exit_pk_select: .word 0,0, 0,200
1, 0,0,319,15
1, 0,14,58,224
1, 268,14,319,225
1, 0,224,319,239

stadium_hb: .word 21,
1, 72,0,247,24
1, 56,0,71,239
1, 248,0,263,239
1, 104,32,135,65
1, 136,32,215,52
1, 232,48,247,69
1, 72,48,87,69
1, 200,53,215,82
1, 104,81,119,111
1, 104,112,135,149
1, 184,112,215,149
1, 200,99,215,111
1, 72,160,87,181
1, 232,144,247,165
1, 87,199,103,230
1, 104,192,135,229
1, 184,192,215,229
1, 216,199,232,230
1, 136,112,150,132
1, 168,112,183,132
2, 147,228,172,239, 
exit_stadium: .word 0,0, 180,50

open1_hb: .word 13,
1, 0,0,10,198
3, 11,0,75,84
2, 0,0,319,10, 
open1_up: .word 0,0, 0,200
3, 124,0,267,20
3, 76,69,220,84
3, 268,0,300,198
4, 15,89,215,146
3, 11,148,60,198
1, 0,199,138,239
3, 188,197,219,239
1, 301,0,319,198
1, 220,199,319,239
2, 0,229,319,239, 
open1_down: .word 0,0, 0,185

open2_hb: .word 22,
1, 0,0,10,239
1, 11,0,139,33
1, 140,0,162,52
1, 163,0,211,44
1, 212,0,235,52
1, 236,0,299,34
1, 300,0,319,239
2, 163,45,211,60, 
open2_up: .word 0,0, 155,200
1, 132,34,139,65
1, 236,35,243,65
3, 11,195,75,239
3, 124,197,219,239
3, 220,213,299,239
2, 0,231,319,239,
open2_down: .word 0,0, 0,20
1, 11,77,59,84
1, 76,77,139,84
1, 219,77,251,84
1, 268,77,299,84
1, 11,141,123,148
1, 140,141,235,149
1, 236,117,299,180
1, 284,196,299,212

.text

la s0,player_position	#
li s1,0xFF100000	# Initialize 
la s2,imagem		# Constants
## s3 time
la s4,pkmnSelect
la s5,pkmnsSelect

##### conecting maps

la t0,exit_stadium
la t1,open2
la t2,open2_hb
sw t1,0(t0)
sw t2,4(t0)

la t0,exit_pk_select
la t1,open1
la t2,open1_hb
sw t1,0(t0)
sw t2,4(t0)

la t0,open1_up
la t1,open2
la t2,open2_hb
sw t1,0(t0)
sw t2,4(t0)

la t0,open1_down
la t1,pkmnSelect
la t2,pkmnsSelect
sw t1,0(t0)
sw t2,4(t0)

la t0,open2_up
la t1,stadium
la t2,stadium_hb
sw t1,0(t0)
sw t2,4(t0)

la t0,open2_down
la t1,open1
la t2,open1_hb
sw t1,0(t0)
sw t2,4(t0)

######

la t0,walkFront0
#la t0,walkBack0
la a0,imagem
sw t0,0(a0)
sw t0,8(a0)
li t0,0	   		# 0 para direita 1 para esquerda
sw t0,4(a0)


#### main loop #####


LOOP:	
	li a7,30	# saves global time
	ecall
	mv s3,a0


	####################  load map
	li a5,0			
	#la a0, pkmnSelect
	mv a0,s4
	image(a0, 0, 0)	
	
	
	#li a0, 0x00 # color
	#li a1, 0   # x
	#li a2, 0   # y
	#li a3, 100
	#li a4, 16
	#li a5, 8
	#jal bar
	
	################ update last player position
	
	#la t0,player_position
	lw t1,0(s0)
	lw t2,4(s0)
	sw t1,8(s0)
	sw t2,12(s0)
	
	####################  input player
	la a0,imagem
	jal Input_Player
	
	####### change hitboxes
	
	la t0, player_position
	lw t1,0(t0)
	lw t2,4(t0)
	
	la t0, imagem
	lw t0,0(t0)
	lw t3,0(t0)
	lw t4,4(t0)
	
	#li t3,14
	#li t4,18
	
	add t3,t3,t1
	add t4,t4,t2
	addi t3,t3,-1
	addi t4,t4,-1
	
	#addi t1,t1,14
	addi t2,t2,12
	
	la t0, player_hitbox
	sw t1,0(t0)
	sw t2,4(t0)
	sw t3,8(t0)
	sw t4,12(t0)
	
	
	la a0,player_hitbox
	#la a1,pkmnsSelect
	mv a1,s5
	mv a2,s0
	addi a3,s0,-8
	jal player_hitbox_interaction
	
	###################### print player
	
	la a0,imagem
	la a2,player_position
	lw a1,0(a2)
	lw a2,4(a2)
	
	la t0, animation_state
	lw a3, 0(t0)   # sould loop
	jal ra,Animation_Iterator
	jal Frame_changer
	
	#######################
	
j LOOP


li a7,10
ecall

#********************* por favor retirar depois do debug
bar:
        mul     a3,a3,a4
        li      a6,100
        div     a3,a3,a6
        add     a6,a3,a1
        bge     a1,a6,.L1
        add     a5,a2,a5
        bge     a2,a5,.L1
        slli    a4,a5,2
        add     a4,a4,a5
        slli    a5,a2,2
        mv      a7,s1
        slli    a4,a4,6
        add     a2,a5,a2
        add     a4,a4,a7
        slli    a2,a2,6
        add     a4,a4,a1
        andi    a3,a0,0xff
        add     a2,a2,a7
.L6:
        add     a5,a2,a1
.L4:
        sb      a3,0(a5)
        addi    a5,a5,320
        bne     a4,a5,.L4
        addi    a1,a1,1
        addi    a4,a4,1
        bne     a1,a6,.L6
.L1:
        ret


##################### IMAGE

Image: 
	# a5 = orientation (0  right, 1 left)
	lw t0,0(a0)
	add a3,a1,t0
	
	lw t1,4(a0)
	add a4,a2,t1
	
	addi a0,a0,8
	
	li t5, 1
	beq a5,zero,Right_Orientation
	mv t2,a1
	mv a1,a3
	mv a3,t2
	addi t5,t5,-2
Right_Orientation:
	
	mv t0,a1
	mv t1,a2
	li t2,320
	mul t2,t1,t2
	add t2,t2,t0
	add t2,s1,t2

	li t4,-57
Loop_I1:
	beq t1,a4, END_I
INNER_Loop_I1:	
	beq t0,a3, END_Inner_I
	lb t3,0(a0)
	beq t3,t4,Transparent
	sb t3,0(t2)
Transparent:

	add t2,t2,t5
	add t0,t0,t5
	addi a0,a0,1
	j INNER_Loop_I1
END_Inner_I:

	add t2,t2,a1
	sub t2,t2,a3
	addi t2,t2,320
	mv t0,a1
	addi t1,t1,1
	#addi a0,a0,1
	j Loop_I1
END_I:
	ret

########################## Animation Iterator

Animation_Iterator:
	# a0 = pointer to the animation section (pointer to the images), a1 = x, a2 = y, a3 = should_loop
	## toda animacao tem que terminar com x, 0
	
	addi sp, sp, -4
	
	sw a3,0(sp)
	
	
	lw t0,0(a0) # endereco das imagens
	
	lw t1,0(t0) # maximo de largura
	lw t2,4(t0) # maximo de altura
	bne t1,t2,Dont_Restart_Loop
	bne t1,zero,Dont_Restart_Loop
	lw t0,8(a0) ## endereco atual igual ao inicial
	sw t0,0(a0) ##

Dont_Restart_Loop:

	addi sp,sp,-8
	sw a0,4(sp)
	sw ra,0(sp)

	lw a5,4(a0) # pega orientacao de a0
	mv a0,t0
	jal ra,Image # chama Image
	lw ra,0(sp)
	lw a0,4(sp)
	
	addi sp,sp,8
	
	
	lw a3,0(sp)
	addi sp, sp, 4
	
	bne a3, zero, Continue_AniIter
	ret
Continue_AniIter: 
	
	lw t0,0(a0)  #
	lw t1,4(t0)  #
	lw t2,0(t0)  # 
	mul t1,t1,t2
	li t3,4
	rem t2,t1,t3
	beq t2,zero,Correct_Val
	sub t2,t3,t2
Correct_Val:
		
	add t1,t1,t0
	addi t1,t1,8
	add t1,t1,t2
	sw t1,0(a0) # salva novo endereco
	
	ret
	
################## Frame changer

Frame_changer:
	li t0,0x00100000
	xor s1,s1,t0
	li t0,0xFF200604
	lw t1,0(t0)
	xori t1,t1,0x01
	sw t1,0(t0)
	ret

##########################  Input player


KEY:	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM   	   	# Se n�o h� tecla pressionada ent�o vai para FIM
  	lw a0,4(t1)  			# le o valor da tecla tecla
	sw a0,12(t1)  			# escreve a tecla pressionada no display
FIM:	ret	


Input_Player:
	# a0 = player animation
	
	########## ft0 = delta time
	mv a2,a0
	
	li a7,30
	ecall
	sub t0,a0,s3
	la t1, CONST_FLOAT
	fcvt.s.w ft0,t0
       	flw     ft1,0(t1)
       	fdiv.s  ft0,ft0,ft1

	mv a0,a2
	mv a1,a2
	##########
	
	addi sp,sp,-4
	sw ra,0(sp)
	jal KEY
	
	mv a3,s0
	
	li t0,97 # a
	bne a0,t0,Next_Input1
	la t2,walkSide0
	li a2,1
	#addi a3,a3,4
	li a4,-7 #*******
	
	#fcvt.s.w ft1,a4		#
	#fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	jal Move_Bat_Command
	
Next_Input1:
	li t0,100 # d
	bne a0,t0,Next_Input2
	la t2,walkSide0
	li a2,0
	#addi a3,a3,4
	li a4,7 #*******
	
	#fcvt.s.w ft1,a4		#
	#fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	jal Move_Bat_Command
	
Next_Input2:
	li t0,115 # s 
	bne a0,t0,Next_Input3
	la t2,walkFront0
	li a2,1
	addi a3,a3,4
	li a4,7 #*******
	
	#fcvt.s.w ft1,a4		#
	#fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	jal Move_Bat_Command
	
Next_Input3:
	li t0,119 # w
	la t2,walkBack0
	li a2,0
	addi a3,a3,4
	li a4,-7 #*******
	
	#fcvt.s.w ft1,a4		#
	#fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	bne a0,t0,Next_Input4
	jal Move_Bat_Command
Next_Input4:
	la t0, animation_state	# should loop = false
	sw zero,0(t0)		#
		
	j End_IP
Move_Bat_Command:

	la t3, animation_state	#
	li t1,1			# should loop = true
	sw t1,0(t3)
	lw t1,4(t3)		#
	sw t0,4(t3)
	sub t0,t0,t1
	
	jal Move_Bat

End_IP:
	lw ra,0(sp)
	addi sp,sp,4
	
	ret

##################### player movement

Move_Bat:
	
	fcvt.s.w ft1,a4		#
	fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	sw t2,8(a1)
	
	beq zero,t0,Same_Direction
	sw t2,0(a1)
	sw a2,4(a1) # change direction
	
	#sw a2,4(a1) # change direction
Same_Direction:

	#flw fa0,0(t0)
	#li a7,2
	#ecall
	
	#fmv.s fa0,ft0
	#li a7,102
	#ecall
	
	flw ft1,-8(a3)
	fadd.s ft1,ft1,ft0
	fsw ft1,-8(a3)
	#fmv.s fa0,ft1
	#li a7,2
	#ecall
	
	fcvt.w.s t0,ft1
	sw t0,0(a3)
	
	ret
	
#Move_Bat_Backward:
#	li t0,1
#	sw t0,4(a1)
#
#	la t0,player_position
#	lw t1,0(t0)
#	addi t1,t1,-8
#	sw t1,0(t0)
#	
#	ret
#
#Move_Bat_Foward:
#	sw zero,4(a1)
#	la t0,player_position
#	lw t1,0(t0)
#	addi t1,t1,8
#	sw t1,0(t0)
#	
#	ret

######################### hitbox interactions

new_position:
        lw      a5,4(a2)
        lw      a4,12(a2)
        sub     a6,a5,a4
        beq     a5,a4,PHI15
        flw     fa5,4(a3)
        bgt     a6,zero,PHI16
        lw      a4,4(a0)
        lw      a6,12(a1)
        sub     a4,a4,a6
        addi    a4,a4,-1
        sub     a5,a5,a4
        sw      a5,4(a2)
        lw      a5,4(a0)
        lw      a4,12(a1)
        sub     a5,a5,a4
        addi    a5,a5,-1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,4(a3)
PHI7:
        ret
PHI16:
        lw      a4,12(a0)
        lw      a6,4(a1)
        sub     a4,a4,a6
        addi    a4,a4,1
        sub     a5,a5,a4
        sw      a5,4(a2)
        lw      a5,12(a0)
        lw      a4,4(a1)
        sub     a5,a5,a4
        addi    a5,a5,1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,4(a3)
        ret
PHI15:
        lw      a4,0(a2)
        lw      a5,8(a2)
        sub     a5,a4,a5
        ble     a5,zero,PHI9
        lw      a5,8(a0)
        lw      a6,0(a1)
        flw     fa5,0(a3)
        sub     a5,a5,a6
        addi    a5,a5,1
        sub     a4,a4,a5
        sw      a4,0(a2)
        lw      a5,8(a0)
        lw      a4,0(a1)
        sub     a5,a5,a4
        addi    a5,a5,1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,0(a3)
        ret
PHI9:
        beq     a5,zero,PHI7
        lw      a5,0(a0)
        lw      a6,8(a1)
        flw     fa5,0(a3)
        sub     a5,a5,a6
        addi    a5,a5,-1
        sub     a4,a4,a5
        sw      a4,0(a2)
        lw      a5,0(a0)
        lw      a4,8(a1)
        sub     a5,a5,a4
        addi    a5,a5,-1
        fcvt.s.w        fa4,a5
        fsub.s  fa5,fa5,fa4
        fsw     fa5,0(a3)
        ret
        
player_hitbox_interaction:
        addi    sp,sp,-48
        sw      s3,28(sp)
        lw      s3,0(a1)
        sw      ra,44(sp)
        sw      s0,40(sp)
        sw      s1,36(sp)
        sw      s2,32(sp)
        sw      s4,24(sp)
        sw      s5,20(sp)
        sw      s6,16(sp)
        sw      s7,12(sp)
        ble     s3,zero,PH17
        mv      s1,a0
        mv      s5,a2
        mv      s6,a3
        addi    a5,a1,4
        li      s0,0
        li      s4,2
        li      s7,1
        j       PH24
PH34:
        lw      a0,4(a5)
        lw      a1,8(s1)
        bgt     a0,a1,PH19
        lw      a2,12(s1)
        lw      a3,8(a5)
        blt     a2,a3,PH19
        lw      a2,16(a5)
        lw      a3,4(s1)
        blt     a2,a3,PH19
        beq     a4,s4,PH33
        bne     a4,s7,PH21
        mv      a3,s6
        mv      a2,s5
        mv      a1,s2
        mv      a0,s1
        call    new_position
PH21:
        addi    s0,s0,1
        addi    a5,s2,16
        beq     s3,s0,PH17
PH24:
        lw      a0,0(s1)
        lw      a1,12(a5)
        lw      a4,0(a5)
        addi    s2,a5,4
        ble     a0,a1,PH34
PH19:
        bne     a4,s4,PH21
        addi    s2,a5,20
        addi    s0,s0,1
        addi    a5,s2,16
        bne     s3,s0,PH24
PH17:
        lw      ra,44(sp)
        lw      s0,40(sp)
        lw      s1,36(sp)
        lw      s2,32(sp)
        lw      s3,28(sp)
        lw      s4,24(sp)
        lw      s5,20(sp)
        lw      s6,16(sp)
        lw      s7,12(sp)
        addi    sp,sp,48
        jr      ra
PH33:
        lw      a2,32(a5)
        lw      a3,4(s5)
        flw     fa5,4(s6)
        lw      a4,28(a5)
        sub     a3,a2,a3
        fcvt.s.w        fa4,a3
        lw      a1,24(a5)
        lw      a3,20(a5)
        fadd.s  fa5,fa5,fa4
        sw      a2,4(s5)
        addi    s2,a5,20
        fsw     fa5,4(s6)
        beq     a4,zero,PH23
        lw      a5,0(s5)
        flw     fa5,0(s6)
        sw      a4,0(s5)
        sub     a4,a4,a5
        fcvt.s.w        fa4,a4
        fadd.s  fa5,fa5,fa4
        fsw     fa5,0(s6)
PH23:
        sw a3,24(sp)
        sw a1,20(sp)
        j       PH21


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

.include "../SYSTEMv21.s"
