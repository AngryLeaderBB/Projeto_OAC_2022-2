.macro if_else(%comparationLabel, %ifLabel, %elseLabel)
	# if(comparation(a0)) return if_func(a0,a1,...) else return else_func(a0,a1,...)
	#%comparationAddress -> address of "comparation" function that takes a0 and returns a0 \in {0,1}
	#%ifAddress -> address of "if_func" function in case "if" is true
	#%elseAddress -> address of "else_func" function in case "if" is false
	## Attention if a0 is not used in "if_func" and "else_func" it may take 2 unecessary steps
	
	la t0,%comparationLabel
	la t1,%ifLabel
	la t2,%elseLabel
	jal ra,If_else
	
.end_macro

.macro while(%comparationLabel, %doLabel)
	# while(comparation(a0))  do do_func(a0,a1,...) end_do 
	#%comparationLabel -> label of "comparation" function that takes a0 and returns a0 \in {0,1}
	#%doLabel -> label of "do_func" function in case "while" still holds
	## Attention current t0,t1 can't be used as register for "do_func"
	la t0,%comparationLabel
	la t1,%doLabel
	jal ra,While
	
.end_macro

.data
par: .string " eh par"
impar: .string " eh impar"
.text 

##input##
li a7,5
ecall
mv t3,a0
li a7,5
ecall
##input##

addi a0,a0,1
mv a1,a0
## print ##
li a0,10
li a7,11
ecall
## print ##
mv a0,t3

if_else(comp1,if,else)
mv a0,t3
li a2,0
while(comp2,do)

## print ##
li a0,10
li a7,11
ecall
mv a0,a2
li a7,1
ecall
## print ##

li a7,10
ecall

comp1:
	li t0,2
	rem a0,a0,t0
	li t0,-1
	mul a0,a0,t0
	addi a0,a0,1
	ret

if:
	li a7,1
	ecall
	la a0,par
	li a7,4
	ecall
	ret

else:
	li a7,1
	ecall
	la a0,impar
	li a7,4
	ecall
	ret
	
comp2:
	slt a0,a0,a1
	ret

do:
	add a2,a2,a0
	addi a0,a0,1
	ret
	

############################
If_else: 
	addi sp,sp,-16
	sw a0,0(sp)
	sw t1,4(sp)
	sw t2,8(sp)
	sw ra,12(sp)
	jalr ra,t0,0
	beq a0,zero,Else
	
	lw a0,0(sp)
	lw t1,4(sp)
	jalr ra,t1,0
	j If_else_end
Else:
	lw a0,0(sp)
	lw t2,8(sp)
	jalr ra,t2,0
If_else_end:
	lw ra,12(sp)
	addi sp,sp,16
	ret
	
While:
	addi sp,sp,-16
	sw t0,4(sp)
	sw t1,8(sp)
	sw ra,12(sp)
While_loop:
	sw a0,0(sp)
	lw t0,4(sp)
	jalr ra,t0,0
	beq a0,zero,While_end
	lw a0,0(sp)
	lw t1,8(sp)
	jalr ra,t1,0
	j While_loop		
While_end:
	lw a0,0(sp)
	lw ra,12(sp)
	addi sp,sp,16
	ret