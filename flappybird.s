#####################################################################
#
# CSC258H5S Winter 2020 Assembly Programming Project
# University of Toronto Mississauga
#
# Group members:
# - Student 1: Syed Zain Basit, 1004900752
# - Student 2: Alex Ng, 1005223642
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
# - Completed Milestone 1 on April 1, 2020
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.data
	displayAddress: .word 0x10008000
	
	#backgroundColour: .word 0x4287f5 # Having these here may be pointless, so might have to remove them
	#birdColour: .word 0xff00f7
	#pipeColour: .word 0x08a300
	pipeValues: .space 280 # An array of the addresses of the pipe walls, which cannot be touched
	groundValue: .word 0x10008e84 # The memory address of the ground, if the bird touches this, the game ends.
	lowestPipeValue: .word 0x10008008
	keyPressed: .word 0xffff0000
	keyValue: .word 0xffff0004
	fAscii: .word 102
	
.text

	GAMEINIT:
		lw $t0, displayAddress	# Loading in the address of the first pixel in the display	
		li $t1, 0x4287f5 # Colour of the Background: #4287f5, a blue colour
		li $t2, 0xff00f7 # Colour of the Bird: #ff00f7, a pink colour
		li $t3, 0x08a300 # Colour of the Pipe: #08a300, a green colour
		lw $s4, lowestPipeValue
	
		jal PAINTBACK # This function paints the background the above color
			
		# We need to reset the offset value, by loading in the displayAddress again, since we've incremented it by 4096, or 0x00001000 (In Hex)
		lw $t0, displayAddress
	
		# Painting the bird
		# First we need to set a2 to the offset where we want part 0 of the part to be located
		lw $a2, displayAddress
		addi $a2, $a2, 788 # This will print on the second pixel of the sixth row
		jal PAINTBIRD # Calling the PAINTBIRD Function		
		
		# Now we need to paint the pipe, which requires a random integer for the height, and an offset for the center of the pipe	
		jal RANDOMINT # Generating a random integer to use as the height of the thing, which is stored in $s3 after RANDOMINT returns
		lw $a1, displayAddress
		addi $a1, $a1, 116
	
		jal PAINTPIPE
		
		lw $s6, displayAddress # This is the lowest possible value the bird can go, at this point, it is "touching" the ground
		addi $s6, $s6, 3732    # which is lethal and ends the game.
		
		lw $s7, displayAddress # The roof
		addi $s7, $s7, 20
		#j EXIT
		
	GAMELOOP:
	
		# Check if the bird has reached the ground/roof, if so jump to EXIT
		beq $a2, $s6, EXIT
		beq $a2, $s7, EXIT		
		
		# Check if the bird has hit the pipe, if so jump to EXIT
		jal HITBOXCHECK
		
		# Check if the pipe has reached the leftmost index it can go to (displayAddress+8), if so, make a new pipe
		bne $a1, $s4, PIPEMOVE 
		
		jal RANDOMINT # Creating a new random height
		lw $a1, displayAddress
		addi $a1, $a1, 116
		
		#addi $a1, $a1, 108 # Moving the pipe back to its starting location
		
	PIPEMOVE:
	
		jal PAINTBACK
	
		addi $a1, $a1, -4 # Moving the pipe one pixel to the left
		jal PAINTPIPE
		
		# Decrementing the bird's position
		addi $a2, $a2, 128
		jal PAINTBIRD
		
		jal BIRDJUMP
		
		# Sleeping the thread before going to the next iteration
		li $v0, 32
		li $a0, 250
		syscall
	
		j GAMELOOP # Going to the next iteration
	
EXIT:	
	# If the code jumps here, we clear the pipes and bird off the screen and print a BYE statement. Then the game terminates.
	#jal PAINTBACK
	
	# Need some code for printing BYE
	
	li $v0, 10 # Ending the program gracefully
	syscall
	
PAINTBACK: # This is a function to paint the background, usies $t0, $t1, $t4, $t5

	BACKINIT: # Painting the background
		li $t4, 0    # i = 0
		li $t5, 4092 # i <= 4092 will paint the entire background 
	BACKFOR:
		bgt $t4, $t5, BACKEND # If i > 4096, then we jump to the end of this for loop
		
		sw $t1, 0($t0) # Changing the color at this pixel to the background color in $t1
		
		addi $t0, $t0, 4 # Increment the base by an offset of 4
		addi $t4, $t4, 4 # Increment the counter
		
		j BACKFOR # Looping again
	BACKEND:
		lw $t0, displayAddress # Resetting the value of $t0 for whenever this function is used again
		jr $ra 	# Going back to the calling address

	
PAINTBIRD: # This is a function that paints a bird at a given height offset ($a2)
	   # The offset passed in should be the location of the TOP-LEFT MOST piece of the bird (part 0)
	   # Uses $t2, $a2
	    
	sw $t2, 0($a2)   # Painting the bird part 0 
	sw $t2, 8($a2)   # 1
	sw $t2, 128($a2) # 2 
	sw $t2, 132($a2) # 3
	sw $t2, 136($a2) # 4
	sw $t2, 140($a2) # 5
	sw $t2, 256($a2) # 6
	sw $t2, 260($a2) # 7 
	sw $t2, 264($a2) # 8
		   
	jr $ra # Returning to the calling address
	   
