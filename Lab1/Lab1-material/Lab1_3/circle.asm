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
li a3, 0xFF
li a4, 0

la a0, dificuldade
li a1, 117
li a2, 89
li a7, 104
ecall

la a0, cor
li a1, 149
li a2, 121
li a7, 104
ecall

menu_loop:
jal key
li t0, 10
beq a0,t0, end_menu

la a1, is_color
la a2, menu
addi a3, a2, 12
la a4, difficult

jal iterate_menu

la t0, is_color
lw t0,0(t0)

li a0, 42
li a3, 0
li a4, 0
li a7,111
	
bne t0,zero,if_select
	li a1, 129
	li a2, 137
	ecall 
	
	li a1, 69
	li a2, 105
	
j end_select
if_select:
	li a1, 69
	li a2, 105
	ecall

	li a1, 129
	li a2, 137

end_select:

	li a3, 0xff
	ecall

li a3, 0xFF
li a4, 0

la t0, menu

la a0, facil
li a3, 0x33
lw t1,0(t0)
add a3, a3, t1
colored_string(85, 105)


la a0, medio
li a3, 0x77
lw t1,4(t0)
add a3, a3, t1
colored_string(133, 105)


la a0, dificil
li a3, 0x6
lw t1,8(t0)
add a3, a3, t1
colored_string(181, 105)


addi t0,t0,12

li a0, 1
li a1, 145
li a2, 137
li a3, 7
lw t1,0(t0)
add a3, a3, t1
li a7, 101
ecall

li a0, 2
li a1, 172
li a2, 137
li a3, 0xc0
lw t1,4(t0)
add a3, a3, t1
li a7, 101
ecall

j menu_loop

end_menu:

###################### game

la t0, difficult
lw t0,0(t0)

bne t0,zero,top_not_easy
la a0, facil
li a3, 0x33
colored_string(138, 28)
j end_top_string
top_not_easy:

li t1, 1

bne t0, t1,top_not_normal
la a0, medio
li a3, 0x77
colored_string(138, 28)
j end_top_string
top_not_normal:

la a0, dificil
li a3, 0x6
colored_string(130, 28)
end_top_string:


li s1, 0  # turno

rectangle(89, 37, 38, 281, 200)

circle(89, 17, 200, 21)
circle(89, 257, 200, 21)
rectangle(0, 37, 201, 60, 240)
rectangle(0, 258, 201, 280, 240)



li t0, 0
li t1, 8

li a0, 49
li a1, 50
li a2, 207
li a3, 0x77
li a4, 0
li a7, 111
key_tip: beq t0, t1, end_key_tip
ecall
addi a1, a1, 30
addi t0, t0, 1
addi a0, a0, 1
j key_tip
end_key_tip:


la a0, board
jal print_board


main_loop:


beq s1,zero,if_turn_circle
circle(0xc0, 150, 7, 6)
j end_turn_circle
if_turn_circle:
circle(7, 150, 7, 6)
end_turn_circle:

la t0, color
lw t0,0(t0)
beq s1, t0, get_key

######## AI ############

la t0, difficult
lw t0,0(t0)

bne t0,zero,not_easy
jal easy_mode
j end_ai_command
not_easy:

li t1, 1

bne t0, t1,not_normal
la a0, board
la a1, color
jal normal_mode
j end_ai_command
not_normal:

la a0, board
la a1, color
jal hard_mode

end_ai_command:


########################

j end_turn

get_key:
	jal key
	mv s0, a0
        addi    a0,a0,-49
        li      t0,7
        bgtu    a0,t0,get_key


end_turn:    


la t0, y
sw a0,0(t0)

mv a1, a0
la a0,board
la a2,current_color
lw a2,0(a2)

jal add_element
la t0, x
sw a0,0(t0)

la a0,board
jal game_draw
	
	la a1, winner
        beq     a0,zero,if_game_draw # if (game_draw(board)){
        sw      zero,0(a1)	      #    winner = 0;
        j end			      #	break;}
