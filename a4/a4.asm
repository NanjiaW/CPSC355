// CPSC 355 Assignment 4
// Cameron Davies - 10174871

intlval:    .string "\n Initial sphere value:\n"
chngval:    .string "\n Changed sphere values:\n"
sphereStr:  .string "Sphere %s origin \ (%d, %d, %d) Radius = %d \n"
first:      .string "First"
second:     .string "Second"

// Declare sizes/Allocation
FALSE = 0                                   // True and false used to determine if the spheres are equal             
TRUE = 1                                    // Same ^     
allocA = -(16 + 2*16) & -16                 // Main alloc
deallocA = -allocA                          // Main dealloc
firstSphere = 16                            // First sphere size
secondSphere = 32                           // Second sphere size
base = 16                                   // Base size

// Start of functions
    .balign 4                               // Alligns text
    .global main                            // Make vis to os
main:                                       // Define main
    stp     x29, x30, [sp, allocA]!         // Allocating
    mov     x29, sp                         // sp = fp

    mov     x8, 0                           // Make x8 = 0
    add     x8, x29, firstSphere            // x8 = fp + firstSphere
    bl      newSphere                       // call newSphere

    mov     x8, 0                           // Make x8 = 0
    add     x8, x29, secondSphere           // x8 = fp + secondSphere
    bl      newSphere                       // call newSphere

    adrp    x0, intlval                     // Print initial sphere value
    add     x0, x0, :lo12:intlval           // Same ^
    bl      printf                          // Same ^

    adrp    x0, first                       // Set up to print the sphere info
    add     x0, x0, :lo12:first             // Lower 12 bits
    mov     x1, x29                         // x1 = x29
    add     x1, x1, firstSphere             // x1 = fp + firstSphere
    bl      printSphere                     // call printSphere 

    adrp    x0, second                      // Set up to print the sphere info
    add     x0, x0, :lo12:second            // Lower 12 bits
    mov     x1, x29                         // x1 = x29 (fp)
    add     x1, x1, secondSphere            // x1 = fp + secondSphere
    bl      printSphere                     // call printSphere

    mov     x0, 0                           // x0 = 0
    mov     x1, 0                           // x1 = 0/
    add     x0, x29, firstSphere            // x0 = fp + firstSphere
    add     x1, x29, secondSphere           // x1 = fp + secondSphere
    bl      equal                           // branch to equal

    cmp     w0, TRUE                        // if w0 = true (1)
    b.ne    jump                            // ... Branch to jump

    mov     x0, 0                           // x0 = 0
    add     x0, x29, firstSphere            // x0 = fp + firstSphere
    mov     w1, -5                          // delta x
    mov     w2, 3                           // delta y 
    mov     w3, 2                           // delta z 
    bl      move                            // branch to move 

    mov     x0, 0                           // x0 = 0
    add     x0, x29, secondSphere           // x0 = fp + secondSphere
    mov     w1, 8                           // w1 = 8
    bl      expand                          // Branch to expand 

jump:
    adrp    x0, chngval                     // Print change value 
    add     x0, x0, :lo12:chngval           // Print lower order
    bl      printf                          // print

    adrp    x0, first                       // Print sphere info
    add     x0, x0, :lo12:first             // low order
    mov     x1, x29                         // x1 = x29
    add     x1, x1, firstSphere             // x1 = x1 + sphere
    bl      printSphere                     // call printSphere

    adrp    x0, second                      // Print sphere info
    add     x0, x0, :lo12:second            // low order
    mov     x1, x29                         // x1 = x29
    add     x1, x1, secondSphere            // x1 = x1 + sphere
    bl      printSphere                     // call printSphere

point:                                      
    point_x = 0                             // size of x is 0
    point_y = 4                             // size of y is 4
    point_z = 8                             // size of z is 8
    point_size = 12                         // Size of point is 12

sphere:                                     
    radius = 12                             // radius is 12
    origin = 0                              // origin is 0
    sphere_size = 16                        // Sphere size is 16 

    alloc = -(16 + sphere_size) & -16       // New alloc for sphere 
    dealloc = -alloc                        // New dealloc for spheres

