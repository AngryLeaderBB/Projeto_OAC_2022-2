.include "MACROSv21.s"

.data

FREQ:	.string "Frequencia = "
CPI:	.string "CPI = "
TEXEC:  .string "Tempo Execucao = "

teste: .float 1.5

.text

loop:
	la a0,FREQ
	li a1,2
	la t0,teste
	flw fa0,0(t0)
	jal print_time

	la a0,CPI
	li a1,12
	la t0,teste
	flw fa0,0(t0)
	jal print_time
	
	la a0,TEXEC
	li a1,22
	la t0,teste
	flw fa0,0(t0)
	jal print_time

j loop

li a7,10
ecall

.include "SYSTEMv21.s"


print_time:
	# a0 = string address, a1 = y position, fa0 = float address
	
	mv a2,a1
	li a1,0
	li a3,0xff
	li a4,0
	li a7,104
	ecall 
	
	li a7,102
	ecall

	ret