if_game_draw:

	la a0, board

	la t0, x
	lw a1, 0(t0)

	lw a2, 4(t0)
	
	jal game_won
	
	la a1, current_color		#
	la a2, winner			# if (game_won(board, x, y)){
        beq     a0,zero,if_game_won	#    winner = current_color;
        lw      t0,0(a1)		#    break;}
        sw      t0,0(a2)		#
        j end				#
if_game_won:

	la t0, x
	lw a0,0(t0)
	
	la a1, current_color
        li      t0,-1
        beq     a0,t0,next_color
        lw      t0,0(a1)
        srli    t1,t0,31
        add     t0,t0,t1
        andi    t0,t0,1
        sub     t0,t0,t1
        addi    t0,t0,1
        sw      t0,0(a1)
next_color:

xori s1,s1, 1
j main_loop

end:

# rectangle(0x77, 74, 61, 242, 180)
li a0, 1000
li a7, 32
ecall

rectangle(0, 0, 0, 320, 240)


# rectangle(0x77, 131, 111, 188, 137)

la a0, winner
lw a0, 0 (a0)
li a4, 0

mv a3,a0
        li      t0,1
        mv      t1,a3
        beq     a3,t0,colorL1
        li      t0,2
        li      a3,0x00c0
        beq     t1,t0,colorL2
        li      a3,0x00ff
        li a1, 137
	li a2, 121
	la a0, draw
	li a7, 104
	ecall
        j endColor
colorL1:
        li      a3,0x0007
colorL2:
	li a1, 157
	li a2, 121
	li a7, 101
	ecall
	
	la a0, player
	li a1, 133
	li a2, 113
	li a7, 104
	ecall
	
	la a0, won
	li a1, 133
	li a2, 129
	ecall
	
	
endColor:

loop_end_screen:
jal key
bne a0, zero, end_loop_screen
j loop_end_screen

end_loop_screen:

rectangle(0, 131, 111, 188, 137)
li a7,10
ecall
########################################################################################
iterate_menu:
        li      a5,97
        beq     a0,a5,IM6
        li      a5,100
        beq     a0,a5,IM8
        andi    a0,a0,-5
        li      a5,115
        beq     a0,a5,IM9
        ret
IM8:
        lbu     a1,0(a1)
        li      a5,1
        beq     a1,zero,IM4
IM10:
        lw      a1,4(a4)
        addi    a2,a1,1
        srli    a0,a2,31
        add     a5,a2,a0
        slli    a1,a1,2
        add     a2,a3,a1
        andi    a5,a5,1
        lw      a1,0(a2)
        sub     a5,a5,a0
        slli    a0,a5,2
        add     a3,a3,a0
        sw      a1,0(a3)
        sw      zero,0(a2)
        sw      a5,4(a4)
        ret
IM9:
        lbu     a5,0(a1)
        xori    a5,a5,1
        sb      a5,0(a1)
        ret
IM6:
        lbu     a1,0(a1)
        li      a5,2
        bne     a1,zero,IM10
IM4:
        lw      a3,0(a4)
        li      a1,3
        add     a5,a5,a3
        rem     a5,a5,a1
        slli    a3,a3,2
        add     a3,a2,a3
        lw      a1,0(a3)
        slli    a0,a5,2
        add     a2,a2,a0
        sw      a1,0(a2)
        sw      zero,0(a3)
        sw      a5,0(a4)
        ret
        
key:	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,fim  	   	# Se n�o h� tecla pressionada ent�o vai para FIM
  	lw a0,4(t1)  			# le o valor da tecla tecla
	sw a0,12(t1)  			# escreve a tecla pressionada no display
fim:	ret	

