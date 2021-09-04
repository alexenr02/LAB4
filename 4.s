
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
thirdText:  .asciz "Give me the third operand: "
selection:  .asciz "Give me the operation to be performed (+, -, *, /):  "
char:       .asciz  "%c"
format:     .asciz  "%d%*c"
num1:       .int    0
simbol:     .int    0
simbol2:    .int    0
num2:       .int    0
result:     .int    0
num3:	    .int    0
output:     .asciz  "the result of %d %c %d "
output2:    .asciz  "%c %d is:"
resultText: .asciz  " %d\n"

	
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
	mov	r8,#0
	mov	r9,#1
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
	
@ ---seleccion de operacion 2 -------------------------------------------------
	
	ldr 	r0,=selection    @ "Give me the operation to be performed (+, -, *, /):  "
	bl 	printf	
	
	ldr     r0, =char        @ en r0 se guarda el formato
        ldr     r1, =simbol2  	 @ en r1 se empiezan a guardar valores
        bl      scanf            @ funcion scanf lenguaje c

@ ---selecciòn del tercer (3er) operando ----------------------------------------

	ldr 	r0,=thirdText	 @ "Give me the third operand: "
	bl 	printf	

	ldr     r0, =format      @ call scanf, and pass address of format
        ldr     r1, =num3        @ string and address of num in r0, and r1,
        bl      scanf 

@ ---recuperar valores de r1,r2,r3----------------------------------------

	Ldr     r1, =num1        @ recuperar la direcciòn del primer operando
        Ldr     r1, [r1]	 @ guardar valor de la direcciòn apuntada en r1 (primer operando) 
	
	ldr     r2, =simbol	 @ recuperar la direccion del simbolo de operacion
	ldr     r2, [r2]         @ guardar simbolo listo para mandar parametros a funcion printf

	ldr     r3, =num2	 @ recuperar la direcciòn del segundo operando
	ldr 	r3, [r3]	 @ guardar valor de la direcciòn apuntada en r3 (2do operando
	b 	operaciones	 @ se salta a operaciones para hacer la primera operacion
	

segundaOperacion:
	ldr     r0, =output	 @ 
        bl      printf
	add	r8,r8,#1	 @ se suma 1 al contador r8 para despues ver si ya se realizo la segunda operacion
	
	ldr     r2, =simbol2	 @ recuperar la direccion del simbolo de operacion
	ldr     r2, [r2]         @ guardar simbolo listo para mandar parametros a funcion printf

	ldr     r3, =num3	 @ recuperar la direcciòn del segundo operando
	ldr 	r3, [r3]	 @ guardar valor de la direcciòn apuntada en r3
	
	mov     r1, r4
		
	

@ ---comparar signo para ir a subrutinas correspondientes ----------------------------------------	
operaciones:		@esta rutina se hace dos veces
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
	mov     r4,#0		 @ limpiar cociente o contador de veces que r1 < r3 para evitar errores de acumulacion por repeticion de rutinas 
division1:
	cmp	r1,r3		 @comparar valor 1 y valor 3
	blt     recuperarR1	 @si r1<r3, imprimir valor (0 al inicio)
	sub	r1,r1,r3	 
	add	r4,r4,#1	 @ir acumulando las veces que es menor
	b       division1
recuperarR1:
	Ldr     r1, =num1        @ recuperar la direcciòn del primer operando
        Ldr     r1, [r1]	 @ guardar valor de la direcciòn apuntada en r1 (primer operando) 
	b       imprimirResultado

imprimirResultado:
	cmp	r8,r9		@se revisa si el contador r8 es 0 o ya avanzò a 1. si avanzo a 1 significa que ya se hizo la primera operacion
	blt	segundaOperacion @si el contador en r8 es cero, significa que aun no se realiza la segunda operacion
	mov     r1,r2		@para mostrar correctamente el 2do simbolo de operacion
	mov     r2,r3		@para mostrar correctamente el tercer operando debido al formato del string
	ldr     r0, =output2	@imprime el segundo simbolo y tercer operando
	bl 	printf

	mov     r1, r4		@el resultado almacenado en r4 se mueve a r1 para mostrarlo correctamente
	
	ldr 	r0, =resultText  @ imprimir resultado numerico
	bl 	printf
	
        pop     {ip, pc}         @ pop return address into pc
	bx lr            @ return 2 to Operating System	