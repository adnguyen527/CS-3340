.data
promptZip:	.asciiz "\nGive me your zip code (0 to stop) "
input:		.word 0
sum:		.word 0
increment:	.byte 0
sumStatement:	.asciiz "\nThe sum of all digits in your zip code is "
recursive:	.asciiz "\nRECURSIVE: "
iterative:		.asciiz  "\nITERATIVE: "
.text
main:
# Prompt user for a zip code
prompt:	li	$v0, 4
	la	$a0, promptZip
	syscall
# Reads input
	li	$v0, 5
	syscall
	sw	$v0, input	# stores zip code input in input data
	
# Checks if equal to zero
	lw	$t0, input
	beq	$t0, $zero, exit
# Outputs sumStatement
	li	$v0, 4
	la	$a0, sumStatement
	syscall
	
	#li	$v0, 1
	#lw	$a0, input
	#syscall
	jal 	recursiveFunct	# does recursive function and prints
	jal	iterativeFunct	# does iterative function and prints

	
# Prompts the user again
	j 	prompt		# prompt again
# Exits program
exit:
	li	$v0, 10
	syscall
	
# recursive method
recursiveFunct:
	li	$v0, 4
	la	$a0, recursive
	syscall			# prints recursive statement
	lw 	$a1, input	# $a1 is input
	lw	$s0, sum	# $s0 is sum
rec_loop:
	beq	$a1, $zero, rec_done	# checks if $t0 is zero, if true, returns
	rem	$a0, $a1, 10	# get remainder $a0
	add	$s0, $s0, $a0	# add remainder to sum
	div	$a1, $a1, 10	# sets $a1 to $a1 divide by ten
	j	rec_loop		# loop recursive
	
rec_done:
	li	$v0, 1
	move	$a0, $s0		# $s0 is sum
	syscall			# print the sum
	
	lw	$s0, sum
	move	$s0, $zero	# reset sum to zero
	jr 	$ra
		
# iterative method
iterativeFunct:
	li	$v0, 4
	la	$a0, iterative
	syscall			# prints iterative statement
	lb	$t0, increment	# $t0 is increment
	lw 	$a1, input	# $a1 is input
	lw	$s0, sum	# $s0 is sum
incre_while:
	beq	$t0, 5, incre_done
	rem	$a0, $a1, 10	# get remainder $a0
	add	$s0, $s0, $a0	# add remainder to sum
	div	$a1, $a1, 10	# sets $a1 to $a1 divide by ten
	
	add	$t0, $t0, 1	# increment by 1
	j	incre_while
incre_done:
	li	$v0, 1
	move	$a0, $s0
	syscall			# print the sum

	jr	$ra