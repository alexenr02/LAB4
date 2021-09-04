
@ can call the C function scanf() from assembly.

@ ---------------------------------------
@     Data Section
@ ---------------------------------------
	
            .data
            .balign 4	
firstText:  .asciz "Give me x: "

format:     .asciz  "%d"
num1:       .int    0

output:     .asciz  "the result of 6*( %d )^2 + 9*( %d ) + 2 = %d\n"


	
@ ---------------------------------------
@     Code Section
@ ---------------------------------------
	
.text
.global main
.extern printf
.extern scanf
.extern getkey

main:   push    {ip, lr}         @ push return address + dummy register for alignment
       
@ ---se empiezan a recibir los parametros------------------------------

	ldr 	r0,=firstText    @ "Give me x: "
	bl 	printf
        
	ldr     r0, =format      @ call scanf, and pass address of format
        ldr     r1, =num1        @ string and address of num in r0, and r1,
        bl      scanf            @ funcion scanf lenguaje c
	
@ ---recuperar valores de r1,r2,r3----------------------------------------

	Ldr     r1, =num1        @ recuperar la direcciòn del primer operando
        Ldr     r1, [r1]	 @ guardar valor de la direcciòn apuntada en r1 (primer operando) 
	
	mov	r8, #6
	mov	r9, #9
	mul 	r4,r1,r1	 @ elevar al cuadrado
	mul	r5,r4,r8	 @ multiplicar por 6
	mul	r6,r1,r9	 @ multiplicar x por 9
	add	r4,r6,r5	 @ sumar primer y segundo termino
	add	r4,r4,#2	 @ sumar tercer termino
	
	mov     r3, r4		 @ acomodar valores para imprimir 
	mov	r2, r1
	ldr     r0, =output	 
        bl      printf
	
	
        pop     {ip, pc}         @ pop return address into pc
	bx lr            @ return 2 to Operating System	