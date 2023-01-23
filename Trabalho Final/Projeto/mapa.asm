.include "../MACROSv21.s"
.macro print_dialog(%address, %x, %y, %written, %letters, %lines, %color)

	mv a0, %address,
	mv a1, %x,
	mv a2, %y
	mv a3, %written
	li a4, %letters
	li a5, %lines
	li a6, %color
	call PrintDialog

.end_macro

.macro image(%imageAddressRegis , %xLower , %yLower)
	#address is the address of the bitmap display

	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	
	call Image

.end_macro

.macro iterate_animation(%imageAddressRegis , %xLower , %yLower, %should_loop)
	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	mv a3,%should_loop
	
	call Animation_Iterator
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
.include "stages.data"
.include "scissors.data"
.include "tree.data"
.include "battle/battleText.data"

CONST_FLOAT: .float 100

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
exit_pk_select: .word 0,0, 0,200,1
1, 0,0,319,15
1, 0,14,58,224
1, 268,14,319,225
1, 0,224,319,239

stadium_hb: .word 25,
1, 104,64,120,80
1, 200,80,216,96
6, 88,64,136,80,0
6, 184,80,232,96,1
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
exit_stadium: .word 0,0, 180,50,2

open1_hb: .word 13,
1, 0,0,10,198
3, 11,0,75,84
2, 0,0,319,20, 
open1_up: .word 0,0, 0,200,2
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
open1_down: .word 0,0, 0,185,0

open2_hb: .word 23,
1, 0,0,10,239
1, 11,0,139,33
1, 140,0,162,52
1, 163,0,211,44
1, 212,0,235,52
1, 236,0,299,34
1, 300,0,319,239
2, 163,45,211,60, 
open2_up: .word 0,0, 155,200,3
1, 132,34,139,65
1, 236,35,243,65
3, 11,195,75,239
3, 124,197,219,239
3, 220,213,299,239
2, 0,231,319,239,
open2_down: .word 0,0, 0,20,1
1, 11,77,59,84
1, 76,77,139,84
1, 219,77,251,84
1, 268,77,299,84
1, 11,141,123,148
1, 140,141,235,149
1, 236,117,299,180
1, 284,196,299,212
5, 106,48,120,62

key: .byte 0
current_map: .word 0
has_scissors: .byte 0,1
has_trees: .byte 1,1

current_dialog: .word 1,0 # bool, dialog address

dialogo_inicial: .word 126
.string "Voce magicamente brota numa sala suspeita\n\n\n\n-Voce\n Oh nao eu vou perder a aula de OAC, eh melhor eu descobrir como sair daqui"

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


#######

la t0,dialogo_inicial
la t1,current_dialog
sw t0,4(t1)

#### main loop #####


LOOP:	

	
#################### dialog
	
	la t0,current_dialog
	lw t1,0(t0)
	beq t1,zero,Dont_Dialog
		sw zero,0(t0)
		lw a0,4(t0)
		call Dialog_stop
	
Dont_Dialog:
####################

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
	#call bar
	
	################ update last player position
	
	#la t0,player_position
	lw t1,0(s0)
	lw t2,4(s0)
	sw t1,8(s0)
	sw t2,12(s0)
	
	####################  input player
	la a0,imagem
	call Input_Player
	
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
	call player_hitbox_interaction
	
	###################### print player
	
	la a0,imagem
	la a2,player_position
	lw a1,0(a2)
	lw a2,4(a2)
	
	la t0, animation_state
	lw a3, 0(t0)   # sould loop
	call Animation_Iterator # it moves the player
	
	
	####################### print map objects
	
	
	la t0,has_scissors
	lb t1,0(t0)
	beq t1,zero,no_scissors
	la a0,scissors
	li a5,0
	image(a0, 0, 0)	
no_scissors:

		
	la t0,current_map
	lb t1,0(t0)
	li t2,2
	bne t1,t2,no_collectable_scissors
	la t0,has_scissors
	lb t1,1(t0)
	beq t1,zero,no_collectable_scissors
	li a5,0
	la a0,scissors
	image(a0, 106, 48)	
no_collectable_scissors:

	la t0,current_map
	lb t1,0(t0)
	li t2,3
	bne t1,t2,no_trees
	
		la t0,has_trees
		lb t1,0(t0)
		beq t1,zero,not_first_tree
		
		la a0,tree
		li a5,0
		image(a0, 104, 64)
	
not_first_tree:
	la t0,has_trees
	lb t1,1(t0)
	beq t1,zero,no_trees
		la a0,tree
		li a5,0
		image(a0, 200, 80)
		
no_trees:

################# frame changer
	call Frame_changer
	
