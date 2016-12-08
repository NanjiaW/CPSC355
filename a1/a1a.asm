// CPSC 355 Assignment 1
// Author: Cam Davies (10174871)
// Version 1 - no macros
// Calculate minimum of y = 5x^3 + 27x^2 - 27x - 43
// Between the values of -6 to 6

// Define the strings
tableString:	.string "|----------------|--------------|\n"
formatString:	.string "| (x,y):\t | Min Val:\t|\n"
xValue:			.string "| (%d,"			// String for x value
yValue:			.string "%d)  \t "			// String for y value
minValue:		.string "| %d \t\t|\n"			// String for minimum value
totalMinValue:	.string "| Final Min:\t | %d \t\t|\n"	// String for final minimum value

	// Define main function for the program
	.balign 4				// Instructions to be word aligned
	.global main				// make main visible to OS

main: stp x29, x30, [sp, -16]!
	mov x29, sp				// update FP to current SP
	mov x19, -6				// x19: 'x', loop counter, set to -6 at first
	mov x20, 5				// x20: integer 5
	mov x21, 27				// x21: integer 27
	mov x22, -43			// x22: integer 43
							// x23: x^3
							// x24: N/A
							// x25: x^2
							// x26: 27*x
							// x27: 27*x^2
							// x28: Y
	mov x29, 2000				// x29: Min

       	adrp    x0, tableString			//Print table
       	add     x0, x0, :lo12:tableString
       	bl      printf

	adrp	x0, formatString		//Print table
	add	x0, x0, :lo12:formatString
	bl	printf

	// The while loop Test
test: cmp x19, 6				// compare loop counter (x19) and 6
	b.gt done				// If x19 > 6, exit loop and branch to "done"

	// Start of loop:

	// Calculate Y =  5x^3 + 27x^2 - 27x - 43
	// Calculate 5x^3, 5*x*x*x
	mul x25, x19, x19			// x25 = x^2 = x*x
	mul x23, x25, x19			// x23 = x^3 = x^2*x
	mul x23, x23, x20			// x24 = 5*x^3

	// Calculate 27x^2, 27*x*x
	mul x27, x21, x25			// x27: 27*x^2

	// Calculate 27x
	mul x26, x19, x21			// x26: 27*x

	// Calculate Y
	add x28, x23, x27			// x28 = Y = 5*(x^3) + 27*(x^2)
	sub x28, x28, x26			// x28 = Y = 5*(x^3) + 27*(x^2) - 27*x
	add x28, x28, x22			// x28 = Y = 5*(x^3) + 27*(x^2) - 27*x - 43

	//Print "X: "
	adrp	x0, xValue			// Set the 1st arg of printf (higher-order bits)
	add	x0, x0, :lo12:xValue		// Set the 1st arg of printf (lower 12 bits)
	add	x1, x19, 0			// Set the 2nd arg of printf
	bl	printf				// Print statement

	//Print "Y: "
	adrp	x0, yValue			// Set the 1st arg of print Higher
	add	x0, x0, :lo12:yValue		// Set the 1st arg of printf Lower
	add	x1, x28, 0			// Set the 2nd arg of printf
	bl	printf				// Print statement

	// If statement.
	cmp	x28, x29			// If Y < min, execute
	b.gt	next				// Pass to next statement
	mov	x29, x28			// Set the min equal to the new minimum value

next:
	//Print "Min: "
	adrp	x0, minValue			// Set the 1st arg of printf Higher
	add	x0, x0, :lo12:minValue		// Set the 1st arg of print Lower
	add	x1, x29, 0			// Set the 2nd arg of printf
	bl	printf				// Print statement

	// End of loop
	add	x19, x19, 1			// Increment x19 by 1 (x++)
	b	test				// Branch to test

done:	mov	w0, 0				//??

        adrp    x0, tableString			//print table
        add     x0, x0, :lo12:tableString
        bl	printf

	adrp	x0, totalMinValue		// Set the 1st arg of printf Higher
	add	x0, x0, :lo12:totalMinValue	// Set the 1st arg of printf Lower
	add	x1, x29, 0			// Set the 2nd arg of printf
	bl	printf				// Print statement

        adrp    x0, tableString			//print table
        add     x0, x0, :lo12:tableString
        bl	printf

	// Restore registers and return calling code
	ldp	x29, x30, [sp], 16		// Restore FP and LR from stack
	ret					// Return to caller

