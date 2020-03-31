.globl filtro_rojo 				# 1 listo
.globl filtro_scanlines				# 2 listo
.globl filtro_ajedrez				# 3
.globl filtro_reset				# 4 listo
.globl filtro_gris				# 5 listo
.globl filtro_barras				# 6 listo
.globl filtro_escalado				# 7
.globl filtro_paleta				# 8
.globl filtro

#resolucion de img 640X480

filtro: .word 6

filtro_rojo:
	addiu 	$sp, $sp, -24
	sw    	$ra, 20($sp)
 	sw   	$fp, 16($sp)

  	move  	$t0, $a0			#pos donde inicia
	li	$s0, 921600
 	add  	$t1, $t0, $s0			#pos donde termina
  	li  	$t2, 0x00			#cero

loopRojo:  
  	sb  	$t2, 1($t0)			#guardo cero
  	sb  	$t2, 2($t0)			#guardo cero
  	addi 	$t0, $t0, 3			#al sig pixel
  	bne  	$t0, $t1, loopRojo			#mientras no llego al final

  	lw  	$ra, 20($sp)
  	lw  	$fp, 16($sp)
  	addiu  	$sp, $sp, 24
  	jr 	$ra

filtro_scanlines:
   	move  	$t0, $a0			#pos donde inicia img
	li	$t1, 0x00			#iterador
	li	$t2, 921600			#fin iterador
	li  	$t3, 1920  			#ancho 640x3

loop_scanlines: 
 	add  	$t4, $t1, $t0			#tomo la pos del color
 	lbu 	$t5, 0($t4)			#tomo el color
 	div 	$t5, $t5,2			#divido el color
 	sb	$t5, 0($t4) 			#guardo en memoria color/2
 	add  	$t1, $t1, 1			#iterador++
 
 	rem 	$t4, $t1, $t3  			#i mod ancho 
 	bne 	$t4, $zero, next
salto: 
 	add 	$t1,$t1,$t3			#iterador += ancho
next:	
	bne 	$t1, $t2, loop_scanlines			
  	jr 	$ra

filtro_ajedrez:
	jr 	$ra

filtro_reset:
	addiu 	$sp, $sp, -24
	sw    	$ra, 20($sp)
 	sw   	$fp, 16($sp)

  	move  	$t0, $a0			#pos donde inicia
	li	$s0, 921600
 	add  	$t1, $t0, $s0			#pos donde termina
  	move  	$t2, $a1			#rojo
	move	$t3, $a2			#verde
	move	$t4, $a3			#azul
	li	$s0, 255			#255
	li	$s1, 100			#100

	mul	$t2, $t2, $s0			#rojo*255/100
	div	$t2, $t2, $s1
	mul	$t3, $t3, $s0			#verde*255/100
	div	$t3, $t3, $s1
	mul	$t4, $t4, $s0			#azul*255/100
	div	$t4, $t4, $s1

	loop_reset:  
	sb	$t2, 0($t0)			#guardo el rojo
  	sb  	$t3, 1($t0)			#guardo el verde
  	sb  	$t4, 2($t0)			#guardo el azul
  	addi 	$t0, $t0, 3			#al sig pixel
  	bne  	$t0, $t1, loop_reset			#mientras no llego al final

  	lw  	$ra, 20($sp)
  	lw  	$fp, 16($sp)
  	addiu  	$sp, $sp, 24
  	jr 	$ra

filtro_gris:
	addiu 	$sp, $sp, -24
	sw    	$ra, 20($sp)
 	sw   	$fp, 16($sp)

  	move  	$t0, $a0			#pos donde inicia
	li	$s0, 921600
 	add  	$t1, $t0, $s0			#pos donde termina  	
	li	$s0, 3			#3

loop_gris: 
	lbu  	$t2, 0($t0)			#rojo
	lbu	$t3, 1($t0)			#verde
	lbu	$t4, 2($t0)			#azul

	add	$t2, $t2, $t3			#(rojo+verde+azul)/3
	add	$t2, $t2, $t4
	div	$t2, $t2, $s0

	sb	$t2, 0($t0)			#guardo el promedio
	sb	$t2, 1($t0)	
	sb	$t2, 2($t0)
	
  	addi 	$t0, $t0, 3			#al sig pixel
  	bne  	$t0, $t1, loop_gris			#mientras no llego al final

  	lw  	$ra, 20($sp)
  	lw  	$fp, 16($sp)
  	addiu  	$sp, $sp, 24
  	jr 	$ra

filtro_barras:
	li 	$t0, 0x00		#iterador
	li	$t1, 921600		#tamanyo en bytes de la imagen
	mul	$t2, $a1, 3		#ancho de barra * 3 componentes
	li	$t3, 255		#intensidad del rojo y azul
	li	$t4, 0x00		#intensidad del verde

loop_barras:
	rem	$t5, $t0, $t2		#iterador mod ancho == 0
	bne	$t5, $zero, cont 
	add	$t0, $t0, $t2		#sumar al iterador el ancho

cont:	add 	$t5, $a0, $t0 		#pos del pixel
	sb	$t3, 0($t5)		#seteo el rojo
	sb	$t4, 1($t5)		#seteo el verde
	sb	$t3, 2($t5)		#seteo el azul
	add	$t0, $t0, 3		#iterador + 3
	blt	$t0, $t1, loop_barras	#mientras no llego al final
	jr 	$ra

filtro_escalado:
	jr 	$ra

filtro_paleta:
	jr 	$ra
