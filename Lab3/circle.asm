.include "MACROSv21.s"
.macro circle(%color, %x, %y, %radius)

	li a0, %color
	li a1, %x
	li a2, %y
	li a3, %radius
	jal circle

.end_macro


.macro rectangle(%color, %x_lower, %y_lower, %x_upper, %y_upper)

	li a0, %color
	li a1, %x_lower
	li a2, %y_lower
	li a3, %x_upper
	li a4, %y_upper
	jal rectangle

.end_macro

.macro colored_string(%x, %y)

li a1, %x
li a2, %y
li a7, 104
ecall

.end_macro

.data

FREQ:	.string "Frequencia = "
CICL:	.string "Ciclos = "
INST:	.string "Instrucoes = "
TEMED:  .string "Tempo Medido = "
CPI:	.string "CPI = "
TECALC: .string "Tempo Calculado = "

freq: .float 4.1666666

draw: .string "Empate"
player: .string "Jogador"
won: .string "Ganhou!"

cor: .string "cor"
dificuldade: .string "dificuldade"
facil: .string "facil"
medio: .string "medio"
dificil: .string "dificil"

ai_position: .word 0, 0
difficult: .word 0
color: .word 0
is_color: .word 0
menu: .word 0x1300,0,0,0x1300,0
turn: .word 0
x: .word 0
y: .word 0
current_color: .word 1
winner: .word 0
board: .word 
0, 0, 0, 0, 0, 0, 0, 0
0, 0, 0, 0, 0, 0, 0, 0
0, 0, 0, 0, 0, 0, 0, 0
0, 0, 0, 0, 0, 0, 0, 0
0, 0, 0, 0, 0, 0, 0, 0
0, 0, 0, 0, 0, 0, 0, 0
0, 0, 0, 0, 0, 0, 0, 0
0, 0, 0, 0, 0, 0, 0, 0

.text

############### menu #################
li a3, 0xFF		# cor branca
li a4, 0		# frame 0

la a0, dificuldade	#
li a1, 117		# imprime a string "dificuldade"
li a2, 89		# no menu
li a7, 104		#
ecall			#

la a0, cor		#
li a1, 149		# imprime a string "cor"
li a2, 121		# no menu
li a7, 104		#
ecall			#

menu_loop:
jal key			# registra entrada do teclado
li t0, 10		# t0 = Enter
beq a0,t0, end_menu	# Enter comeca jogo

la a1, is_color		#
la a2, menu		#
addi a3, a2, 12		#  itera menu
la a4, difficult	#
			#
jal iterate_menu	#

la t0, is_color		#
lw t0,0(t0)		# caractere * no menu 
			#
li a0, 42		#
li a3, 0		#
li a4, 0		#
li a7,111		#
			#
bne t0,zero,if_select	#
	li a1, 129	#
	li a2, 137	#
	ecall 		#
			#
	li a1, 69	#
	li a2, 105	#
			#
j end_select		#
if_select:		#
	li a1, 69	#
	li a2, 105	#
	ecall		#
			#
	li a1, 129	#
	li a2, 137	#
			#
end_select:		#
			#
	li a3, 0xff	#
	ecall		#

li a3, 0xFF		#
li a4, 0		#
			#
la t0, menu		# imprime a string "facil" 
			# com borda, se necessario
la a0, facil		#
li a3, 0x33		# 
lw t1,0(t0)		# 
add a3, a3, t1		#
colored_string(85, 105)	#


la a0, medio		#
li a3, 0x77		# imprime a string "medio" 
lw t1,4(t0)		# com borda, se necessario
add a3, a3, t1		#
colored_string(133, 105) #


la a0, dificil		#
li a3, 0x6		# imprime a string "dificil"
lw t1,8(t0)		# com borda, se necessario
add a3, a3, t1		#
colored_string(181, 105) #


addi t0,t0,12	#
		# imprime inteiros 1 e 2
li a0, 1	# no menu
li a1, 145	#
li a2, 137	#
li a3, 7	#
lw t1,0(t0)	#
add a3, a3, t1	#
li a7, 101	#
ecall		#
		#
li a0, 2	#
li a1, 172	#
li a2, 137	#
li a3, 0xc0	#
lw t1,4(t0)	#
add a3, a3, t1	#
li a7, 101	#
ecall		#

j menu_loop	# loop do menu

end_menu:

###################### game

la t0, difficult		#
lw t0,0(t0)			# imprime dificuldade no canto
				# superior do jogo
bne t0,zero,top_not_easy	#
la a0, facil			#
li a3, 0x33			#
colored_string(138, 28)		#
j end_top_string		#
top_not_easy:			#
				#
li t1, 1			#
				#
bne t0, t1,top_not_normal	#
la a0, medio			#
li a3, 0x77			#
colored_string(138, 28)		#
j end_top_string		#
top_not_normal:			#
				#
la a0, dificil			#
li a3, 0x6			#
colored_string(130, 28)		#
end_top_string:			#

