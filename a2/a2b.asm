// CPSC - Assignment 2
// Author: Cam Davies (10174871)
// Version 2

// Define the strings
initialValues:		.string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d) \n\n"
printProduct:		.string "product = 0x%08x multiplier = 0x%08x\n"
results:		.string "64-bit result = 0x%016lx (%ld)\n"

// Define the macros
define(multiplier, w19)
define(multiplicand, w20)
define(product, w21)
define(i, w22)
define(temp1, x23)
define(temp2, x24)
define(negative, x25)
define(result, x26)
define(product64, x21)
define(multiplier64, x19)

							// Define the main function to our program
	.balign 4					// Instructions word aligned
	.global main					// Make "main" visible to the OS
main:							// Main function, code starts
	stp	x29, x30, [sp, -16]!			//
	mov	x29, sp					// Update FP to current SP (post-incr SP)
	
	mov	multiplicand, 268435455			// Give multiplicand a value
	mov	multiplier, 100				// Give multiplier a value
	mov	product, 0				// Give product a value
	mov	i, 0					// Give i a value

	adrp	x0, initialValues			// Set 1st arg of printf high
	add	x0, x0, :lo12:initialValues		// Set 2nd arg of printf low
	mov	w1, multiplier				// 
	mov	w2, multiplier				//
	mov	w3, multiplicand			//
	mov	w4, multiplicand			//
        bl      printf					// Print statement of innitial values
	
i_declaration:						// Declare i
	mov	i, 0					//
	b	test					// Jump to test
	
forloop:						// For loop
	and	w0, multiplier, 1			// 
	cmp	w0, 1					//
	b.ne	nextIf					//
	add	product, product, multiplicand		// Product = product + multiplicand

nextIf:							// If statement
	asr	multiplier, multiplier, 1		// Arithmatic shift right
	and	w1, product, 1				// and statement
	cmp	w1, 1					// compare
	b.ne	else					//
	orr	multiplier, multiplier, 0x80000000	// or statement
	b	lastPart				// jump to lastPart

else:							// Else statement for multiplier
	and	multiplier, multiplier, 0x7FFFFFFF	// and statement

lastPart:						// arith shift right for product
	asr	product, product, 1			//
	add	i, i, 1					// And increment i

test:							// Test for loop
	cmp	i, 32					// compare i < 32
	b.lt	forloop					// jump to forloop

	cmp	negative, 1				// see if multiplier is negative
	b.ne	nextPrint				// jump to print if doesn't equal
	sub	product, product, multiplicand		// subract, product = product - multiplicand

nextPrint:						// 2nd print
	adrp	x0, printProduct			// 
	add	x0, x0, :lo12:printProduct		//
	mov	w1, product				//
	mov	w2, multiplier				//
	bl	printf					//
	
	sxtw	product64, product			// Convert to 64 bit
	and	temp1, product64, 0xFFFFFFFF		//
	lsl	temp1, temp1, 32			//
	sxtw	multiplier64, multiplier		//
	and	temp2, multiplier64, 0xFFFFFFFF		//
	add	result, temp1, temp2			//

	adrp	x0, results				//
	add	x0, x0, :lo12:results			//
	mov	x1, result				//
	mov	x2, result				//
	bl	printf					//

done:	mov	w0, 0					// Restore registers and returns to calling code
	ldp	x29, x30, [sp], 16			// Restore fp and lr from stack, post-incr sp
	ret						// Return to caller:

