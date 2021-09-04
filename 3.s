
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
prompt:     .asciz  "> "
firstText:  .asciz "Give me the first operand: "
secText:    .asciz "Give me the second operand: "
selection:  .asciz "Give me the operation to be performed (+, -, *, /):  "
char:       .asciz  "%c"
format:     .asciz  "%d%*c"
num1:       .int    0
simbol:     .int    0
num2:       .int    0
result:     .int    0
output:     .asciz  "the result of %d %c %d is:"
resultText: .asciz  " %d\n"
textoError:  .asciz "Error de operando, introducelo de nuevo"
	
@ ---------------------------------------
@     Code Section
@ ---------------------------------------
	
.text
.global main
.extern printf
.extern scanf
.extern getkey

main:   push    {ip, lr}         @ push return address + dummy register for alignment
       
	@ ldr     r0, =prompt      @ print the prompt
        @ bl      printf
	
@ ---se empiezan a recibir los parametros------------------------------

	ldr 	r0,=firstText    @ "Give me the first operand: "
	bl 	printf
        
	ldr     r0, =format      @ call scanf, and pass address of format
        ldr     r1, =num1        @ string and address of num in r0, and r1,
        bl      scanf            @ funcion scanf lenguaje c
	
@ ---seleccion de operacion -------------------------------------------------
	
	ldr 	r0,=selection    @ "Give me the operation to be performed (+, -, *, /):  "
	bl 	printf	
	
	ldr     r0, =char        @ en r0 se guarda el formato
        ldr     r1, =simbol  	 @ en r1 se empiezan a guardar valores
        bl      scanf            @ funcion scanf lenguaje c
	
@ ---selecciòn del segundo operando ----------------------------------------

	ldr 	r0,=secText	 @ "Give me the second operand: "
	bl 	printf	

	ldr     r0, =format      @ call scanf, and pass address of format
        ldr     r1, =num2        @ string and address of num in r0, and r1,
        bl      scanf 
	
@ ---recuperar valores de r1,r2,r3 ----------------------------------------

	Ldr     r1, =num1        @ recuperar la direcciòn del primer operando
        Ldr     r1, [r1]	 @ guardar valor de la direcciòn apuntada en r1 (primer operando) 
	
	ldr     r2, =simbol	 @ recuperar la direccion del simbolo de operacion
	ldr     r2, [r2]         @ guardar simbolo listo para mandar parametros a funcion printf

	ldr     r3, =num2	 @ recuperar la direcciòn del segundo operando
	ldr 	r3, [r3]	 @ guardar valor de la direcciòn apuntada en r3 (2do operando)
	
@ ---comparar signo para ir a subrutinas correspondientes ----------------------------------------	

	cmp	r2, #43
	beq     suma
	
	cmp     r2, #45
	beq     resta
	
	cmp     r2, #42
	beq     multiplicacion

	cmp     r2, #47
	beq     division
	
@ ---subrutinas para operaciones ----------------------------------------	
suma:
	add     r4,r1,r3	 @ efectuar suma
        b 	imprimirResultado
resta:
	sub     r4,r1,r3	 @ efectuar resta
        b 	imprimirResultado
multiplicacion:
	mul     r4,r1,r3	 @ efectuar multiplicacion
        b 	imprimirResultado
division:
	cmp	r1,r3		 @comparar valor 1 y valor 3
	blt     recuperarR1	 @si r1<r3, imprimir valor (0 al inicio)
	sub	r1,r1,r3	 
	add	r4,r4,#1	 @ir acumulando las veces que es menor
	b       division
recuperarR1:
	Ldr     r1, =num1        @ recuperar la direcciòn del primer operando
        Ldr     r1, [r1]	 @ guardar valor de la direcciòn apuntada en r1 (primer operando) 
	b imprimirResultado

imprimirResultado:
	ldr     r0, =output	 @ imprimir texto resultado
        bl      printf

	mov     r1, r4
	
	ldr 	r0, =resultText  @ imprimir resultado numerico
	bl 	printf
	
        pop     {ip, pc}         @ pop return address into pc
	bx lr            @ return 2 to Operating System	