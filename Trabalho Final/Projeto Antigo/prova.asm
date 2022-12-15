.text


li a0,31
li a1,17

jal ra,MENE
li a7,10
ecall



MENE:

L3:beq a0, a1, L1
bge a0,a1, L2
sub a1,a1,a0
jal zero,L3
L2:sub a0,a0,a1
jal zero,L3
L1: jalr zero,ra,0