li s1, 0  # turno

rectangle(89, 37, 38, 281, 200)		#
					# imprime tabuleiro
circle(89, 17, 200, 21)			#
circle(89, 257, 200, 21)		#
rectangle(0, 37, 201, 60, 240)		#
rectangle(0, 258, 201, 280, 240)	#



li t0, 0	#
li t1, 8	# imprime no jogo numeros de
		# 1 a 8, indicando qual posicao
li a0, 49	# eh relativa a cada jogada
li a1, 50	#
li a2, 207	#
li a3, 0x77	#
li a4, 0	#
li a7, 111	#
key_tip: beq t0, t1, end_key_tip #
ecall		#
addi a1, a1, 30	#
addi t0, t0, 1	#
addi a0, a0, 1	#
j key_tip	#
end_key_tip:	#


la a0, board		# imprime pesas no tabuleiro
jal print_board		#


main_loop:


beq s1,zero,if_turn_circle	#
circle(0xc0, 150, 7, 6)		#
j end_turn_circle		# circulo no canto superior do jogo
if_turn_circle:			#
circle(7, 150, 7, 6)		#
end_turn_circle:		#

la t0, color		#
lw t0,0(t0)		# checa se eh vez do player ou ia
beq s1, t0, get_key	#

######## AI #######################################

############ register time
addi sp,sp,-24
sw s0,0(sp)
sw s1,4(sp)
sw s2,8(sp)
sw s3,12(sp)
sw s4,16(sp)
sw s5,20(sp)

rdcycle s0
rdinstret s1
rdtime s2
############## 

la t0, difficult	# checa dificuldade
lw t0,0(t0)		#

bne t0,zero,not_easy	#
jal easy_mode		# facil
j end_ai_command	#
not_easy:		#

li t1, 1		#
			#
bne t0, t1,not_normal	#
la a0, board		# medio
la a1, color		#
jal normal_mode		#
j end_ai_command	#
not_normal:		#

la a0, board		#
la a1, color		# dificio
jal hard_mode		#

end_ai_command:		# fim da acao da ia


########### end register time

rdtime s5
rdinstret s4
rdcycle s3

addi sp,sp,-12
sw a0,0(sp)
sw a1,4(sp)
sw a2,8(sp)

sub s0,s3,s0
fcvt.s.w ft0,s0		# ciclos
sub s1,s4,s1
fcvt.s.w ft1,s1		# instru��es
sub s2,s5,s2
fcvt.s.w ft2,s2	 	# tempo


la a0,freq
flw fa0,0(a0)
la a0,FREQ
li a1,2
#fdiv.s fa0,ft0,ft2	# Frequencia
fmv.s ft3,fa0
jal print_float


la a0,CICL
li a1,12
mv a2,s0	# Ciclos
jal print_int

la a0,INST
li a1,22
mv a2,s1	# Instrucoes
jal print_int

la a0,TEMED
li a1,32
fmv.s fa0,ft2		# tempo exec exec em ms
jal print_float

la a0,CPI
li a1,42
fdiv.s fa0,ft0,ft1	#CPI
jal print_float


la a0,TECALC
li a1,52
fdiv.s fa0,ft0,ft3	# tempo medido em ms
jal print_float

lw a0,0(sp)
lw a1,4(sp)
lw a2,8(sp)
addi sp,sp,12

lw s0,0(sp)
lw s1,4(sp)
lw s2,8(sp)
lw s3,12(sp)
lw s4,16(sp)
lw s5,20(sp)
addi sp,sp,24


############

##################################################

j end_turn	# fim do turno da ia

get_key:
	jal key			#
	mv s0, a0		# input do jogador
        addi    a0,a0,-49	#
        li      t0,7		#
        bgtu    a0,t0,get_key	#


end_turn:    


la t0, y	# salva y
sw a0,0(t0)	#

mv a1, a0		#
la a0,board		#
la a2,current_color	# adiciona peca do tabuleiro
lw a2,0(a2)		#
			#
jal add_element		#

la t0, x	# salva x
sw a0,0(t0)	#

la a0,board	# jogo empatado?
jal game_draw	#
	
	la a1, winner
        beq     a0,zero,if_game_draw # if (game_draw(board)){
        sw      zero,0(a1)	      #    winner = 0;
        j end			      #	break;}
if_game_draw:

	la a0, board	#
			#
	la t0, x	#
	lw a1, 0(t0)	#  jogo ganho?
			#
	lw a2, 4(t0)	#
			#
	jal game_won	#
	
	la a1, current_color		#
	la a2, winner			# if (game_won(board, x, y)){
        beq     a0,zero,if_game_won	#    winner = current_color;
        lw      t0,0(a1)		#    break;}
        sw      t0,0(a2)		#
        j end				#