RANDOMINT: # This is a function that sets $s3 to a random integer generated between LOWERBOUND and UPPERBOUND
	   # Uses $a1, $v0, $a0, $s3
	
	li $a1, 21 # The Maximum Upperbound on the rows we can have
	li $v0, 42 # The syscall to generate a random integer between 0 and 21
	syscall
	
	# Now the random value is in $a0, so we need to make sure it is within 6 and 21
	move $s3, $a0
	bge $s3, 6, RANDRET # If it's greater than or equal to 6, we return
	addi $s3, $s3, 6 

	RANDRET:
		jr $ra # Returning to the calling address

PAINTPIPE: # This is a function that paints a pipe with a given height ($s3) for the gap between the pipes, and an offset value for
	   # the center of the pipe ($a1)
	   
	   # So we need to paint a pipe of width 5, and that covers the entire vertical section of that width, except in an area
	   # of length 8, which is where there is a gap for the bird to pass through.
	   
	   PIPEINIT:
	   	li $t8, 0 # i = 0, this is so we can count how many lines in the gap we've skipped
	   	
	   	move $t9, $a1 # Has address of the middle of the pipe (x coord) 

	   	li $t7, 128   # A temp holder for 128 so we can calculate what row the gap begins in
	   	mult $s3, $t7 
	   	mflo $t7
	   	
	   	# Calculate the "x" value of the pillar
	   	add $t7, $t7, $a1 # After this offset, the gap begins
		
		move $s1, $a1
		addi $s1, $s1, 3968
		
		# Working values
		# $t7 - The address right before the gap starting
		# $s1 - The address of the bottom of the pipe
		# $t8 - The counter for how many rows have been skipped
		# $t9 - The offset of the middle of the pipe
		
	   PIPELOOP:
	   	
	   	bne $t9, $t7, PIPEROW # We check if we are at the $t7 address, if not, we paint a row and increment the offset in $t9 & $s0
	   	bge $t8, 8, PIPEROW
	   	
	   	# If we are at the $t7 address, we need to skip an iteration, so we must increment the counter once and continue
	   	addi $t8, $t8, 1   # Incrementing the gap counter
	   	addi $t9, $t9, 128 # Incrementing the middle index to the next point
	   	addi $t7, $t7, 128 # Incrementing the "gap catch"
	   	
	   	j PIPELOOP # Looping again
	   	
	   PIPEROW:
	   	
	   	sw $t3, -8($t9) # Leftmost Pixels
	   	sw $t3, -4($t9)
	   	sw $t3, 0($t9) # Painting the middle pixel
	   	sw $t3, 4($t9)
	   	sw $t3, 8($t9) # Rightmost Pixels
	   
	   	beq $t9, $s1, PIPEEND # If the offset in t9 is equal to the last possible value, then we end.
	   
	   	# Now we increment $t9 once
	   	addi $t9, $t9, 128
	   	
	   	j PIPELOOP # Looping back to the start
	   
	   PIPEEND:
	   
	   	jr $ra # Returning to the calling point of the function
	   	
HITBOXCHECK: # This function checks if the bird has hit the pipe, if so, the bird dies, and the game ends
		
		# Need to check above part 0
		#lw $s2, -128($a2)
		#beq $t3, $s2, EXIT	
		
		# Checking above part 1
		#lw $s2, -120($a2)
		#beq $t3, $s2, EXIT
		
		# Check to the right of part 1
		#lw $s2, 12($a2)
	   	#beq $t3, $s2, EXIT
	   	
	   	lw $s2, 0($a2)
  		beq $t3, $s2, EXIT
  	
  		lw $s2, 8($a2)
  		beq $t3, $s2, EXIT
		
		# Check to the right of part 5
	   	lw $s2, 144($a2)
		beq $t3, $s2, EXIT
		
		# Check below part 5
	   	lw $s2, 268($a2)
		beq $t3, $s2, EXIT
		
		# Check below part 6
		lw $s2, 384($a2)
		beq $t3, $s2, EXIT
		
		# Check below part 8
	   	lw $s2, 392($a2)
		beq $t3, $s2, EXIT
		
		jr $ra
		
BIRDJUMP: # This function checks if the f key has been pressed, and then it makes the bird go up +1 unit

	lw $s2, keyPressed
	lw $s2, 0($s2)
	# If s2 is 0, we do nothing, if s2 is not zero AND EQUAL to 102, we increment a2
	
	beqz $s2, NOJUMP # If equal to 0, we do nothing and return
	
	lw $s2, keyValue
	lw $s2, 0($s2)
	
	bne $s2, 102, NOJUMP
	
	addi $a2, $a2, -256
	
	NOJUMP:
		jr $ra
