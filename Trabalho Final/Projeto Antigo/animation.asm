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


.macro faster_rectangle(%color , %xLower , %yLower, %xUpper, %yUpper)
	#address is the address of the bitmap display

	mv a0,s1
	li a1,%color

	li a2,%xLower
	li a3,%yLower

	li a4,%xUpper
	li a5,%yUpper

	jal ra,FASTER_RECTANGLE

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
.include "idle.data"
.include "run.data"
.include "alu-hellfire_40x55.data"
.include "alu-atk_60x50.data"
.include "bomb-atk_55x88.data"
.include "bomb-idle_42x82.data"
# .include "minos_idle.data"
.include "walkFront.data"
.include "bat-fly_20x48.data"

imagem: .word 0,0,0

.text
	li s1,0xFF100000
	
	li s0,0xFF200604	
	sw zero,0(s0)
	
	la t0,walkFront0
	la a0,imagem
	sw t0,0(a0)
	sw t0,8(a0)
	li t0,1	   # 0 para direita 1 para esquerda
	sw t0,4(a0)
	
LOOP:	
	faster_rectangle(0 , 0 , 0, 320, 240)
	la a0,imagem
	#li s5,1
	iterate_animation(a0,160,120, s5)
	xori s5,s5,1
	jal Frame_changer
	j LOOP
End:
	li a7,1
	ecall
	li a7,10		
	ecall




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


Frame_changer:
	li t0,0x00100000
	xor s1,s1,t0
	li t0,0xFF200604
	lw t1,0(t0)
	xori t1,t1,0x01
	sw t1,0(t0)
	ret 
	

FASTER_RECTANGLE: 
	
	mv t0,a2
	mv t1,a3
	li t2,320
	mul t2,t1,t2
	add t2,t2,t0
	add t2,a0,t2

LOOP2:
	bge t1,a5, END2
INNER_LOOP2:	
	bge t0,a4, END_INNER2
	
	sw a1,0(t2)

	addi t2,t2,4
	addi t0,t0,4
	j INNER_LOOP2
END_INNER2:
	add t2,t2,a2
	sub t2,t2,a4
	addi t2,t2,320
	mv t0,a2
	addi t1,t1,1
	j LOOP2
END2:
	ret	


