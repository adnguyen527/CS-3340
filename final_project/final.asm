.data
card:		.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
card_length:	.word 32
deck:		.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
deck_length:	.word 63
title: .asciiz "\n----------------------------------------------------------------------------------------------------------\n\tMind Reader Game: READY TO BE MIND READ?!?!?"
returnEscape: .asciiz "\n"
spaces: 	.asciiz "     "
tab:	.asciiz "\t"
line:	.asciiz "|"
guess_prompt:	.asciiz "\tDO YOU SEE YOUR NUMBER? (y or n)\n"
input:		.space 1
noText:    .asciiz "\n * [no was triggered]"
not_found:	.asciiz "Not Found!"
found_num:	.word 0
found:		.asciiz
guess:		.word 0
final:		.asciiz "Your number is "

.text
main:
	la $a0, deck
	jal generate_deck
loop:
	la $a0, card
	jal fill_random_array
	
	la $a0, card
	jal sort_array
	
	jal title_display
	jal read_input
	jal beep
	
	lb $v0, input
	li $s7, 'n'
	bne $v0, $s7, loop
	
	la $a0, card
	la $a1, deck
	jal eliminate_card
	
	la $a0, deck
	jal deck_count
	
	li, $t0, 1
	bne $v0, $t0, loop_end
	# then find num
	la $a0, deck
	jal find_last
	
	jal mega
	
	#out in $s6
	li $v0, 4
	la $a0, returnEscape
	syscall
	la $a0, tab
	syscall
	la $a0, final
	syscall
	li $v0, 1
	move $a0, $s6
	syscall
	
	j exit
loop_end:
	beq $v0, $zero, fail
	j loop
	
fail:
	li $v0, 4
	la $a0, not_found
	j exit
	
find_last:
	# t0 is for card_length * 4
	# t1 is for the calculated address in deck
	# s0 is for the index
	# v0 is for the found number
	li $s0, 0
	li $s6, 0
find_last_loop:
	lw $t0, deck_length
	mul $t0, $t0, 4
	
	add $t1, $s0, $a0
	lw $s6, 0($t1)
	beq $s6, $zero, find_last_end
	jr $ra
find_last_end:
	add $s0, $s0, 4
	bne $s0, $t0, find_last_loop
	jr $ra
	
deck_count:
	# t0 is for card_length * 4
	# t1 is for the calculated address in deck
	# t2 is for the number at address
	# s0 is for the index
	# v0 is for the count
	li $s0, 0
	li $v0, 0
deck_count_loop:
	lw $t0, deck_length
	mul $t0, $t0, 4
	
	add $t1, $s0, $a0
	lw $t2, 0($t1)
	beq $t2, $zero, deck_count_end
	add $v0, $v0, 1
deck_count_end:
	add $s0, $s0, 4
	bne $s0, $t0, deck_count_loop
	jr $ra
	
eliminate_card:
	# t0 is for card_length * 4
	# t1 is for the calculated address in card
	# t2 is for the number at address in card
	# t3 is for the calculated address in deck
	# s0 is for the index
	li $s0, 0
eliminate_card_loop:
	lw $t0, card_length
	mul $t0, $t0, 4
	
	add $t1, $s0, $a0
	lw $t2, 0($t1)
	mul $t2, $t2, 4
	sub $t2, $t2, 4
	add $t3, $t2, $a1
	sw $zero, 0($t3)
	
	add $s0, $s0, 4
	bne $s0, $t0, eliminate_card_loop	
	jr $ra
	
generate_deck:
    # t0 is for deck_length * 4
    # t1 is for the calculated address
    # t2 is for the number to put in
    # s0 is for the index
    li $s0, 0
generate_deck_loop:
    lw $t0, deck_length
    mul $t0, $t0, 4
    
    div $t2, $s0, 4
    addi $t2, $t2, 1
    
    add $t1, $a0, $s0
    sw $t2, 0($t1)
    add $s0, $s0, 4
    
    bne $s0, $t0, generate_deck_loop
    jr $ra    
    
sort_array:
	# t0 is card_length * 4
	# t1 is for the calculated address
	# t2 is for the value
	# s0 is for the index i
	# s1 is for the smallest num
	# s2 is for the smallest index
	# s3 is for the index j
	lw $t0, card_length
	mul $t0, $t0, 4
	li $s0, 0
sort_outer_loop:
	li $s1, 64
	addi $s3, $s0, 0
sort_inner_loop:
	add $t1, $a0, $s3
	lw $t2, 0($t1)
	blt $s1, $t2, sort_inner_loop_end
	move $s2, $s3
	move $s1, $t2
