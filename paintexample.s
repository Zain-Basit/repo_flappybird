# Demo for painting
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.data
	displayAddress:	.word	0x10008000
.text
	lw $t0, displayAddress	# $t0 stores the base address for display
	li $t1, 0xff0000	# $t1 stores the red colour code
	li $t2, 0x00ff00	# $t2 stores the green colour code
	li $t3, 0x0000ff	# $t3 stores the blue colour code
	
	sw $t1, 0($t0)	 # paint the first (top-left) unit red. 
	sw $t2, 4($t0)	 # paint the second unit on the first row green. Why $t0+4?
	sw $t3, 128($t0) # paint the first unit on the second row blue. Why +128?
	
	# Extra Stuff I've added to this started code to learn more - Zain
	
	LOOPINIT:
		li $t4, 0xae00ff # Storing the color purple
		li $t5, 0        # for i <= 128,  
		li $t6, 128      # 4094 will paint exactly the whole screen
	FOR:    # This should paint the first row, so pixel 0-31, and the pixel in row 2 (pixel 32)
		bgt $t5, $t6, END
		
		sw $t4, 0($t0)
		
		addi $t0, $t0, 4
		addi $t5, $t5, 4
		
		j FOR
	
	END:
	
Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
