################ approccio ricorsivo #####################################################

.data
    buffer: .space 20
.text

main:
    li $v0, 8       # Codice per input stringa
    la $a0, buffer  # Carica indirizzo base in $a0
    li $a1, 20      # Alloca al massimo 20 caratteri
    syscall         # $a0 contiene l'indirizzo base della stringa
	
    li $v0,0
    jal contaOccRec
	
	move $a0,$v0
	li $v0,1
	syscall
	
	li $a0,'\n'
	li $v0,11
	syscall
	
	move $a0,$v1
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	
##########################################
## INSERIRE IL CODICE QUI

	contaOccRec: 
	
		li $t0, '\n'	#carico il carattere che fa terminare la stringa 
		lb $t1,($a0)	#carico in $t1 il carattere
		beq $t1,$t0,casobase #se sono arrivato all'ultimo carattere salto al caso base
		
		subi $sp,$sp,12  #carico lo stack
		sw $t1,8($sp)
		sw $ra,4($sp)
		sw $a0,($sp)
		addi $a0,$a0,1 #il puntatore sale di un byte per scorrere il vettore
		
		jal contaOccRec
		
		lw $t1,8($sp)
		lw $ra,4($sp)
		lw $a0,($sp)
		addi $sp,$sp,12  #svuoto lo stack
		
		subi $t1,$t1,48 #controllo se il nuemro è 1 o 0
		beq $t1,$0,zero #se è zero salto a zero e faccio salire il contatore di 0
	        addi $v1,$v1,1	#altrimenti faccio salire il contatore di 1
	        jr $ra
	        
		zero:
		
		addi $v0,$v0,1
		jr $ra
		
	casobase:
	
		jr $ra