if_game_won:

	la t0, x		# salva x
	lw a0,0(t0)		#
	
	la a1, current_color	#
        li      t0,-1		#
        beq     a0,t0,next_color # ajusta valores para fim de jogo
        lw      t0,0(a1)	#
        srli    t1,t0,31	#
        add     t0,t0,t1	#
        andi    t0,t0,1		#
        sub     t0,t0,t1	#
        addi    t0,t0,1		#
        sw      t0,0(a1)	#
next_color:


la t0, x		#
lw t0,0(t0)		# se terminou o turno, muda de turno
li t1,-1		# e vai para o loop principal
beq t0,t1,main_loop	#
			#
xori s1,s1, 1		#
j main_loop		#

end:
###################### game over

li a0, 1750	#
li a7, 32	# sleep de a0 segundos
ecall		#

rectangle(0, 0, 0, 320, 240)	# limpar tela

la a0, winner	#
lw a0, 0 (a0)	# a0 = ganhador
li a4, 0	#

mv a3,a0			#
        li      t0,1		# imprime mensagem de quem
        mv      t1,a3		# ganhou o jogo/empate
        beq     a3,t0,colorL1	#
        li      t0,2		#
        li      a3,0x00c0	#
        beq     t1,t0,colorL2	#
        li      a3,0x00ff	#
        li a1, 137		#
	li a2, 121		#
	la a0, draw		#
	li a7, 104		#
	ecall			#
        j endColor		#
colorL1:			#
        li      a3,0x0007	#
colorL2:			#
	li a1, 157		#
	li a2, 121		#
	li a7, 101		#
	ecall			#
				#
	la a0, player		#
	li a1, 133		#
	li a2, 113		#
	li a7, 104		#
	ecall			#
				#
	la a0, won		#
	li a1, 133		#
	li a2, 129		#
	ecall			#
				#
endColor:			#

loop_end_screen:		#
jal key				# espera tecla para fechar jogo
bne a0, zero, end_loop_screen	#
j loop_end_screen		#
				#
end_loop_screen:		#

rectangle(0, 131, 111, 188, 137) # limpa tela
li a7,10	# encerra programa
ecall		#

########################################################################################

iterate_menu:			#
        li      a5,97		#  itera o menu
        beq     a0,a5,IM6	#
        li      a5,100		#
        beq     a0,a5,IM8	#
        andi    a0,a0,-5	#
        li      a5,115		#
        beq     a0,a5,IM9	#
        ret			#
IM8:				#
        lbu     a1,0(a1)	#
        li      a5,1		#
        beq     a1,zero,IM4	#
IM10:				#
        lw      a1,4(a4)	#
        addi    a2,a1,1		#
        srli    a0,a2,31	#
        add     a5,a2,a0	#
        slli    a1,a1,2		#
        add     a2,a3,a1	#
        andi    a5,a5,1		#
        lw      a1,0(a2)	#
        sub     a5,a5,a0	#
        slli    a0,a5,2		#
        add     a3,a3,a0	#
        sw      a1,0(a3)	#
        sw      zero,0(a2)	#
        sw      a5,4(a4)	#
        ret			#
IM9:				#
        lbu     a5,0(a1)	#
        xori    a5,a5,1		#
        sb      a5,0(a1)	#
        ret			#
IM6:				#
        lbu     a1,0(a1)	#
        li      a5,2		#
        bne     a1,zero,IM10	#
IM4:				#
        lw      a3,0(a4)	#
        li      a1,3		#
        add     a5,a5,a3	#
        rem     a5,a5,a1	#
        slli    a3,a3,2		#
        add     a3,a2,a3	#
        lw      a1,0(a3)	#
        slli    a0,a5,2		#
        add     a2,a2,a0	#
        sw      a1,0(a2)	#
        sw      zero,0(a3)	#
        sw      a5,0(a4)	#
        ret
        
key:	li t1,0xFF200000		# 
	lw t0,0(t1)			# 
	andi t0,t0,0x0001		# Copiei do exemplo mesmo
   	beq t0,zero,fim  	   	# pode denunciar
  	lw a0,4(t1)  			# 
	sw a0,12(t1)  			# 
fim:	ret	

circle:				## 	Gerado no compiler explorer
        slli    a5,a3,1		##	   codigo original em c
        add     t5,a1,a5	##
        mv      t1,a1		## void circle(int color, int x,
        bgt     a1,t5,.L1	##  int y, int r){
        add     a5,a2,a5	##
        mul     a7,a3,a3	##    unsigned char *Frame, *aux;
        bgt     a2,a5,.L1	##    Frame = (unsigned char *) VGA_ADDRESS;
        slli    t4,a2,2		##
        add     t4,t4,a2	##     for (int i = x; i <= x+2*r; i++){
        slli    t4,t4,6		##        for (int j = y; j <= y+2*r; j++){
        li      a4,-16777216	##             if (((x+r-i)*(x+r-i) + (y+r-j)*(y+r-j)) < r*r){
        addi    t5,t5,1		##                aux = Frame + (i + j*320);
        add     t6,a1,a3	## 	            *aux = color;
        add     t4,t4,a4	##             }
        sub     t3,a5,a3	##         }
        not     a6,a3		##     }
