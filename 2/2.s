
@ can call the C function scanf() from assembly.
@ The C example for this code would be:
@     int num = 0;
@     printf( "> " );
@     scanf( "%d", &num );
@     print( "your input: %d\n", num ) ;
@
@ ---------------------------------------
@     Data Section
@ ---------------------------------------
	
        .data
        .balign 4	
prompt: .asciz  "> "
firstText: .asciz "Give me the first operand: "
secText: .asciz "Give me the second operand: "
format: .asciz  "%d"
num1:    .int    0
num2:    .int    0
result:  .int    0
output: .asciz  "the result of %d + %d is: %d\n"
	
@ ---------------------------------------
@     Code Section
@ ---------------------------------------
	
.text
.global main
.extern printf
.extern scanf

main:   push    {ip, lr}         @ push return address + dummy register for alignment
       @ldr     r0, =prompt      @ print the prompt
       @bl      printf
	ldr 	r0,=firstText    @"Give me the first operand: "
	bl 	printf
	

        ldr     r0, =format      @ call scanf, and pass address of format
        ldr     r1, =num1        @ string and address of num in r0, and r1,
        bl      scanf            @ respectively.
	mov 	r5,r1		 @ save the value of r1 in r5

	ldr 	r0,=secText	 @"Give me the second operand: "
	bl 	printf	

	ldr     r0, =format      @ call scanf, and pass address of format
        ldr     r1, =num2        @ string and address of num in r0, and r1,
        bl      scanf 
	mov 	r6,r1		 @ save the value of r1 in r6
	
        Ldr     r1, =num1         @ print num formatted by output string.
        Ldr     r1, [r1]
	
	ldr     r2, =num2
	ldr 	r2, [r2]
	add     r3,r2,r1	
	
        ldr     r0, =output
        bl      printf

	
        pop     {ip, pc}         @ pop return address into pc
	bx lr            @ return 2 to Operating System	