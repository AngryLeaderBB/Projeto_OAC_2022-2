# .include "../MACROSv21.s"
.macro image(%imageAddressRegis , %xLower , %yLower)
	#address is the address of the bitmap display

	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	
	jal ra,Image

.end_macro

.macro iterate_animation(%imageAddressRegis , %xLower , %yLower)
	mv a0,%imageAddressRegis
	li a1,%xLower
	li a2,%yLower
	
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
imagem: .word 0,0,0
player_position: .word 160, 120

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
	la a0, mapaTeste	# Load map
	image(a0, 0, 0)		#
	
	la a0,imagem
	jal Input_Player

	la a0,imagem
	la a2,player_position
	lw a1,0(a2)
	lw a2,4(a2)
	jal ra,Animation_Iterator
	jal Frame_changer
	
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
	#addi a0,a0,1
	j Loop_I1
END_I:
	ret

########################## Animation Iterator

Animation_Iterator:
	# a0 = pointer to the animation section (pointer to the images), a1 = x, a2 = y
	lw t0,0(a0) # endereco das imagens
	
	lw t1,0(t0)
	lw t2,4(t0)
	bne t1,t2,Dont_Restart_Loop
	bne t1,zero,Dont_Restart_Loop
	lw t0,8(a0)
	sw t0,0(a0)

Dont_Restart_Loop:

	addi sp,sp,-8
	sw a0,4(sp)
	sw ra,0(sp)

	lw a5,4(a0)
	mv a0,t0
	jal ra,Image
	lw ra,0(sp)
	lw a0,4(sp)
	
	addi sp,sp,8
	
	lw t0,0(a0)
	lw t1,4(t0)
	lw t2,0(t0)
	mul t1,t1,t2
	li t3,4
	rem t2,t1,t3
	beq t2,zero,Correct_Val
	sub t2,t3,t2
Correct_Val:
		
	add t1,t1,t0
	addi t1,t1,8
	add t1,t1,t2
	sw t1,0(a0)
	
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
	mv a1,a0 
	
	addi sp,sp,-4
	sw ra,0(sp)
	jal KEY
	
	mv a3,s0
	
	li t0,97 # a
	bne a0,t0,Next_Input1
	li a2,1
	#addi a3,a3,4
	li a4,-16
	jal Move_Bat_Command
	
Next_Input1:
	li t0,100 # d
	bne a0,t0,Next_Input2
	li a2,0
	#addi a3,a3,4
	li a4,16
	jal Move_Bat_Command
	
Next_Input2:
	li t0,115 # s 
	bne a0,t0,Next_Input3
	li a2,-1
	addi a3,a3,4
	li a4,16
	jal Move_Bat_Command
	
Next_Input3:
	li t0,119 # w
	li a2,-1
	addi a3,a3,4
	li a4,-16
	bne a0,t0,Next_Input4
	jal Move_Bat_Command
Next_Input4:	
	jal End_IP
Move_Bat_Command:	
	jal Move_Bat

End_IP:
	lw ra,0(sp)
	addi sp,sp,4
	
	ret

##################### player movement

Move_Bat:
	li t0,-1
	beq a2,t0,Same_Direction
	sw a2,4(a1)
Same_Direction:
	lw t0,0(a3)
	add t0,t0,a4
	sw t0,0(a3)

	jal End_IP

Move_Bat_Backward:
	li t0,1
	sw t0,4(a1)

	la t0,player_position
	lw t1,0(t0)
	addi t1,t1,-8
	sw t1,0(t0)
	
	j End_IP

Move_Bat_Foward:
	sw zero,4(a1)
	la t0,player_position
	lw t1,0(t0)
	addi t1,t1,8
	sw t1,0(t0)
	
	j End_IP

# .include "../SYSTEMv21.s"