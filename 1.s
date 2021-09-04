.data
.balign 4

y: .word 0 
reg2: .word 0xBBBBBBBB
.text
.global main   @main es un nombre global, reconocible fuera de nuestro programa. This is needed
               @because the C linker will call main at runtime. If it is not global, it will not be callable
               @and the linking phase will fail.*/
	       @r0 - r14 proposito general
main:
push    {ip, lr}
ldr r0,=y		 @guarda la direccion de y en r0
ldr r1,=0xAAAAAAAA	 @guarda en r1 el valor numerico
ldr r3, =0xCCCCCCCC

@tipo 1
str r1,[r0]              @almacenamiento indirecto

@tipo 2 
ldr r2, =reg2     @direccion de reg2 en r2
ldr r2, [r2]      @valor ubicado en la direccion r2 = reg2 en r2
str r2, [r0]      @guardar valor del registro r2 en la direccion del registro r0

@tipo 3
str r3,[r0],#4
pop     {ip, pc}         @ pop return address into pc

@gdb nombre programa
@start
@disassemble
@info registers r0 r1
@stepi - ejecutar instruccion 
@p/x (long)y - imprimir en hexadecimal la variable y