j LOOP


li a7,10
ecall

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
	#addi a0,a0,2
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
	call Image # chama Image
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
  	la t1,key
  	sb a0,0(t1)
	#sw a0,12(t1)  			# escreve a tecla pressionada no display
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
	call KEY
	
	mv a3,s0
	
	li t0,97 # a
	bne a0,t0,Next_Input1
	la t2,walkSide0
	li a2,1
	#addi a3,a3,4
	li a4,-70 #*******
	
	#fcvt.s.w ft1,a4		#
	#fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	call Move_Bat_Command
	
Next_Input1:
	li t0,100 # d
	bne a0,t0,Next_Input2
	la t2,walkSide0
	li a2,0
	#addi a3,a3,4
	li a4,70 #*******
	
	#fcvt.s.w ft1,a4		#
	#fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	call Move_Bat_Command
	
Next_Input2:
	li t0,115 # s 
	bne a0,t0,Next_Input3
	la t2,walkFront0
	li a2,1
	addi a3,a3,4
	li a4,70 #*******
	
	#fcvt.s.w ft1,a4		#
	#fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	call Move_Bat_Command
	
Next_Input3:
	li t0,119 # w
	la t2,walkBack0
	li a2,0
	addi a3,a3,4
	li a4,-70 #*******
	
	#fcvt.s.w ft1,a4		#
	#fmul.s ft0,ft0,ft1	# a4 = a4*delta-time
	#fcvt.w.s a4,ft0		#
	
	bne a0,t0,Next_Input4
	call Move_Bat_Command
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
	
	call Move_Bat

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
        addi    sp,sp,-64
        sw      s3,44(sp)
        lw      s3,0(a1)
        sw      ra,60(sp)
        sw      s0,56(sp)
        sw      s1,52(sp)
        sw      s2,48(sp)
        sw      s4,40(sp)
        sw      s5,36(sp)
        sw      s6,32(sp)
        sw      s7,28(sp)
        sw      s8,24(sp)
        sw      s9,20(sp)
        sw      s10,16(sp)
        sw      s11,12(sp)
        ble     s3,zero,PH37
        mv      s2,a0
        mv      s6,a2
        mv      s7,a3
        li      s10,0
        addi    a5,a1,4
        li      s1,0
        li      s4,2
        li      s5,6
        li      s8,5
        li      s9,1
        li      s11,10
PH59:
        lw      a6,0(s2)
        lw      a1,12(a5)
        lw      a4,0(a5)
        bgt     a6,a1,PH70
        lw      a6,4(a5)
        lw      a1,8(s2)
        bgt     a6,a1,PH70
        lw      a6,12(s2)
        lw      a1,8(a5)
        blt     a6,a1,PH70
        lw      a2,16(a5)
        lw      a3,4(s2)
        blt     a2,a3,PH70
        beq     a4,s4,PH73
        bne     a4,s5,PH54
        addi    s0,a5,8
        li      a4,0
        la a0,key
        lb a0,0(a0)
        mv a4,a0
        la t0,has_scissors
        lb s10,0(t0)
        beq s10,zero,PH41
        beq     a4,s11,PH74
PH41:
        addi    s1,s1,1
        addi    a5,s0,16
        bne     s3,s1,PH59
PH37:
        lw      ra,60(sp)
        lw      s0,56(sp)
        lw      s1,52(sp)
        lw      s2,48(sp)
        lw      s3,44(sp)
        lw      s4,40(sp)
        lw      s5,36(sp)
        lw      s6,32(sp)
        lw      s7,28(sp)
        lw      s8,24(sp)
        lw      s9,20(sp)
        lw      s10,16(sp)
        lw      s11,12(sp)
        addi    sp,sp,64
        jr      ra
PH70:
        addi    s0,a5,24
        beq     a4,s4,PH41
        addi    s0,a5,4
        bne     a4,s5,PH41
        addi    s0,a5,8
        addi    s1,s1,1
        addi    a5,s0,16
        bne     s3,s1,PH59
        j       PH37
PH54:
        addi    s0,a5,4
        beq     a4,s8,PH75
        bgt     a4,s8,PH41
        bne     a4,s9,PH41
        mv      a3,s7
        mv      a2,s6
        mv      a1,s0
        mv      a0,s2
        call    new_position
        addi    s1,s1,1
        addi    a5,s0,16
        bne     s3,s1,PH59
        j       PH37