sort_inner_loop_end:
	add $s3, $s3, 4
	bne $s3, $t0, sort_inner_loop
sort_outer_loop_end:
	# swap index i and s2 index
	add $t1, $s0, $a0
	add $t3, $s2, $a0
	lw $t7, 0($t1)
	lw $t6, 0($t3)
	sw $t7, 0($t3)
	sw $t6, 0($t1)
	add $s0, $s0, 4
	bne $s0, $t0, sort_outer_loop
sort_end:
	jr $ra


fill_random_array:
	li $s0, 0
fill_random_array_loop:
	# t0 is for the card_length * 4
	# t1 is for the random variable
	# t2 is for the calculate
	# s0 is for the index
	lw $t0, card_length
	mul  $t0, $t0, 4
	
	# before calling function, store $s0 into $s7
	# and $ra into $s6
	move $s7, $s0
	move $s5, $ra
	jal select_unique_element
	move $s0, $s7
	move $ra, $s5
	# v0 is the selected element
	move $t1, $v0
	
	add $t2, $s0, $a0
	sw $t1, 0($t2)
	add $s0, $s0, 4
	
	bne $s0, $t0, fill_random_array_loop
	jr $ra
	
select_unique_element:
	move $t3, $a0
	li $a1, 63
	li $v0, 42
	syscall
	add $a0, $a0, 1
	move $v0, $a0
	move $a0, $t3
	li $s0, 0
check_loop:
	lw $t0, card_length
	mul $t0, $t0, 4
	add $t2, $s0, $a0
	lw $t1, 0($t2)
	add $s0, $s0, 4
	
	beq $t1, $v0, select_unique_element
	bne $s0, $t0, check_loop
	
	# v0 is now the random generated number
	jr $ra 
	
# -----------------------------------------------------

title_display:
# Title
	li $v0, 4
	la $a0, returnEscape
	syscall
	la $a0, title
	syscall
	la $a0, returnEscape
	syscall
	
	move $s5, $ra
	jal display
	jal prompt
	move $ra, $s5
	
	jr $ra

display:
# Application
	la $t8, card
	li $t0, 0
	li $s1, 8
	li $s3, 0
	lw $s2, card_length

	# t0 is the index of array
	# t1 is the array address
	# t2 value in array index
	# s0 is index for loop
	# s1 is the amount of integers in a line
	# s2 is the number of integers on the card
card_loop:
	li $s0, 0
	li $v0, 4
	la $a0, returnEscape
	syscall
	la $a0, tab
	syscall
	la $a0, line
	syscall
	la $a0, returnEscape
	syscall
	la $a0, tab
	syscall
	la $a0, line
	syscall
	la $a0, tab
	syscall
    small_loop:
	add $t0, $t0, $t0
	add $t0, $t0, $t0 # 4 times the index
	add $t1, $t0, $t8
	lw $t2, 0($t1) # get value from array at index
		
	li $v0, 1 # print
	la $a0, ($t2)
	syscall
	li $v0, 4
	la $a0, tab
	syscall
	
	li $t7, 4
	div $t0, $t7
	mflo $t0 # divide by 4
	add $t0, $t0, 1 # increment index in array
	add $s0, $s0, 1
	add $s3, $s3, 1
	
	beq $s2, $s3, done_display # reach the last number on card
	bne $s0, $s1, small_loop
	j card_loop # reach the last number of the line
done_display:
	jr $ra
	
prompt:
	li $v0, 4
	la $a0, returnEscape
	syscall
	la $a0, tab
	syscall
	la $a0, line
	syscall
	la $a0, returnEscape
	syscall
	la $a0, tab
	syscall
	la $a0, line
	syscall
	li $v0, 4
	la $a0, guess_prompt
	syscall
	
	jr $ra
read_input:
	li $v0, 12
	syscall
	sb $v0, input
	jr $ra # go back to main to loop again
	
beep:
	li $a0, 71
	li $a1, 500
	li $a2, 57
	li $a3, 127
	li $v0, 33
	syscall
	jr $ra
	
loot:
	li $a0, 71
	li $a1, 300
	li $a2, 57
	li $a3, 127
	li $v0, 33
	syscall
	li $a0, 73
	syscall
	li $a0, 73
	syscall
	li $a0, 75
	li $a1, 500
	syscall
	jr $ra

mega:
	li $a0, 60
	li $a1, 150
	li $a2, 57
	li $a3, 127
	li $v0, 33
	syscall
	li $a0, 60
	syscall
	li $a0, 74
	syscall
	li $a0, 1
	syscall
	li $a0, 68
	li $a1, 300
	syscall
	jr $ra
	
	
exit:
