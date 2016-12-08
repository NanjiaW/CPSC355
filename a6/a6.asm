// Assignment 6 - December 6th
// Cameron Davies - 10174871

define(fd, w19)                                             // File descriptor
define(n_read, x20)                                         // Number of bytes read
define(buf_base, x21)                                       // Buf base

buf_size = 8                                                // Size of the buffer
alloc = -(16 + buf_size) & -16                              // Allocation
dealloc = -alloc                                            // Deallocation
buf_s = 16                                                  // Not even sure tbh
increment = 1                                               // Increment by 1

power           .req    d19                                 // Exponent/Power
numerator       .req    d20                                 // Numerator (x^n)
factor          .req    d21                                 // Factorial (n!)
term            .req    d22                                 // term = numerator/denominator
accumulator     .req    d23                                 // accumulator = 1 + term + term + ...
incr            .req    d24                                 // increment = 1.0
                
constant:       .double 0r1.0e-10                           // Constant value

pn:     .string "input.bin"                                 // Name of the input file
header: .string "Input:\t\te^x:\t\te^-x:\n"                 // Header of output columns
values: .string "%13.10f\t%13.10f  \t%13.10f\n"             // Values of output columns
error:  .string "Error :("                                  // Error :(

        .global main                                        // Make main a global function
        .balign 4                                           // Word align
main:                                                       // Allocate, open file, print table header
    stp x29, x30, [sp, alloc]!                              // Allocate
    mov x29, sp                                             // FP = SP

    adrp    x0, header                                      // Print header
    add x0, x0, :lo12:header                                // ^
    bl  printf                                              // ^

    // Open the file
    mov w0, -100                                            // 1st arg: cwd
    adrp    x1, pn                                          // 2nd arg: pathname
    add x1, x1, :lo12:pn                                    // ^
    mov w2, 0                                               // 3rd arg: read-only
    mov w3, 0                                               // 4th arg: n/a
    mov w8, 56                                              // Openat I/O Req
    svc 0                                                   // Call system function
    mov fd, w0                                              // Record the file descriptor

    // Error checking (if doesn't open properly)
    cmp fd, 0                                               // Error check. If file open successfully:
    b.ge    openok                                          // ... branch to openok

    // If there's an error:
    adrp    x0, error                                       // Only happens if file doesnt open
    add x0, x0, :lo12:error                                 // ^
    bl  printf                                              // ^
    mov w0, -1                                              // Return -1 to OS
    b   done                                                // Exit the program

openok:                                                     // If it does open succesfully
    add buf_base, x29, buf_s                                // buf_base now equals FP + buf_s

top:
    // Read the file
    mov w0, fd                                              // 1st arg: fd
    mov x1, buf_base                                        // 2nd arg: buf
    mov w2, buf_size                                        // 3rd arg: n
    mov x8, 63                                              // Read I/O Req (code: 63)
    svc 0                                                   // Call system function
    mov n_read, x0                                          // # of bytes read

    // Error checking if read properly
    cmp n_read, buf_size                                    // If nread =/= 8
    b.ne    endFile                                         // ... exit 

    // Calculate e^x:
    ldr d0, [buf_base]                                      // d0 = x
    bl exponent                                             // Calculate e^x
    fmov    d1, d0                                          // 2nd arg: e^x

    // Calculate e^-x
    ldr d0, [buf_base]                                      // d0 = x
    fneg    d0, d0                                          // d0 = -x
    bl  exponent                                            // Calculate e^-x
    fmov    d2, d0                                          // 3rd arg: e^-x
    
    // Print out the values
    adrp    x0, values                                      // Print values
    add x0, x0, :lo12:values                                // ^
    ldr d0, [buf_base]                                      // 1st arg: input
    bl  printf                                              // Print the values

    b   top                                                 // Loop all 100 times

endFile:                                                    // Close the binary file
    mov w0, fd                                              // 1st arg: fd
    mov x8, 57                                              // Close I/O request
    svc 0                                                   // Call system function
    mov w0, 0                                               // Return 0 to OS

done:
    ldp x29, x30, [sp], dealloc                             // Deallocate
    ret                                                     // Return to calling code

            .balign 4                                       // Align by 4
            .global exponent                                // Make exponent a global
exponent:
    stp x29, x30, [sp, -16]!                                // Allocate memory
    mov x29, sp                                             // fp = sp

    adrp    x22, constant                                   // Load constant
    add x22, x22, :lo12:constant                            // ^
    ldr d3, [x22]                                           // d3 = constant
    
    fmov    power, 1.0                                      // power = 1.0
    fmov    incr, 1.0                                       // incr = 1.0
    fmov    accumulator, 1.0                                // accumulator = 1.0

    fmov    numerator, d0                                   // numerator = x
    fmov    factor, power                                   // denominator = power
    fdiv    term, numerator, factor                         // term = numerator / factor
    fadd    accumulator, accumulator, term                  // accumulator += term

loop:                                                       // Loop for number
    fmul    numerator, numerator, d0                        // numerator = numerator * x
    fadd    power, power, incr                              // power += 1
    fmul    factor, factor, power                           // factor = factor * power
    fdiv    term, numerator, factor                         // term = numerator / factor
    fadd    accumulator, accumulator, term                  // accumulator += term

    fabs    term, term                                      // term = |term|
    fcmp    term, d3                                        // if term >= constant:
    b.ge    loop                                            // ... do loop

    fmov    d0, accumulator                                 // d0 = accumulator
    ldp x29, x30, [sp], 16                                  // Deallocate memory
    ret                                                     // Return to caller

