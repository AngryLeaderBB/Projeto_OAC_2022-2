.macro print_regis(%regis)
	sw a0,-4(sp)
	mv a0,%regis
	li a7,1
	ecall
	li a0,10
	li a7,11
	ecall
	lw a0,-4(sp)
.end_macro

.data
rectangle: .word 1,2,4,5
wall: .word 2,3,3,4

.text
	la a0,rectangle
	la a1,wall
	jal Does_It_Collide
	li a7,1
	ecall
	li a7,10
	ecall

Does_It_Collide:
	# a0 = pointer of rect 1, a1 = pointer of rect 2
	lw t0,0(a0)
	lw t1,8(a1)
	
	slt t2,t0,t1
	
	lw t0,8(a0)
	lw t1,0(a1)
	
	slt t3,t1,t0
	and t2,t2,t3
	
	lw t0,4(a0)
	lw t1,12(a1)
	slt t3,t0,t1
	
	and t2,t2,t3
	
	lw t0,12(a0)
	lw t1,4(a1)
	slt t3,t1,t0
	
	and t2,t2,t3
	
	mv a0,t2
	
		
	ret

Fix_colission:
	
