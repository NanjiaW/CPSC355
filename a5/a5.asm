// Assignment 5 - CPSC 355 - Due Nov 25th
// Translate all functions except main() into ARMv8 assembly

STACKSIZE = 5                                   // Stacksize = 5
FALSE = 0                                       // False = 0
TRUE = 1                                        // True = 1

define(top_a, w26)                              // top address
define(value, w27)                              // value
define(i, w28)                                  // i

stackoverflow:      .string "\nStack overflow. Cannot push value onto stack.\n"
stackunderflow:     .string "\nStack underflow. Cannot pop an empty stack.\n"
stackcurrent:       .string "\nCurrent stack contents:\n"
stackempty:         .string "\nEmpty stack\n"
stacki:             .string "   %d"
stacktop:           .string " <-- top of stack"
printspace:         .string "\n"

        .data

        .global top                             // Top is global
top:    .word -1                                // top = -1

        .global stack                           // Stack is global
stack:  .skip STACKSIZE*4                       // Allocates 20 bytes for stack

    .text
    .balign 4
    .global push
push:                                           // Push function
    stp x29, x30, [sp, -16]!                    // Increment memory
    mov x29, sp                                 // Links FP and SP
    mov value, w0                               // Stores 'value' into w27
    bl stackFull                                // bl to stackFull
    cmp w0, TRUE                                // If stackfull =/= true
    b.ne    else                                // branch to else
    
    adrp    x0, stackoverflow                   // Print underflow
    add x0, x0, :lo12:stackoverflow             // ^
    bl  printf                                  // bl to printf
    
    ldp x29, x30, [sp], 16                      // Decrement memory
    ret                                         // Return

else:
    adrp x19, top                               // Read top
    add x19, x19, :lo12:top                     // ^
    ldr top_a, [x19]                            // Read from x19, top, and store in x25
    add top_a, top_a, 1                         // Pre-increment top
    str top_a, [x19]                            // Store top
    adrp    x21, stack                          // Read from stack
    add x21, x21, :lo12:stack                   // ^
    str value, [x21, top_a, SXTW 2]              // store 'value' into stack
    ldp x29, x30, [sp], 16
    ret

    .global pop
pop:                                            // Pop function
    stp x29, x30, [sp, -16]!                    // Increment memory
    mov x29, sp                                 // Links FP and SP
    bl stackEmpty                               // bl to stackEmpty
    cmp w0, TRUE                                // If stackempty =/= true
    b.ne    else2                               // branch to else2
    adrp    x0, stackunderflow                  // Print underflow
    add x0, x0, :lo12:stackunderflow            // ^
    bl  printf                                  // bl to printf
    mov x0, -1                                  // Return -1
    ldp x29, x30, [sp], 16                      // Decrement memory
    ret                                         // Return

else2:
    adrp    x19, top                            // Read top
    add x19, x19, :lo12:top                     // ^
    ldr top_a, [x19]                            // Read from x19, top, and store in x25
    
    adrp    x21, stack                          // Read from stack
    add x21, x21, :lo12:stack                   // ^
    ldr value, [x21, top_a, SXTW 2]             // Load stack[top]
    sub top_a, top_a, 1                         // top = top - 1
    str top_a, [x19]                            // Store top
    mov w0, value                               // return value
    ldp x29, x30, [sp], 16                      // Decrement memory
    ret

.global stackFull
stackFull:                                      // StackFull function
    stp x29, x30, [sp, -16]!                    // Increment memory
    mov x29, sp                                 // Links FP and SP
    adrp    x19, top                            // Save top address in x19
    ldr top_a, [x19]                            // ^
    mov w25, STACKSIZE
    cmp top_a, STACKSIZE - 1                    // If top == stacksize - 1
    b.ne    else5                               // Else: Return false
    mov x0, TRUE                                // ... return TRUE                        
    ldp x29, x30, [sp], 16                      // Decrement memory
    b   end                                     // Return

end:
    ldp x29, x30, [sp], 16                      // Decrement memory
    ret                                         // Return

.global stackEmpty
stackEmpty:                                     // Stackempty function
    stp x29, x30, [sp, -16]!                    // Increment memory
    mov x29, sp                                 // Links FP and SP
    adrp    x19, top                            // x19 = baseadrress for top
    add x19, x19, :lo12:top                     // ^ 
    ldr top_a, [x19]                            // Load x19 into top_a (w26)
    cmp top_a, -1                               // If top == -1
    b.ne    else5                               // Else: Return false
    mov x0, TRUE                                // ... Return true

    ldp x29, x30, [sp], 16                      // Decrement memory
    ret                                         // Return

else5:
    mov x0, FALSE                               // Else: return False

    .global display
display:                                        // Display function
    stp x29, x30, [sp, -16]!                    // Increment memory
    mov x29, sp            
    bl  stackEmpty
    cmp     w0, TRUE
    b.eq    print1
    b   printfCurrent
    b   test
    b   end

loop:
    adrp   x0, stacki
    add     x0, x0, :lo12:stacki
    mov     w1, w24
    bl  printf

    cmp w26, w26
    b.ne decrement

    adrp    x0, stacktop
    add x0, x0, :lo12:stacktop
    bl  printf

decrement:
    adrp x0, printspace
    add x0, x0, :lo12:printspace
    bl printf
    sub w27, w27, 1

test:
    cmp w27, 0
    b.ge    loop
    b   end3

print1:
    adrp    x0, stackempty                      // Print stackempty
    add x0, x0, :lo12:stackempty                // ^
    bl  printf                                  // Branch to printf
    b   done3                                   // branch to done3


printfCurrent:
    adrp    x0, stackcurrent
    add     x0, x0, :lo12:stackcurrent
    bl  printf
    adrp x19, top               //Address of top is saved in x19
    add x19, x19, :lo12:top
    ldr w26, [x19]              //Loading top into w26
    mov w27, w26
    b test    

done3:
    ldp x29, x30, [sp], 16                      // Decrement memory
    ret                                         // Return