newSphere:                                  
    stp     x29, x30, [sp, alloc]!          // Allocating
    mov     x29, sp                         // x29 = sp 
    mov     x20, x8                         // x20 = x8 

    mov     w19, 0                          // w19 = 0
    str     w19, [x20, point_x]             // x = 0
    str     w19, [x20, point_y]             // y = 0
    str     w19, [x20, point_z]             // z = 0

    mov     w19, 1                          // w19 = 1
    str     w19, [x20, radius]              // store radius 

    str     w0, [x20, base]                 //
    ldr     w0, [x20, base]                 //
    str     w0, [x8, base]                  //
    ldp     x29, x30, [sp], dealloc         // Deallocating
    ret                                     // Return

move:                                       
    stp     x29, x30, [sp, alloc]!          // Allocating
    mov     x24, x0                         // X24 = X0

    ldr     w26, [x24, point_x]             // Load value for x 
    ldr     w27, [x24, point_y]             // Load value for y 
    ldr     w28, [x24, point_z]             // Load value for z

    add     w26, w26, w1                    // Add value to x 
    add     w27, w27, w2                    // Add value to y 
    add     w28, w28, w3                    // Add value to z

    str     w26, [x24, point_x]             // Store point x
    str     w27, [x24, point_y]             // Store point y
    str     w28, [x24, point_z]             // Store point z 
    ldp     x29, x30, [sp], dealloc         // Deallocating stack memory
    ret

expand:
    stp     x29, x30, [sp, alloc]!          // Allocating
    mov     x24, X0                         // 
    mov     w19, w1                         // Moove w1 to 
    ldr     w21, [x24, radius]              // Load w21
    mul     w21, w21, w19                   // w21 = w21 + w19
    str     w21, [x24, radius]              // Store radius in w21 
    ldp     x29, x30, [sp], dealloc         // Deallocating stack memory
    ret                                     // Return 

equal:
    stp     x29, x30, [sp, alloc]!          // Allocating
    mov     x29, sp

    mov     x24, x0                         // x24 = x0
    mov     x25, x1                         // x25 = x1
    mov     w27, FALSE                      // w27 = 0 (false)
    ldr     x22, [x24, point_x]             // Load x22
    ldr     x23, [x25, point_x]             // Load x23
    cmp     x22, x23                        // If x22 =/= x23
    b.ne    return                          // .. branch return

    ldr     x22, [x24, point_y]             // Load x22
    ldr     x23, [x25, point_y]             // Load x23
    cmp     x22, x23                        // If x22 =/= x23
    b.ne    return                          // .. branch return

    ldr     x22, [x24, point_z]             // Load x22
    ldr     x23, [x25, point_z]             // Load x23
    cmp     x22, x23                        // If x22 =/= x23
    b.ne    return                          // .. branch return

    ldr     x22, [x24, radius]              // Load x22
    ldr     x23, [x25, radius]              // Load x23
    cmp     x22, x23                        // If x22 =/= x23
    b.ne    return                          // .. branch return
    
    mov     w27, TRUE                       // w27 = true (1)

return:
    mov     w0, w27                         // w0 = w27
    ldp     x29, x30, [sp], dealloc         // Deallocating stack memory
    ret        

printSphere:
    stp     x29, x30, [sp, alloc]!          // Allocating
    mov     x29, sp                         // x29 = sp 
    mov     x25, x1                         // x25 = x1
    mov     x1, x0                          //x1 = x0
    adrp    x0, sphereStr                   // Print the sphere 
    add     x0, x0, :lo12:sphereStr         // Low order
    ldr     x2, [x25, point_x]              // Load x
    ldr     x4, [x25, point_y]              // Load y 
    ldr     x5, [x25, point_z]              // Load z 
    ldr     x6, [x25, radius]               // Load radius 
    bl      printf                          // Print 
    ldp     x29, x30, [sp], dealloc         // Deallocating stack memory
    ret                                     // Return 

done:                                       // Returns 0 & exits program
    mov     w0, 0                           // Return 0 to OS
    ldp     x29, x30, [sp], deallocA        // Deallocating stack memory
    ret                                     // Return to calling code in OS