.L7:				## }
        sub     a1,t6,t1	##
        mul     a1,a1,a1	##
        sub     a5,t3,a2	##
        add     a3,t4,t1	##
.L4:				##
        mul     a4,a5,a5	##
        addi    a5,a5,-1	##
        add     a4,a4,a1	##
        bge     a4,a7,.L6	##
        sb      a0,0(a3)	##
.L6:				##
        addi    a3,a3,320	##
        bne     a5,a6,.L4	##
        addi    t1,t1,1		##
        bne     t1,t5,.L7	##
.L1:				##
        ret			##
        
rectangle:			## 	Gerado no compiler explorer
        bgt     a1,a3,.L10	##	   codigo original em c
        bgt     a2,a4,.L10	##
        slli    a5,a2,2		## void rectangle(int color, int x_lower,
        addi    a7,a4,1		##  int y_lower, int x_upper, int y_upper){
        li      t1,-16777216	##
        add     a2,a5,a2	##    unsigned char *Frame, *aux;
        slli    a2,a2,6		##    Frame = (unsigned char *) VGA_ADDRESS;
        addi    a4,t1,1		##
        slli    a6,a7,2		##    for (int i = x_lower; i <= x_upper; i++){
        add     a4,a2,a4	##         for (int j = y_lower; j <= y_upper; j++){
        add     a6,a6,a7	##             aux = Frame + (i + j*320);
        add     a4,a4,a3	## 	        *aux = color;
        slli    a6,a6,6		##        }
        add     a3,a1,t1	##     }
.L15:				## }
        add     a5,a3,a2	##
.L13:				##
        sb      a0,0(a5)	##
        addi    a5,a5,1		##
        bne     a5,a4,.L13	##
        addi    a2,a2,320	##
        addi    a4,a4,320	##
        bne     a2,a6,.L15	##
.L10:				##
        ret			##
        
print_board:			## 	Gerado no compiler explorer
        addi    sp,sp,-48	##	   codigo original em c
        sw      s2,32(sp)	##
        sw      s3,28(sp)	## void print_board(int board[8][8]){
        sw      s4,24(sp)	##     int x = 45, y = 43;
        sw      s5,20(sp)	##     for (int i = 0; i < 8; i++){
        sw      s6,16(sp)	##         for (int j = 0; j < 8; j++){
        sw      s7,12(sp)	##             switch (board[i][j]){
        sw      ra,44(sp)	##                  case 1:
        sw      s0,40(sp)	##                     circle(6, x+30*i, y+20*j, 8);
        sw      s1,36(sp)	##                     break;
        mv      s6,a0		##                 case 2:
        li      s2,45		##                     circle(192, x+30*i, y+20*j, 8);
        li      s5,1		##                     break;
        li      s4,2		##                default:
        li      s3,203		##                   circle(0, x+30*i, y+20*j, 8);
        li      s7,285		##             }
.L23:				##         }
        mv      s1,s6		##     }
        li      s0,43		## }
        j       .L22		##
.L30:				##
        li      a0,192		##
        beq     a5,s4,.L28	##
        li      a3,8		##
        li      a0,0		##
.L28:				##
        addi    s0,s0,20	##
        call    circle		##
        addi    s1,s1,4		##
        beq     s0,s3,.L29	##
.L22:				##
        lw      a5,0(s1)	##
        li      a3,8		##
        mv      a2,s0		##
        mv      a1,s2		##
        bne     a5,s5,.L30	##
        li      a0,6		##
        addi    s0,s0,20	##
        call    circle		##
        addi    s1,s1,4		##
        bne     s0,s3,.L22	##
.L29:				##
        addi    s2,s2,30	##
        addi    s6,s6,32	##
        bne     s2,s7,.L23	##
        lw      ra,44(sp)	##
        lw      s0,40(sp)	##
        lw      s1,36(sp)	##
        lw      s2,32(sp)	##
        lw      s3,28(sp)	##
        lw      s4,24(sp)	##
        lw      s5,20(sp)	##
        lw      s6,16(sp)	##
        lw      s7,12(sp)	##
        addi    sp,sp,48	##
        jr      ra		##
        
        
animation:			## 	Gerado no compiler explorer
        addi    sp,sp,-32	##	   codigo original em c 
        sw      s3,12(sp)	##
        sw      s4,8(sp)	## int animation(int x, int y, int color){
        sw      ra,28(sp)	##	    int new_color;
        sw      s0,24(sp)	##	    switch (color){
        sw      s1,20(sp)	##                 case 1:	
        sw      s2,16(sp)	##                     new_color = 6;
        li      a5,1		##                    break;
        mv      s3,a1		##                 case 2:
        li      s4,6		##                     new_color = 192;
        beq     a2,a5,.L11	##                     break;
        li      a5,2		##                 default:
        li      s4,0		##                     new_color = 0;
        bne     a2,a5,.L11	##     }
        li      s4,192		##
.L11:				##     for (int i=0; i < y; i++){
        slli    s2,a0,4		##         circle(new_color, 45+30*x, 43+20*i, 8);
        sub     s2,s2,a0	##         sleep(100);
        slli    s2,s2,1		##         circle(0, 45+30*x, 43+20*i, 8);
        addi    s2,s2,45	##     }
        li      s0,43		##     circle(new_color, 45+30*x, 43+20*y, 8);
        li      s1,0		##     return 0;
        ble     s3,zero,.AL13	## }
.L12:				##
        mv      a2,s0		##
        li      a3,8		##
        mv      a1,s2		##
        mv      a0,s4		##
        call    circle		##
        li      a0,100		##
        li      a0,50		##
        li a7,32		##
        ecall			##
        mv      a2,s0		##
        li      a3,8		##
        mv      a1,s2		##
        li      a0,0		##
        addi    s1,s1,1		##
        call    circle		##
        addi    s0,s0,20	##
        bne     s3,s1,.L12	##
.AL13:				##
        slli    a2,s3,2		##
        add     a2,a2,s3	##
        slli    a2,a2,2		##
        mv      a0,s4		##
        mv      a1,s2		##
        li      a3,8		##
        addi    a2,a2,43	##
        call    circle		##
        lw      ra,28(sp)	##
        lw      s0,24(sp)	##
        lw      s1,20(sp)	##
        lw      s2,16(sp)	##
        lw      s3,12(sp)	##
        lw      s4,8(sp)	##
        li      a0,0		##
        addi    sp,sp,32	##
        			##
        li a0, 62		##
	li a1, 100		##
	li a2, 115		##
	li a3, 100		##
	li a7, 31		##
	ecall			##
        			##
        jr      ra		##
        
add_element:			##	Gerado no compiler explorer
        slli    a5,a1,5		##	   codigo original em c
        addi    sp,sp,-16	##
        add     a0,a0,a5	## int add_element(int board[8][8], int index, int color){
        sw      s0,8(sp)	##
        lw      s0,0(a0)	##     if (board[index][0]){
        sw      ra,12(sp)	##         return -1;
        sw      s1,4(sp)	##    }
        bne     s0,zero,.L57	##
        mv      a6,a1		##     for (int i = 0; i < 7; i++){
        addi    a5,a0,4		##         if (board[index][i+1] != 0){
        li      a3,7		##             board[index][i] = color;
.L54:				##             animation(index, i, color);
        lw      a4,0(a5)	##             return i;       
        mv      s1,s0		##         }
        addi    s0,s0,1		##    }
        bne     a4,zero,.L59	##
        addi    a5,a5,4		##     board[index][7] = color;
        bne     s0,a3,.L54	##     animation(index, 7, color);
        sw      a2,28(a0)	##     return 7;
        li      a1,7		## }
        mv      a0,a6		##
        call    animation	##
.L52:				##
        lw      ra,12(sp)	##
        mv      a0,s0		##
        lw      s0,8(sp)	##
        lw      s1,4(sp)	##
        addi    sp,sp,16	##
        jr      ra		##
.L59:				##
        slli    a5,s1,2		##
        add     a0,a0,a5	##
        sw      a2,0(a0)	##
        mv      a1,s1		##
        mv      a0,a6		##
        call    animation	##
        mv      s0,s1		##
        lw      ra,12(sp)	##
        mv      a0,s0		##
        lw      s0,8(sp)	##
        lw      s1,4(sp)	##
        addi    sp,sp,16	##
        jr      ra		##
.L57:				##
        li      s0,-1		##
        j       .L52		##

game_draw:			##
        addi    a4,a0,256	## bool game_draw(int board[8][8]){
.GL3:				##     for (int i = 0; i < 8; i++){
        lw      a5,0(a0)	##         if (board[i][0] == 0){
        addi    a0,a0,32	##             return false;
        beq     a5,zero,.GL4	##         }
        bne     a0,a4,.GL3	##     }
        li      a0,1		##     return true;
        ret			## }
.GL4:				##
        li      a0,0		##
        ret			##
        
win_vertical:			## 	Gerado no compiler explorer
        li      a3,3		## 	   oodigo original em c
        sub     a6,a3,a1	##
        slli    a2,a2,5		## bool win_vertical(int board[8][8], int x, int y){
        not     a5,a6		##     int color = board[y][x];
        add     a2,a0,a2	##     int counter;
        slli    a4,a1,2		##
        li      a7,7		##     for (int i = max(0, 3-x); i <= min(7-x, 3) ; i++){
        add     a4,a2,a4	##         counter = 0;
        srai    a5,a5,31	##         for (int j = 0; j < 4; j++){
        sub     a7,a7,a1	##             if (board[y][x-3+i+j] == color){
        lw      a0,0(a4)	##                 counter++;
        and     a6,a6,a5	##             };
        ble     a7,a3,.L65	##         }
        li      a7,3		##         if (counter == 4){
