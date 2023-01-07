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
.include "walkFront.data"
.include "pkmnSelect.data"
CONST_FLOAT: .float 10

imagem: .word 0,0,0
player_real_position: .float 160, 120
player_position: .word 160, 120
player_last_position: .word 0,0

animation_state: .word 0

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
1, 0,0,319,15
1, 0,14,58,224
1, 268,14,319,225
1, 0,224,319,239

.text

la s0,player_position	#
li s1,0xFF100000	# Initialize 
la s2,imagem		# Constants



la t0,walkFront0
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
	la a0, pkmnSelect
	image(a0, 0, 0)	
	
	
	#li a0, 0x00 # color
	#li a1, 0   # x
	#li a2, 0   # y
	#li a3, 100
	#li a4, 16
	#li a5, 8
	#jal bar
	
	################ update last player position
	
	la t0,player_position
	lw t1,0(t0)
	lw t2,4(t0)
	sw t1,8(t0)
	sw t2,12(t0)
	
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
	la a1,pkmnsSelect
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
	li a2,1
	#addi a3,a3,4
	li a4,-7 #*******
	
	fcvt.s.w ft1,a4		#
	fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	jal Move_Bat_Command
	
Next_Input1:
	li t0,100 # d
	bne a0,t0,Next_Input2
	li a2,0
	#addi a3,a3,4
	li a4,7 #*******
	
	fcvt.s.w ft1,a4		#
	fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	jal Move_Bat_Command
	
Next_Input2:
	li t0,115 # s 
	bne a0,t0,Next_Input3
	li a2,-1
	addi a3,a3,4
	li a4,7 #*******
	
	fcvt.s.w ft1,a4		#
	fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	jal Move_Bat_Command
	
Next_Input3:
	li t0,119 # w
	li a2,-1
	addi a3,a3,4
	li a4,-7 #*******
	
	fcvt.s.w ft1,a4		#
	fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	bne a0,t0,Next_Input4
	jal Move_Bat_Command
Next_Input4:
	la t0, animation_state	# should loop = false
	sw zero,0(t0)		#
		
	j End_IP
Move_Bat_Command:

	la t0, animation_state	#
	li t1,1			# should loop = true
	sw t1,0(t0)		#
		
	jal Move_Bat

End_IP:
	lw ra,0(sp)
	addi sp,sp,4
	
	ret

##################### player movement

Move_Bat:
	li t0,-1
	beq a2,t0,Same_Direction
	sw a2,4(a1) # change direction
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
        addi    sp,sp,-32
        sw      s3,12(sp)
        lw      s3,0(a1)
        sw      ra,28(sp)
        sw      s0,24(sp)
        sw      s1,20(sp)
        sw      s2,16(sp)
        sw      s4,8(sp)
        sw      s5,4(sp)
        sw      s6,0(sp)
        ble     s3,zero,PHI17
        mv      s2,a0
        mv      s5,a2
        mv      s6,a3
        addi    s0,a1,8
        li      s1,0
        li      s4,1
PHI20:
        lw      a5,8(s0)
        lw      a4,0(s2)
        addi    s1,s1,1
        bgt     a4,a5,PHI19
        lw      a4,0(s0)
        lw      a5,8(s2)
        bgt     a4,a5,PHI19
        lw      a5,4(s0)
        lw      a4,12(s2)
        blt     a4,a5,PHI19
        lw      a4,12(s0)
        lw      a5,4(s2)
        blt     a4,a5,PHI19
        lw      a5,-4(s0)
        beq     a5,s4,PHI23
PHI19:
        addi    s0,s0,20
        bne     s3,s1,PHI20
PHI17:
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
PHI23:
        mv      a1,s0
        mv      a3,s6
        mv      a2,s5
        mv      a0,s2
        call    new_position
        j       PHI19


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
