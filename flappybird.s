#####################################################################
#
# CSC258H5S Winter 2020 Assembly Programming Project
# University of Toronto Mississauga
#
# Group members:
# - Student 1: Syed Zain Basit, 1004900752
# - Student 2: Alex Ng, Student Number
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
# - Completed Milestone 1 on April 5, 2020
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
	
.text

	lw $t0, displayAddress	# Loading in the address of the first pixel in the display	
	li $t1, 0x4287f5 # Colour of the Background: #4287f5, a blue colour
	li $t2, 0xff00f7 # Colour of the Bird: #ff00f7, a pink colour
	li $t3, 0x08a300 # Colour of the Pipe: #08a300, a green colour
	
	jal PAINTBACK # This function paints the background the above color
			
	# We need to reset the offset value, by loading in the displayAddress again, since we've incremented it by 4096, or 0x00001000 (In Hex)
	lw $t0, displayAddress
	
	# Painting the bird
	# First we need to set a0 to the offset where we want part 0 of the part to be located
	lw $a0, displayAddress
	addi $a0, $a0, 772 # This will print on the second pixel of the sixth row
	
	jal PAINTBIRD # Calling the PAINTBIRD Function
	
	# Now we need to paint the pipe, which requires a random integer for the height, and an offset for the center of the pipe	
	jal RANDOMINT # Generating a random integer to use as the height of the thing, which is stored in $a0 after RANDOMINT returns
	li $a1, 116
	
	jal PAINTPIPE
	
	
EXIT:
	li $v0, 10 # Ending the program gracefully
	syscall
	
PAINTBACK: # This is a function to paint the background

	BACKINIT: # Painting the background
		li $t4, 0    # i = 0
		li $t5, 4092 # i <= 4096 will paint the entire background 
	BACKFOR:
		bgt $t4, $t5, BACKEND # If i > 4096, then we jump to the end of this for loop
		
		sw $t1, 0($t0) # Changing the color at this pixel to the background color in $t1
		
		addi $t0, $t0, 4 # Increment the base by an offset of 4
		addi $t4, $t4, 4 # Increment the counter
		
		j BACKFOR # Looping again
	BACKEND:
		jr $ra # Going back to the calling address

	
PAINTBIRD: # This is a function that paints a bird at a given height offset ($a0)
	   # The offset passed in should be the location of the TOP-LEFT MOST piece of the bird
	    
	sw $t2, 0($a0)   # Painting the bird part 0 
	sw $t2, 8($a0)   # Painting the bird part 1
	sw $t2, 128($a0) # Painting the bird part 2
	sw $t2, 132($a0) # Painting the bird part 3
	sw $t2, 136($a0) # Painting the bird part 4
	sw $t2, 140($a0) # Painting the bird part 5
	sw $t2, 256($a0) # Painting the bird part 6
	sw $t2, 260($a0) # Painting the bird part 7 
	sw $t2, 264($a0) # Painting the bird part 8
		   
	jr $ra # Returning to the calling address
	   
RANDOMINT: # This is a function that sets $v0 to a random integer generated between LOWERBOUND and UPPERBOUND
	
	li $a1, 21 # The Maximum Upperbound on the rows we can have
	li $v0, 42 # The syscall to generate a random integer between 0 and 21
	syscall
	
	# Now the random value is in $a0, so we need to make sure it is within 6 and 21
	bge $a0, 6, RANDRET # If it's greater than or equal to 6, we return
	addi $a0, $a0, 6 
	
	RANDRET:
		jr $ra # Returning to the calling address

PAINTPIPE: # This is a function that paints a pipe with a given height ($a0) for the gap between the pipes, and an offset value for
	   # the center of the pipe ($a1)
	   
	   # So we need to paint a pipe of width 5, and that covers the entire vertical section of that width, except in an area
	   # of length 8, which is where there is a gap for the bird to pass through.
	   
	   PIPEINIT:
	   	li $t8, 0 # i = 0, this is so we can count how many lines in the gap we've skipped
	   	
	   	lw $t9, displayAddress
	   	add $t9, $t9, $a1 # Storing the centre "x" coord of the pipe in $t9
	   
	   	li $t7, 128   # A temp holder for 128 so we can calculate what row we are in. 
	   	mult $a0, $t7 
	   	mflo $t7
	   	
	   	# Calculate the "x" value of the pillar
	   	add $t7, $t7, $a1 # After this offset, the gap begins
	   	
	   	lw $s0, displayAddress
	   	add $s0, $s0, $t7
	   	
	   	lw $s1, displayAddress
	   	add $s1, $s1, $a1
	   	addi $s1, $s1, 3968 # This makes $s0 the last possible pixel in the pipe, at the bottom of the screen.
		
		# Working values
		# $s0 - The address where the gaps start
		# $s1 - The address of the bottom of the pipe
		# $t8 - The counter for how many rows have been skipped
		# $t9 - The offset of the middle of the pipe
		
	   PIPELOOP:
	   	
	   	bne $t9, $s0, PIPEROW # We check if we are at the $t0 address, if not, we paint a row and increment the offset in $t9 & $s0
	   	bge $t8, 8, PIPEROW
	   	
	   	# If we are at the $t7 address, we need to skip an iteration, so we must increment the counter once and continue
	   	addi $t8, $t8, 1   # Incrementing the gap counter
	   	addi $t9, $t9, 128 # Incrementing the middle index to the next point
	   	addi $s0, $s0, 128 # Incrementing the "gap catch"
	   	
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
	   
	   
