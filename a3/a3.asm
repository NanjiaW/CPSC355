// Author: Cameron Davies (10174871)
// Assignment 3 - Cpsc 355

arrayP: .string "v[%d]: %d\n"                   // Used to print out "v[#]: #"
sorted: .string "\nSorted array: \n"            // Used to print out "Sorted array: "

define(i, w19)                                  // Used for loops
define(random, w20)                             // Used for loops
define(j, w22)                                  // Used for loops
define(jmin, w24)                               // j-1, used for loops
define(temp, w25)                               // temp value

size = 40                                       // Size of the array
arraybase = 16                                  // Base address of the array
indexi = 176                                    // index i 
indexj = 180                                    // index j
temp_s = -4                                     // Temp index
alloc = -(16 + 8 + 160) & -16                   // Allocate
dealloc = -alloc                                // Deallocate

fp  .req x29                                    // Similar to using macros
lr  .req x30                                    // .req is Register?

    .balign 4                                   // Align text
    .global main                                // Make visible to OS
main:                                           // Main. Innitializes i to 0
    stp     x29, x30, [sp, alloc]!              // Allocating
    mov     fp, sp                              // Sane as mov x29, sp
    add     x28, fp, arraybase                  // Calculate arraybase address

    mov     i, 0                                // Initialize index to stack
    str     i, [fp, indexi]                     // Write index i to stack
    b       test1                               // Branch to optimized pre-test

loop1:                                          // Generate random arrays
    bl      rand                                // Generate the random number
    ldr     i, [fp, indexi]                     // Read index i from stack
    and     random, w0, 0xFF                    // Rand() & 0xFF
    str     random, [x28, i, SXTW 2]            // Write random to array

    adrp    x0, arrayP                          // Print array
    add     w0, w0, :lo12:arrayP                // Print
    mov     w1, i                               // Print
    mov     w2, random                          // Print
    bl      printf                              // Print

    add     i, i, 1                             // i++
    str     i, [fp, indexi]                     // Write index i to stack

test1:                                          // Tests if i < 40, then branch to test2
    cmp     i, size                             // If i < 40
    b.lt    loop1                               // ....do loop

    mov     i, size                             // Write i to 40
    sub     i, i, 1                             // i--
    str     i, [fp, indexi]                     // Write index i to stack
    b       test2                               // Branch to test2

loop2:                                          // Sorts the arrays
    ldr     w23, [x28, j, SXTW 2]               // Read w23 from array
    sub     jmin, j, 1                          // jmin = j - 1
    ldr     random, [x28, jmin, SXTW 2]         // Read random from array
    cmp     random, w23                         // if random < w23
    b.le    next                                // Branch to next 

    add     sp, sp, -4 & -16                    //
    mov     temp, random                        //
    str     temp, [x29, temp_s]                 // Write temp to stack
    mov     random, w23                         // Write random = w23
    str     random, [x28, jmin, SXTW 2]         // Write random to array
    mov     w23, temp                           // w23 = temp
    str     w23, [x28, j, SXTW 2]               // Write w23 to array
    add     sp, sp, 16                          // sp = sp + 16

next:                                           // Simply increments j
    add     j, j, 1                             // j++

test3:                                          // Test for the nested for loop in c
    cmp     j, i                                // if j <= i
    b.le    loop2                               // ... branch to loop2

    sub     i, i, 1                             // i--

test2:                                          // Innitializes j to 1 before the sorting process
    mov     j, 1                                // j = 1
    str     j, [fp, indexj]                     // Write index j to stack

    cmp     i, 0                                // if i >= 0
    b.ge    test3                               // ... branch to test3

    mov     i, 0                                // i = 0
    str     i, [fp, indexi]                     // Write index i to stack

    adrp    x0, sorted                          // Print sorted
    add     w0, w0, :lo12:sorted                // print 
    mov     w1, 0                               // print 
    bl      printf                              // print 
    b       printTest                           // Branch to loopPr

printLoop:                                      // Loops 40x and prints the sorted arrays
    ldr     w26, [x28, i, SXTW 2]               //      
    adrp    x0, arrayP                          // Print arrayP string
    add     w0, w0, :lo12:arrayP                // print
    mov     w1, i                               // print 
    mov     w2, w26                             // print 
    bl      printf                              // print 
    add     i, i, 1                             // i ++

printTest:                                      // Test for the printloop
    cmp     i, size                             // if i < size
    b.lt    printLoop                           // ... branch to print

done:
    mov     w0, 0                               // Return 0 to OS
    ldp     fp, lr, [sp], dealloc               // Deallocate stack memory
    ret                                         // Return to calling code in OS