.L65:				##             return true;
        blt     a7,a6,.L70	##         }
        addi    a5,a1,-3	##     }
        add     a5,a5,a6	##
        slli    a5,a5,2		##     return false;
        addi    a5,a5,16	##}
        add     a2,a2,a5	##
        li      a1,4		##
.L69:				##
        addi    a4,a2,-16	##
        li      a3,0		##
.L68:				##
        lw      a5,0(a4)	##
        addi    a4,a4,4		##
        sub     a5,a5,a0	##
        seqz    a5,a5		##
        add     a3,a3,a5	##
        bne     a4,a2,.L68	##
        beq     a3,a1,.L71	##
        addi    a6,a6,1		##
        addi    a2,a4,4		##
        bge     a7,a6,.L69	##
.L70:				##
        li      a0,0		##
        ret			##
.L71:				##
        li      a0,1		##
        ret			##
        
win_horizontal:			##  	Gerado no compiler explorer
        li      a3,3		## 	   oodigo original em c
        sub     a7,a3,a2	##
        slli    a5,a2,5		## bool win_horizontal(int board[8][8], int x, int y){
        not     a4,a7		##     int color = board[y][x];    int color = board[y][x];
        slli    a6,a1,2		##     int counter;
        add     a5,a0,a5	##
        li      t1,7		##     for (int i = max(0, 3-y); i <= min(7-y, 3) ; i++){
        add     a5,a5,a6	##         counter = 0;
        srai    a4,a4,31	##         for (int j = 0; j < 4; j++){
        sub     t1,t1,a2	##            if (board[y-3+i+j][x] == color){
        lw      a6,0(a5)	##                 counter++;
        and     a7,a7,a4	##             };
        ble     t1,a3,.L76	##         }
        li      t1,3		##         if (counter == 4){
.L76:				##             return true;
        blt     t1,a7,.L81	##         }
        addi    a2,a2,-3	##     }
        add     a2,a2,a7	##
        slli    a2,a2,3		##     return false;
        add     a2,a2,a1	## }
        slli    a2,a2,2		##
        addi    a0,a0,128	##
        add     a2,a2,a0	##
        li      a1,4		##
.L80:				##
        addi    a4,a2,-128	##
        li      a3,0		##
.L79:				##
        lw      a5,0(a4)	##
        addi    a4,a4,32	##
        sub     a5,a5,a6	##
        seqz    a5,a5		##
        add     a3,a3,a5	##
        bne     a4,a2,.L79	##
        beq     a3,a1,.L82	##
        addi    a7,a7,1		##
        addi    a2,a4,32	##
        bge     t1,a7,.L80	##
.L81:				##
        li      a0,0		##
        ret			##
.L82:				##
        li      a0,1		##
        ret			##
        
win_diagonal_decresing:		##	Gerado no compiler explorer
        li      a4,3		## 	   codigo original em c
        sub     a7,a4,a1	##
        not     a6,a7		## bool win_diagonal_decresing(int board[8][8], int x, int y){
        slli    t3,a2,5		##     int color = board[y][x];
        srai    a6,a6,31	##     int counter;
        add     a3,a0,t3	##
        slli    a5,a1,2		##     for (int i = max(max(0, 3-y), 3-x); i <= min(min(7-y, 3),7-x); i++){
        add     a3,a3,a5	##         counter = 0;
        and     a7,a7,a6	##       for (int j = 0; j < 4; j++){
        sub     a4,a4,a2	##             if (board[y+j-3+i][x+j-3+i] == color){
        lw      a6,0(a3)	##                 counter++;
        bge     a7,a4,.L87	##             };
        mv      a7,a4		##         }
.L87:				##         if (counter == 4){
        li      t1,7		##             return true;
        sub     t1,t1,a1	##         }
        li      a4,3		##     }
        ble     t1,a4,.L88	##
        li      t1,3		##     return false;
.L88:				## }
        li      a4,7		##
        sub     a2,a4,a2	##
        ble     t1,a2,.L89	##
        mv      t1,a2		##
.L89:				##
        bgt     a7,t1,.L94	##
        slli    a4,a7,3		##
        add     a4,a4,a7	##
        add     a5,a5,t3	##
        slli    a4,a4,2		##
        add     a5,a5,a4	##
        add     a0,a0,a5	##
        li      a1,4		##
.L93:				##
        mv      a3,a0		##
        li      a4,0		##
        li      a2,0		##
.L92:				##
        lw      a5,-108(a3)	##
        addi    a4,a4,1		##
        addi    a3,a3,36	##
        sub     a5,a5,a6	##
        seqz    a5,a5		##
        add     a2,a2,a5	##
        bne     a4,a1,.L92	##
        beq     a2,a4,.L95	##
        addi    a7,a7,1		##
        addi    a0,a0,36	##
        ble     a7,t1,.L93	##