circle:
        slli    a5,a3,1
        add     t5,a1,a5
        mv      t1,a1
        bgt     a1,t5,.L1
        add     a5,a2,a5
        mul     a7,a3,a3
        bgt     a2,a5,.L1
        slli    t4,a2,2
        add     t4,t4,a2
        slli    t4,t4,6
        li      a4,-16777216
        addi    t5,t5,1
        add     t6,a1,a3
        add     t4,t4,a4
        sub     t3,a5,a3
        not     a6,a3
.L7:
        sub     a1,t6,t1
        mul     a1,a1,a1
        sub     a5,t3,a2
        add     a3,t4,t1
.L4:
        mul     a4,a5,a5
        addi    a5,a5,-1
        add     a4,a4,a1
        bge     a4,a7,.L6
        sb      a0,0(a3)
.L6:
        addi    a3,a3,320
        bne     a5,a6,.L4
        addi    t1,t1,1
        bne     t1,t5,.L7
.L1:
        ret
rectangle:
        bgt     a1,a3,.L10
        bgt     a2,a4,.L10
        slli    a5,a2,2
        addi    a7,a4,1
        li      t1,-16777216
        add     a2,a5,a2
        slli    a2,a2,6
        addi    a4,t1,1
        slli    a6,a7,2
        add     a4,a2,a4
        add     a6,a6,a7
        add     a4,a4,a3
        slli    a6,a6,6
        add     a3,a1,t1
.L15:
        add     a5,a3,a2
.L13:
        sb      a0,0(a5)
        addi    a5,a5,1
        bne     a5,a4,.L13
        addi    a2,a2,320
        addi    a4,a4,320
        bne     a2,a6,.L15
.L10:
        ret
print_board:
        addi    sp,sp,-48
        sw      s2,32(sp)
        sw      s3,28(sp)
        sw      s4,24(sp)
        sw      s5,20(sp)
        sw      s6,16(sp)
        sw      s7,12(sp)
        sw      ra,44(sp)
        sw      s0,40(sp)
        sw      s1,36(sp)
        mv      s6,a0
        li      s2,45
        li      s5,1
        li      s4,2
        li      s3,203
        li      s7,285
.L23:
        mv      s1,s6
        li      s0,43
        j       .L22
.L30:
        li      a0,192
        beq     a5,s4,.L28
        li      a3,8
        li      a0,0
.L28:
        addi    s0,s0,20
        call    circle
        addi    s1,s1,4
        beq     s0,s3,.L29
.L22:
        lw      a5,0(s1)
        li      a3,8
        mv      a2,s0
        mv      a1,s2
        bne     a5,s5,.L30
        li      a0,6
        addi    s0,s0,20
        call    circle
        addi    s1,s1,4
        bne     s0,s3,.L22
.L29:
        addi    s2,s2,30
        addi    s6,s6,32
        bne     s2,s7,.L23
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
        
        
animation:
        addi    sp,sp,-32
        sw      s3,12(sp)
        sw      s4,8(sp)
        sw      ra,28(sp)
        sw      s0,24(sp)
        sw      s1,20(sp)
        sw      s2,16(sp)
        li      a5,1
        mv      s3,a1
        li      s4,6
        beq     a2,a5,.L11
        li      a5,2
        li      s4,0
        bne     a2,a5,.L11
        li      s4,192
.L11:
        slli    s2,a0,4
        sub     s2,s2,a0
        slli    s2,s2,1
        addi    s2,s2,45
        li      s0,43
        li      s1,0
        ble     s3,zero,.AL13
.L12:
        mv      a2,s0
        li      a3,8
        mv      a1,s2
        mv      a0,s4
        call    circle
        li      a0,100
        li      a0,50
        li a7,32
        ecall
        mv      a2,s0
        li      a3,8
        mv      a1,s2
        li      a0,0
        addi    s1,s1,1
        call    circle
        addi    s0,s0,20
        bne     s3,s1,.L12
