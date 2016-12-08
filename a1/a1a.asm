// CPSC 355 Assignment 1
// Author: Cam Davies (10174871)
// Version 2 - Macros
// Calculate the minimum of y = 5x^3 + 27x^2 - 27x - 43
// Between the values of -6 to 6


// Define the M4 macros
define(int_x, x19)				// x19: X/Loop counter register
define(int_5, x20)      	         	// x20: integer 5
define(int_27, x21)            		   	// x21: integer 27
define(d_r, x22)				// x22: integer -43
define(a_r, x23)				// x23: x*x*x*5
define(int_min, x24)              	 	// x24: integer Minimum
define(i_r, x25)	              		// x25: integer x^2
define(c_r, x26)	               		// x26: integer 27*x
define(b_r, x27)	    		        // x27: integer 27*x^2
define(int_y, x28)               		// x28: integer y
define(fp, x29)					// x29: Frame pointer
define(lr, x30)					// x30: Link register

// Define the strings
tableString:	.string "|----------------|--------------|\n"	// String to create a table
formatString:	.string "| (x,y):\t | Min Val:\t|\n"		// String for x/y/min values
xValue:		.string "| (%d,"				// String for x value
yValue:		.string "%d)  \t "				// String for y value
minValue:	.string "| %d \t\t|\n"          		// String for minimum value
totalMinValue:	.string "| Final Min:\t | %d \t\t|\n"   	// String for final minimum val$

	.balign 4                        	// Instructions must be word aligned
	.global main              		// Make "main" visible to the OS

main:	stp	fp, lr, [sp, -16]!		// Save FM / LR to stack
	mov	fp, sp				// Update FP to current SP
	
	mov	int_x, -6			// Set x19 general purpose register to 0, this will be the loop counter
	mov	int_5, 5			// Set x20 to 5
	mov	int_27, 27			// Set x21 to 27
	mov	d_r, -43			// Set x22 to -43
	mov	int_min, 2000			// Set x23 to 2000

	adrp	x0, tableString			// Set the 1st argument of printf() higher
	add	x0, x0, :lo12:tableString	// Set the 2nd argument of printf() lower
	bl	printf				// Print statement

	adrp	x0, formatString		// Set the 1st argument of printf() higher
	add	x0, x0, :lo12:formatString	// Set the 2nd argument of printf() lower
	bl	printf				// Print statement

	b	test				// Branch to test

next:						// While loop / If statement in here
	// Start of loop
	mul	b_r, int_x, int_x		// = x*x
	mul	a_r, b_r, int_x			// = x*x*x
	mul	a_r, a_r, int_5			// = 5*x*x*x
	mul	b_r, b_r, int_27		// = 27*x*x
	mul	c_r, int_x, int_27		// = 27*x

	// Calculate Y
	add int_y, a_r, b_r			// Y = 5x^3 + 27x^2
	sub int_y, int_y, c_r			// Y = 5x^3 + 27x^2 - 27x
	add int_y, int_y, d_r			// Y = 5x^3 + 27x^2 - 27x - 43


	// Print "X: "
	adrp	x0, xValue			// Set the 1st argument of printf() higher
	add	x0, x0, :lo12:xValue		// Set the 1st argument of printf() lower
	add	x1, int_x, 0			// Set the 2nd argument of printf().
	bl	printf				// Print statement

	// Print "Y: "
	adrp	x0, yValue			// Set the 1st argument of printf() higher
	add	x0, x0, :lo12:yValue		// Set the 1st argument of printf() lower
	add	x1, int_y, 0			//
	bl	printf				// Print statement
	// End of loop

	cmp	int_y, int_min			//
	b.gt	pMin				//
	mov	int_min, int_y			//

//	add	int_x, int_x, 1           	// Increment X-value by 1

pMin:	adrp	x0, minValue			// Set the 1st argument of printf() higher
	add	x0, x0, :lo12:minValue		// Set the 1st argument of printf() lower
	add	x1, int_min, 0			//
	bl	printf				// Print statement
	add	int_x, int_x, 1			// Increment x by 1

test:	cmp	int_x, 6			// Stop while loop when x <= 6
	b.le	next                         	// If x <= 6, exit loop and branch to "done"

done:	mov	w0, 0				// Returns 0 to main
        adrp    x0, tableString			//
        add     x0, x0, :lo12:tableString	//
        bl	printf				//

        adrp    x0, totalMinValue		// Set the 1st arg of printf Higher
        add     x0, x0, :lo12:totalMinValue	// Set the 1st arg of printf Lower
        add     x1, int_min, 0			// Set the 2nd arg of printf
        bl	printf                          // Print statement

	adrp	x0, tableString			//
	add	x0, x0, :lo12:tableString	//
	bl	printf				//

	ldp  fp, lr, [sp], 16            	// Restore fp and lr from stack, post-increment sp
	ret                              	// Return to caller