.L94:				##
        li      a0,0		##
        ret			##
.L95:				##
        li      a0,1		##
        ret			##
        
win_diagonal_incresing:		##	Gerado no compiler explorer
        li      a7,3		##	   codigo original em c
        sub     a7,a7,a1	##
        not     a3,a7		## bool win_diagonal_incresing(int board[8][8], int x, int y){
        slli    t3,a2,5		##     int color = board[y][x];
        add     a4,a0,t3	##     int counter;
        slli    a5,a1,2		##
        srai    a3,a3,31	##     for (int i = max(max(0, y-4), 3-x); i <= min(min(y, 3), 7-x); i++){
        add     a4,a4,a5	##        counter = 0;
        addi    t1,a2,-4	##        for (int j = 0; j < 4; j++){
        and     a7,a7,a3	##            if (board[y-j+3-i][x+j-3+i] == color){
        lw      a6,0(a4)	##                 counter++;
        bge     a7,t1,.L100	##             };
        mv      a7,t1		##        }
.L100:				##        if (counter == 4){
        li      t1,7		##            return true;
        sub     t1,t1,a1	##       }
        li      a4,3		##   }
        ble     t1,a4,.L101	##
        li      t1,3		##     return false;
.L101:				## }
        ble     t1,a2,.L102	##
        mv      t1,a2		##
.L102:				##
        blt     t1,a7,.L107	##
        slli    a4,a7,3		##
        sub     a4,a4,a7	##
        add     a5,a5,t3	##
        slli    a4,a4,2		##
        sub     a5,a5,a4	##
        add     a0,a0,a5	##
        li      a1,4		##
.L106:				##
        mv      a3,a0		##
        li      a4,0		##
        li      a2,0		##
.L105:				##
        lw      a5,84(a3)	##
        addi    a4,a4,1		##
        addi    a3,a3,-28	##
        sub     a5,a5,a6	##
        seqz    a5,a5		##
        add     a2,a2,a5	##
        bne     a4,a1,.L105	##
        beq     a2,a4,.L108	##
        addi    a7,a7,1		##
        addi    a0,a0,-28	##
        bge     t1,a7,.L106	##
.L107:				##
        li      a0,0		##
        ret			##
.L108:				##
        li      a0,1		##
        ret			##
        
game_won:			##	Gerado no compiler explorer
        addi    sp,sp,-16	##	   codigo original em c
        sw      s0,8(sp)	##	
        sw      s1,4(sp)	## bool game_won(int board[8][8], int x, int y){
        sw      s2,0(sp)	##     return win_horizontal(board, x, y) || 
        sw      ra,12(sp)	##     win_vertical(board, x, y)||
        mv      s0,a0		##     win_diagonal_decresing(board, x, y)||
        mv      s1,a1		##     win_diagonal_incresing(board, x, y);
        mv      s2,a2		## }
        call    win_horizontal	##
        bne     a0,zero,.L112	##
        mv      a2,s2		##
        mv      a1,s1		##
        mv      a0,s0		##
        call    win_vertical	##
        beq     a0,zero,.L114	##
.L112:				##
        lw      ra,12(sp)	##
        lw      s0,8(sp)	##
        lw      s1,4(sp)	##
        lw      s2,0(sp)	##
        addi    sp,sp,16	##
        jr      ra		##
.L114:				##
        mv      a2,s2		##
        mv      a1,s1		##
        mv      a0,s0		##
        call    win_diagonal_decresing	##
        bne     a0,zero,.L112		##
        mv      a0,s0			##
        lw      s0,8(sp)		##
        lw      ra,12(sp)		##
        mv      a2,s2			##
        mv      a1,s1			##
        lw      s2,0(sp)		##
        lw      s1,4(sp)		##
        addi    sp,sp,16		##
        tail    win_diagonal_incresing	##

easy_mode:
li a0, 2	#
li a1, 8	#
li a7, 42	# a0 = randint(0, 7)
ecall		#
ret		#

indetify_win_move:		## 	Gerado no compiler explorer
        addi    sp,sp,-16	## 	   codigo original em c
        sw      s0,8(sp)	##
        slli    s0,a1,5		## bool indetify_win_move(int board[8][8], int index, int color){
        add     s0,a0,s0	##
        lw      a5,0(s0)	##     if (board[index][0]){
        sw      ra,12(sp)	##         return false;
        bne     a5,zero,IW65	##     }
        addi    a4,s0,4		##
        li      a6,7		##     for (int i = 0; i < 7; i++){
IW60:				##         if (board[index][i+1] != 0){
        lw      a3,0(a4)	##
        mv      a7,a5		##             board[index][i] = color;
        addi    a5,a5,1		##
        bne     a3,zero,IW67	##             if (game_won(board, i, index)){
        addi    a4,a4,4		##                 board[index][i] = 0;
        bne     a5,a6,IW60	##                 return true;
        sw      a2,28(s0)	##             }
        mv      a2,a1		## 
        li      a1,7		##             board[index][i] = 0;
        call    game_won	##
        lw      ra,12(sp)	##             return false;
        sw      zero,28(s0)	##
        lw      s0,8(sp)	##         }
        addi    sp,sp,16	##     }
        jr      ra		##
