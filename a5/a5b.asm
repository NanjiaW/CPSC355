// Assignment 5 - CPSC 355 - Due Nov 25th
// Part B

define(month, w19)
define(day, w20)
define(year, x21)
    .data
define(abc, x22)
define(xyz, x23)
    .text
output: .string "%s %d%s, %d\n"                 // Prints out: "month day(ext), year"
errorstr:   .string "usage: a5b mm dd yyyy\n"     // Error message if format is entered wrong
jan:    .string "January"
feb:    .string "Febuary"
mar:    .string "March"
apr:    .string "April"
may:    .string "May"
jun:    .string "June"
jul:    .string "July"
aug:    .string "August"
sep:    .string "September"
oct:    .string "October"
nov:    .string "November"
dec:    .string "December"
st:     .string "st"
nd:     .string "nd"
rd:     .string "rd"
th:     .string "th"

months: .dword  jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
prefix: .dword  st, nd, rd, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, st, nd, rd, th, th, th, th, th, th, th, st

argc    .req    w23                             // Number of arguments
argv    .req    x24                             // Values of the argument

    .balign 4                                   // Alligns text
    .global main                                // Make visible to OS
main:                                           // Define main
    stp     x29, x30, [sp, -16]!                // Allocate stack memory
    mov     x29, sp                             // fp = sp

    mov     argc, w0                            // Copy to w0
    mov     argv, x1                            // Copy to x1
    mov     w25, 1                              // Month
    mov     w26, 2                              // Day
    mov     w27, 3                              // Year
   
    cmp     argc, 4                             // if the amount of inputs is less then 4
    b.lt    error                               // ... error

    ldr     x0, [argv, w25, SXTW 3]             // Store month into x0
    bl      atoi                                // convert string to int
    mov     month, w0                           // store into 'month' x19

    cmp     month, 12                           // if month >12
    b.gt    error                               // ... error
    cmp     month, 0                            // if month < 0
    b.lt    error                               // ... error

    ldr     x0, [argv, w26, SXTW 3]             // Store day into x0
    bl      atoi                                // convert string to int
    mov     day, w0                             // store into 'day' x20
    
    cmp     day, 31                             // if day > 31
    b.gt   error                                // ... error
    cmp     day, 0                              // if day < 0
    b.lt    error                               // ... error

    ldr     x0, [argv, w27, SXTW 3]             // Store year into x0
    bl      atoi                                // convert string to int
    sxtw    x0, w0                              // Sign extend
    mov     year, x0                            // store into 'year' x21

    cmp     year, 0                             // if year < 0
    b.lt    error                               // ... error

    adrp    xyz, months                         // Months address into 'month'
    add     xyz, xyz, :lo12:months              // ^
    sub     month, month, 1                     // month = month - 1

    adrp    abc, prefix                         // prefix address into 'abc'
    add     abc, abc, :lo12:prefix              // ^
    
    adrp    x0, output                          // Print output
    add x0, x0, :lo12:output                    // ^
    ldr     x1, [xyz, month, SXTW 3]            // Set up 1st arg (month)
    mov     w2, day                             // Set up 2nd arg (day)
    sub     day, day, 1                         // Day = day - 1
    ldr     x3, [abc, day, SXTW 3]              // Set up 3rd arg (prefix)
    mov     x4, year                            // Set up 4th arg (year)
    bl      printf                              // Print it

done:                                           // Define done
    ldp     x29, x30, [sp], 16                  // Deallocating stack memory
    ret                                         // Return to calling code in OS

error:                                          // Define error
    adrp    x0, errorstr                        // Print errorstr
    add x0, x0, :lo12:errorstr                  // ^
    bl  printf                                  // ^
    b   done                                    // Deallocate
