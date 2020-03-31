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
	
BACKINIT: # Painting the background
	li $t4, 0    # i = 0
	li $t5, 4096 # i <= 4096 will paint the entire background 
BACKFOR:
	bgt $t4, $t5, BACKEND # If i > 4096, then we jump to the end of this for loop
		
	sw $t1, 0($t0) # Changing the color at this pixel to the background color in $t1
		
	addi $t0, $t0, 4 # Increment the base by an offset of 4
	addi $t4, $t4, 4 # Increment the counter
		
	j BACKFOR
BACKEND:
			
	# We need to reset the offset value, by loading in the displayAddress again, since we've incremented it by 4096, or 0x00001000 (In Hex)
	lw $t0, displayAddress
	
BIRDINIT: # Painting the bird
BIRDFOR:
BIRDEND:
	
	
PIPEINIT: # Painting the pipe
PIPEFOR:
PIPEEND:
	
                    