IW65:				##     board[index][7] = color;
        lw      ra,12(sp)	##
        lw      s0,8(sp)	##     if (game_won(board, 7, index)){
        li      a0,0		##         board[index][7] = 0;
        addi    sp,sp,16	##        return true;
        jr      ra		##     }
IW67:				##
        slli    a5,a7,2		##     board[index][7] = 0;
        add     s0,s0,a5	##
        sw      a2,0(s0)	##     return false;
        mv      a2,a1		## }
        mv      a1,a7		##
        call    game_won	##
        lw      ra,12(sp)	##
        sw      zero,0(s0)	##
        lw      s0,8(sp)	##
        addi    sp,sp,16	##
        jr      ra		##
        
normal_mode:			## 	Gerado no compiler explorer
        lw      a5,0(a1)	## 	   codigo original em c
        addi    sp,sp,-32	##
        sw      s1,20(sp)	## int normal_mode(int board[8][8], int* color){
        addi    a5,a5,1		##     int x, y, new_color = ((*color+1) % 2)+1;
        srli    a2,a5,31	##     for(int i = 0; i < 8; i++){
        add     s1,a5,a2	##         if (indetify_win_move(board, i, new_color)){
        andi    s1,s1,1		##             return i;
        sub     s1,s1,a2	##         }
        sw      s0,24(sp)	##     }
        sw      s2,16(sp)	## 
        sw      s3,12(sp)	##     return 0;
        sw      ra,28(sp)	## }
        mv      s2,a0		##
        addi    s1,s1,1		##
        li      s0,0		##
        li      s3,8		##
IW70:				##
        mv      a1,s0		##
        mv      a2,s1		##
        mv      a0,s2		##
        call    indetify_win_move	##
        bne     a0,zero,IW68	##
        addi    s0,s0,1		##
        bne     s0,s3,IW70	##
        call easy_mode		##
        mv s0, a0		##
IW68:				##
        lw      ra,28(sp)	##
        mv      a0,s0		##
        lw      s0,24(sp)	##
        lw      s1,20(sp)	##
        lw      s2,16(sp)	##
        lw      s3,12(sp)	##
        addi    sp,sp,32	##
        jr      ra		##

hard_mode:			## 	Gerado no compiler explorer
        addi    sp,sp,-32	## 	   codigo original em c
        sw      s3,12(sp)	##
        lw      s3,0(a1)	## int hard_mode(int board[8][8], int* color){
        sw      s2,16(sp)	##     int x, y;
        sw      s0,24(sp)	##     int player_color = (*color)+1, ai_color = ((*color+1) % 2)+1;
        addi    s3,s3,1		##     for(int i = 0; i < 8; i++){
        srli    a5,s3,31	##         if (indetify_win_move(board, i, ai_color)){
        add     s2,s3,a5	##             return i;
        andi    s2,s2,1		##         }
        sub     s2,s2,a5	##         else if(indetify_win_move(board, i, player_color)){
        sw      s1,20(sp)	##             return i;
        sw      s4,8(sp)	##         }
        sw      ra,28(sp)	##     }
        mv      s1,a0		## 
        addi    s2,s2,1		##     return 0;
        li      s0,0		## }
        li      s4,8		##
HM75:				##
        mv      a1,s0		##
        mv      a2,s2		##
        mv      a0,s1		##
        call    indetify_win_move ##
        mv      a5,a0		##
        mv      a1,s0		##
        mv      a2,s3		##
        mv      a0,s1		##
        bne     a5,zero,HM73	##
        call    indetify_win_move ##
        bne     a0,zero,HM73	##
        addi    s0,s0,1		##
        bne     s0,s4,HM75	##
        call easy_mode		##
        mv s0,a0		##
HM73:				##
        lw      ra,28(sp)	##
        mv      a0,s0		##
        lw      s0,24(sp)	##
        lw      s1,20(sp)	##
        lw      s2,16(sp)	##
        lw      s3,12(sp)	##
        lw      s4,8(sp)	##
        addi    sp,sp,32	##
        jr      ra		##

        
print_float:
	# a0 = string address, a1 = y position, fa0 = float address
	
	mv a2,a1
	li a1,0
	li a3,0xff
	li a4,1
	li a7,104
	ecall 
	
	li a7,102
	ecall

	ret
	
print_int:
	# a0 = string address, a1 = y position, a2 = int
	
	mv a5,a2
	
	mv a2,a1
	li a1,0
	li a3,0xff
	li a4,1
	li a7,104
	ecall 
	
	mv a0,a5
	li a7,101
	ecall

	ret
	      
.include "SYSTEMv21.s"