.AL13:
        slli    a2,s3,2
        add     a2,a2,s3
        slli    a2,a2,2
        mv      a0,s4
        mv      a1,s2
        li      a3,8
        addi    a2,a2,43
        call    circle
        lw      ra,28(sp)
        lw      s0,24(sp)
        lw      s1,20(sp)
        lw      s2,16(sp)
        lw      s3,12(sp)
        lw      s4,8(sp)
        li      a0,0
        addi    sp,sp,32
        
        li a0, 62
	li a1, 100
	li a2, 115
	li a3, 100
	li a7, 31
	ecall
        
        jr      ra
        
add_element:
        slli    a5,a1,5
        addi    sp,sp,-16
        add     a0,a0,a5
        sw      s0,8(sp)
        lw      s0,0(a0)
        sw      ra,12(sp)
        sw      s1,4(sp)
        bne     s0,zero,.L57
        mv      a6,a1
        addi    a5,a0,4
        li      a3,7
.L54:
        lw      a4,0(a5)
        mv      s1,s0
        addi    s0,s0,1
        bne     a4,zero,.L59
        addi    a5,a5,4
        bne     s0,a3,.L54
        sw      a2,28(a0)
        li      a1,7
        mv      a0,a6
        call    animation
.L52:
        lw      ra,12(sp)
        mv      a0,s0
        lw      s0,8(sp)
        lw      s1,4(sp)
        addi    sp,sp,16
        jr      ra
.L59:
        slli    a5,s1,2
        add     a0,a0,a5
        sw      a2,0(a0)
        mv      a1,s1
        mv      a0,a6
        call    animation
        mv      s0,s1
        lw      ra,12(sp)
        mv      a0,s0
        lw      s0,8(sp)
        lw      s1,4(sp)
        addi    sp,sp,16
        jr      ra
.L57:
        li      s0,-1
        j       .L52

game_draw:
        addi    a4,a0,256
.GL3:
        lw      a5,0(a0)
        addi    a0,a0,32
        beq     a5,zero,.GL4
        bne     a0,a4,.GL3
        li      a0,1
        ret
.GL4:
        li      a0,0
        ret
        
win_vertical:
        li      a3,3
        sub     a6,a3,a1
        slli    a2,a2,5
        not     a5,a6
        add     a2,a0,a2
        slli    a4,a1,2
        li      a7,7
        add     a4,a2,a4
        srai    a5,a5,31
        sub     a7,a7,a1
        lw      a0,0(a4)
        and     a6,a6,a5
        ble     a7,a3,.L65
        li      a7,3
.L65:
        blt     a7,a6,.L70
        addi    a5,a1,-3
        add     a5,a5,a6
        slli    a5,a5,2
        addi    a5,a5,16
        add     a2,a2,a5
        li      a1,4
.L69:
        addi    a4,a2,-16
        li      a3,0
.L68:
        lw      a5,0(a4)
        addi    a4,a4,4
        sub     a5,a5,a0
        seqz    a5,a5
        add     a3,a3,a5
        bne     a4,a2,.L68
        beq     a3,a1,.L71
        addi    a6,a6,1
        addi    a2,a4,4
        bge     a7,a6,.L69
.L70:
        li      a0,0
        ret
.L71:
        li      a0,1
        ret
win_horizontal:
        li      a3,3
        sub     a7,a3,a2
        slli    a5,a2,5
        not     a4,a7
        slli    a6,a1,2
        add     a5,a0,a5
        li      t1,7
        add     a5,a5,a6
        srai    a4,a4,31
        sub     t1,t1,a2
        lw      a6,0(a5)
        and     a7,a7,a4
        ble     t1,a3,.L76
        li      t1,3
.L76:
        blt     t1,a7,.L81
        addi    a2,a2,-3
        add     a2,a2,a7
        slli    a2,a2,3
        add     a2,a2,a1
        slli    a2,a2,2
        addi    a0,a0,128
        add     a2,a2,a0
        li      a1,4
.L80:
        addi    a4,a2,-128
        li      a3,0
