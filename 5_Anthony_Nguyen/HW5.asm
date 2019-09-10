.data
promptCircles:	.asciiz "How many round  pizzas: "
inputCircles: 	.word 0
promptSquares:	.asciiz "How many square pizzas: "
inputSquares:	.word 0
promptEstimate:	.asciiz "Estimate for total pizzas sold today in sq. feet: "
inputEstimate:	.word 0
circle:		.asciiz "Total area in sq. feet of round pizzas: "
square:		.asciiz "\nTotal area in sq. feet of square pizzas: "
sumQuery:	.asciiz "\nTotal ACTUAL sq. feet of both round and square pizzas: "
yeah:		.asciiz "\nYeah!"
bummer:	.asciiz "\nBummer!"
pi:		.float 3.1415
fp1:		.float 16		# circle
fp2:		.float 100	# square
fp3:		.float 144
.text
main:
	# Prompt the user and read input
	li	$v0, 4		# circle pizza
	la	$a0, promptCircles
	syscall
	li	$v0, 5
	syscall
	move	$t0, $v0		# $t0 contains input for circles
	sw	$v0, inputCircles
	
	li	$v0, 4		# square pizza
	la	$a0, promptSquares
	syscall
	li	$v0, 5
	syscall
	move	$t1, $v0		# $t1 contains input for squares
	sw	$v0, inputSquares
	
	li	$v0, 4		# estimate of total area of all pizzas sold
	la	$a0, promptEstimate
	syscall
	li	$v0, 6
	syscall
	mfc1	$t2, $f0		# $t2 contains input for estimate
	sw	$v0, inputEstimate
	
	# calculate area of all pizzas sold separately
	l.s 	$f13, fp1	# $f13 = 16
	l.s 	$f14, fp3	# $f14 = 144
	div.s	$f13, $f13, $f14	# 16/144
	l.s	$f14, pi		# $f14 = 3.1415
	mul.s	$f0, $f13, $f14	# $f0 contains the area of a single circle pizza
	
	mtc1 	$t0, $f10
	cvt.s.w	$f10, $f10	# input conversion
	mul.s	$f1, $f0, $f10	# $f1 contains total square feet of circle pizzas
	
	li	$v0, 4
	la 	$a0, circle
	syscall
	li	$v0, 2
	mov.s	$f12, $f1
	syscall			# prints total square area of all round pizzas
	
	
	l.s	$f13, fp2	# $f13 = 100
	l.s 	$f14, fp3	# $f14 = 144
	div.s	$f13, $f13, $f14	# 100/144
	
	mtc1	$t1, $f10
	cvt.s.w	$f10, $f10	# input conversion
	mul.s	$f2, $f13, $f10	# $f2 contains total square feet of square pizzas
	
	li	$v0, 4
	la	$a0, square
	syscall
	li	$v0, 2
	mov.s	$f12, $f2
	syscall			# prints total square feet of all square pizzas
	
	# sum the areas together
	add.s	$f3, $f1, $f2	# $f3 = actual sum
	
	li	$v0, 4
	la	$a0, sumQuery
	syscall
	li	$v0, 2
	mov.s	$f12, $f3
	syscall			# prints the sum
	
	# compare estimate with actual
	mtc1	$t2, $f9		# $f9 contains estimate input
	#cvt.s.w	$f9, $f9		# input conversion
	
	c.le.s	$f9, $f3		# compare estimate <= actual
	bc1t	true

false:	
	li	$v0, 4
	la	$a0, bummer
	syscall			# prints Bummer!
	j	exit
	
true:	
	li	$v0, 4
	la	$a0, yeah
	syscall			# prints Yeah!
	
exit:	li	$v0, 10
	syscall