# approccio riscorsivo semplificato rispetto alla soluzione del professore, spero sia giusta;
# la carico soprattutto perché non so se posso passare gli argomenti in questo modo, 
# non ho capito cosa intenda lui con: "accetta paramentri in input" nella consegna.
# se avete una risposta ve ne sarei grato :) , grazie.

.globl main

#tests
.data

# M: .word 1, 1, 4, 2, 2
# N: .word 5
 M: .word 0,3
 N: .word 2
 S: .asciiz "\n"

.text
main:

	#carico i dati
	
	la $a0,M
	lw $a1,N
	li $v0,0
	li $v1,0
	
	#carico stack			

	jal SommaContaUgualiPrec #salto alla funzione e salvo in $ra l'indirizzo della funzione successiva a questo comando
	
	#chiamate a sistema
	
	move $a0,$v0
	li $v0,1
	syscall
	la $a0, S
	li $v0,4
	syscall
	move $a0, $v1
	li $v0,1
	syscall
	li $v0,10
	syscall
	
	SommaContaUgualiPrec:
		mul $t1,$a1,4 
		add $t1,$a0,$t1
		
		#in queste due righe ho trovato l'indirizzo finale dell'array di word.
		
		ricorsione:
		beq $a0,$t1,casobase #se l'indirizzo che sto valutando è anche l'ultimo salto al caso base
		lw $t0,($a0)	#carico dall'indirizzo (base) il primo numero per il confronto
		addi $a0,$a0,4	#incremento $a0 di una word
		lw $t2,($a0)	#carico dal nuovo indirizzo il secondo numero per il confronto
		
		subi $sp,$sp,12		#carico lo stack							
		sw $ra,12($sp)		#	
		sw $t2,8($sp)		#	
		sw $t0,4($sp)		#	
		subi $a0,$a0,4		#carico il primo indirizzo (base)
		sw $a0,($sp)		#	//
		
		addi $a0,$a0,4
		
		jal ricorsione #salto alla funzione e salvo in $ra l'indirizzo della funzione successiva a questo comando
		
		addi $sp,$sp,12		#vuoto lo stack
		lw $ra,12($sp)		#
		lw $t2,8($sp)		#
		lw $t0,4($sp)		#
		lw $a0,($sp)		#	//
		
		bne $t2,$t0,verifica 	#controllo se i due registri contengono lo stesso numero			
		addi $v0,$v0,1		#se è così incremento le due variabili come ho sempre fatto
		add $v1,$v1,$t2
		verifica:
		
		jr $ra #salto all'istruzione subito sotto l'istruzione chiamante
		
		casobase:
			bne $t2,$t0,diversi 	#controllo se i due registri contengono lo stesso numero,
			addi $v1,$v1,1		#se è così incremento le due variabili come ho sempre fatto
			add $v0,$v0,$t2
			diversi:
			jr $ra			#salto all'istruzione subito sotto l'istruzione chiamante
	
	