.L79:
        lw      a5,0(a4)
        addi    a4,a4,32
        sub     a5,a5,a6
        seqz    a5,a5
        add     a3,a3,a5
        bne     a4,a2,.L79
        beq     a3,a1,.L82
        addi    a7,a7,1
        addi    a2,a4,32
        bge     t1,a7,.L80
.L81:
        li      a0,0
        ret
.L82:
        li      a0,1
        ret
win_diagonal_decresing:
        li      a4,3
        sub     a7,a4,a1
        not     a6,a7
        slli    t3,a2,5
        srai    a6,a6,31
        add     a3,a0,t3
        slli    a5,a1,2
        add     a3,a3,a5
        and     a7,a7,a6
        sub     a4,a4,a2
        lw      a6,0(a3)
        bge     a7,a4,.L87
        mv      a7,a4
.L87:
        li      t1,7
        sub     t1,t1,a1
        li      a4,3
        ble     t1,a4,.L88
        li      t1,3
.L88:
        li      a4,7
        sub     a2,a4,a2
        ble     t1,a2,.L89
        mv      t1,a2
.L89:
        bgt     a7,t1,.L94
        slli    a4,a7,3
        add     a4,a4,a7
        add     a5,a5,t3
        slli    a4,a4,2
        add     a5,a5,a4
        add     a0,a0,a5
        li      a1,4
.L93:
        mv      a3,a0
        li      a4,0
        li      a2,0
.L92:
        lw      a5,-108(a3)
        addi    a4,a4,1
        addi    a3,a3,36
        sub     a5,a5,a6
        seqz    a5,a5
        add     a2,a2,a5
        bne     a4,a1,.L92
        beq     a2,a4,.L95
        addi    a7,a7,1
        addi    a0,a0,36
        ble     a7,t1,.L93
.L94:
        li      a0,0
        ret
.L95:
        li      a0,1
        ret
win_diagonal_incresing:
        li      a7,3
        sub     a7,a7,a1
        not     a3,a7
        slli    t3,a2,5
        add     a4,a0,t3
        slli    a5,a1,2
        srai    a3,a3,31
        add     a4,a4,a5
        addi    t1,a2,-4
        and     a7,a7,a3
        lw      a6,0(a4)
        bge     a7,t1,.L100
        mv      a7,t1
.L100:
        li      t1,7
        sub     t1,t1,a1
        li      a4,3
        ble     t1,a4,.L101
        li      t1,3
.L101:
        ble     t1,a2,.L102
        mv      t1,a2
.L102:
        blt     t1,a7,.L107
        slli    a4,a7,3
        sub     a4,a4,a7
        add     a5,a5,t3
        slli    a4,a4,2
        sub     a5,a5,a4
        add     a0,a0,a5
        li      a1,4
.L106:
        mv      a3,a0
        li      a4,0
        li      a2,0
.L105:
        lw      a5,84(a3)
        addi    a4,a4,1
        addi    a3,a3,-28
        sub     a5,a5,a6
        seqz    a5,a5
        add     a2,a2,a5
        bne     a4,a1,.L105
        beq     a2,a4,.L108
        addi    a7,a7,1
        addi    a0,a0,-28
        bge     t1,a7,.L106
.L107:
        li      a0,0
        ret
.L108:
        li      a0,1
        ret
game_won:
        addi    sp,sp,-16
        sw      s0,8(sp)
        sw      s1,4(sp)
        sw      s2,0(sp)
        sw      ra,12(sp)
        mv      s0,a0
        mv      s1,a1
        mv      s2,a2
        call    win_horizontal
        bne     a0,zero,.L112
        mv      a2,s2
        mv      a1,s1
        mv      a0,s0
        call    win_vertical
        beq     a0,zero,.L114
.L112:
        lw      ra,12(sp)
        lw      s0,8(sp)
        lw      s1,4(sp)
        lw      s2,0(sp)
        addi    sp,sp,16
        jr      ra