PH73:
        lw      a2,32(a5)
        lw      a3,4(s6)
        flw     fa5,4(s7)
        lw      a4,28(a5)
        sub     a3,a2,a3
        fcvt.s.w        fa4,a3
        lw      a1,24(a5)
        lw      a3,20(a5)
        fadd.s  fa5,fa5,fa4
        lw      a0,36(a5)
        sw      a2,4(s6)
        addi    s0,a5,24
        fsw     fa5,4(s7)
        beq     a4,zero,PH53
        lw      a5,0(s6)
        flw     fa5,0(s7)
        sw      a4,0(s6)
        sub     a4,a4,a5
        fcvt.s.w        fa4,a4
        fadd.s  fa5,fa5,fa4
        fsw     fa5,0(s7)
PH53:
        la t0,current_map
        sw a0, 0(t0)
        sw a3,40(sp)
        sw a1,36(sp)
        addi    s1,s1,1
        addi    a5,s0,16
        bne     s3,s1,PH59
        j       PH37
PH75:
        la t0,has_scissors
        sb zero,1(t0)
        li t1,1
        sb t1,0(t0)
        addi    s1,s1,1
        addi    a5,s0,16
        bne     s3,s1,PH59
        j       PH37
PH74:
        lw      a5,20(a5)
        li      a4,0
        la t0,has_trees
        add t0,t0,a5
        sb zero,0(t0)
        la a4, stadium_hb

        slli t0,a5,2
        add t0,t0,a5
        slli t0,t0,2
        addi a4,a4,4
        add a4,a4,t0
        sw zero,0(a4)
        addi    s1,s1,1
        addi    a5,s0,16
        bne     s3,s1,PH59
        j       PH37


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

########################### dialog

Dialog_stop:
# a0 = dialog address
addi sp,sp,-12
sw ra,0(sp)
sw zero,4(sp)
sw a0,8(sp)

Loop_DS:

la a0, battleText	# Load map
li a5,0
image(a0, 0, 168)

#la t0, current_min_text
lw t3,4(sp)

lw t0,8(sp)
li t1, 15
li t2, 182
print_dialog(t0, t1, t2, t3, 35, 5, 0x51FF)


mv t2,a0

call KEY

li t1, 10
bne a0,t1, End_If_DS
	#la t0, current_min_text
	beq t2,zero,end_Loop_DS
	sw t2,4(sp)


End_If_DS:

call Frame_changer

j Loop_DS
end_Loop_DS:

lw ra,0(sp)
addi sp,sp,12

ret

PrintDialog:
	# a0 = address ( length + string)
	# a1 = x, a2 = y
	# a3 = num already read letters
	# a4 = max letters per line
	# a5 = max lines per textBox
	# a6 = color
	
	lw t0,0(a0)  # t0 = length
	addi a0,a0,4 # addrress of string
	mv t1,a4     # max letters per line
	mv t2,a5     # max lines per textBox
	
	li t3,0	     # index of the letter 
	li t4,0	     # index of the line
	mv t5,a3     # num of letters written
	
	mv t6, a1
	mv a5, a2

	add a0,a0,t5
	
	li a7,111    # Print char
	mv a3, a6   # Color
	
	srai a4,s1,20
	andi a4,a4,1
	#ori a4,s1,-2	 # Frame
	#neg a4,a4
Loop_PD:	
	beq t2,t4,End_PD
Inner_Loop_PB:	
	beq t1,t3,End_Inner_PD
	beq t0,t5,End_PD
	
	slli a1,t3,3
	add a1,a1,t6   #  x 
	slli a2,t4,3
	add a2,a2,a5   # y
	
	addi sp,sp,-8
	sw a0,0(sp)
	sw s0,4(sp)

	lb a0,0(a0)
	li s0,10
	bne a0,s0,not_new_line
	
	mv t3,t1
	addi t3,t3,-1
		
not_new_line:	ecall	
	
	lw a0,0(sp)
	lw s0,4(sp)
	addi sp,sp,8
	
	addi t3,t3,1
	addi t5,t5,1
	addi a0,a0,1
	j Inner_Loop_PB
End_Inner_PD:

	li t3,0
	addi t4,t4,1
	j Loop_PD
End_PD:	

	lb t2,-1(a0)
	addi t2,t2,-10
	
	beq t2,zero,End_Next_Symbol
		
	slt t1,t5,t0
	beq t1,zero,End_Next_Symbol
	
	addi a1, a1, 8

	li a0,73
	li a3,0xC7FF
	
	#srai a4,s1,20
	#andi a4,a4,1
	#li a4,0           #

	li a7,111
	ecall

	li a0,62
	addi a1,a1,2
	li a3,0xC7FF
	#li a4,0        #
	ecall
End_Next_Symbol:
	beq t5,t0,If_PD
	mv a0, t5
	ret
If_PD:	li a0,0
	ret
	
.include "../SYSTEMv21.s"