.L114:
        mv      a2,s2
        mv      a1,s1
        mv      a0,s0
        call    win_diagonal_decresing
        bne     a0,zero,.L112
        mv      a0,s0
        lw      s0,8(sp)
        lw      ra,12(sp)
        mv      a2,s2
        mv      a1,s1
        lw      s2,0(sp)
        lw      s1,4(sp)
        addi    sp,sp,16
        tail    win_diagonal_incresing

easy_mode:
li a0, 2
li a1, 8
li a7, 42
ecall
ret

indetify_win_move:
        addi    sp,sp,-16
        sw      s0,8(sp)
        slli    s0,a1,5
        add     s0,a0,s0
        lw      a5,0(s0)
        sw      ra,12(sp)
        bne     a5,zero,IW65
        addi    a4,s0,4
        li      a6,7
IW60:
        lw      a3,0(a4)
        mv      a7,a5
        addi    a5,a5,1
        bne     a3,zero,IW67
        addi    a4,a4,4
        bne     a5,a6,IW60
        sw      a2,28(s0)
        mv      a2,a1
        li      a1,7
        call    game_won
        lw      ra,12(sp)
        sw      zero,28(s0)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
IW65:
        lw      ra,12(sp)
        lw      s0,8(sp)
        li      a0,0
        addi    sp,sp,16
        jr      ra
IW67:
        slli    a5,a7,2
        add     s0,s0,a5
        sw      a2,0(s0)
        mv      a2,a1
        mv      a1,a7
        call    game_won
        lw      ra,12(sp)
        sw      zero,0(s0)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
normal_mode:
        lw      a5,0(a1)
        addi    sp,sp,-32
        sw      s1,20(sp)
        addi    a5,a5,1
        srli    a2,a5,31
        add     s1,a5,a2
        andi    s1,s1,1
        sub     s1,s1,a2
        sw      s0,24(sp)
        sw      s2,16(sp)
        sw      s3,12(sp)
        sw      ra,28(sp)
        mv      s2,a0
        addi    s1,s1,1
        li      s0,0
        li      s3,8
IW70:
        mv      a1,s0
        mv      a2,s1
        mv      a0,s2
        call    indetify_win_move
        bne     a0,zero,IW68
        addi    s0,s0,1
        bne     s0,s3,IW70
        #li      s0,0
        call easy_mode
        mv s0, a0
IW68:
        lw      ra,28(sp)
        mv      a0,s0
        lw      s0,24(sp)
        lw      s1,20(sp)
        lw      s2,16(sp)
        lw      s3,12(sp)
        addi    sp,sp,32
        jr      ra

hard_mode:
        addi    sp,sp,-32
        sw      s3,12(sp)
        lw      s3,0(a1)
        sw      s2,16(sp)
        sw      s0,24(sp)
        addi    s3,s3,1
        srli    a5,s3,31
        add     s2,s3,a5
        andi    s2,s2,1
        sub     s2,s2,a5
        sw      s1,20(sp)
        sw      s4,8(sp)
        sw      ra,28(sp)
        mv      s1,a0
        addi    s2,s2,1
        li      s0,0
        li      s4,8
HM75:
        mv      a1,s0
        mv      a2,s2
        mv      a0,s1
        call    indetify_win_move
        mv      a5,a0
        mv      a1,s0
        mv      a2,s3
        mv      a0,s1
        bne     a5,zero,HM73
        call    indetify_win_move
        bne     a0,zero,HM73
        addi    s0,s0,1
        bne     s0,s4,HM75
        #li      s0,0
        call easy_mode
        mv s0,a0
HM73:
        lw      ra,28(sp)
        mv      a0,s0
        lw      s0,24(sp)
        lw      s1,20(sp)
        lw      s2,16(sp)
        lw      s3,12(sp)
        lw      s4,8(sp)
        addi    sp,sp,32
        jr      ra
        
.include "SYSTEMv21.s"
