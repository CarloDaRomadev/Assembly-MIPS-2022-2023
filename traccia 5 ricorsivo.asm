#soluzione ricorsiva

.data
    buffer: .space 20

.text

main:
    li $v0, 8       # Codice per input stringa
    la $a0, buffer  # Carica indirizzo base in $a0
    li $a1, 20      # Alloca al massimo 20 caratteri
    syscall         # $a0 contiene l'indirizzo base della stringa


##########################################
## INSERIRE IL CODICE QUI
	li $v0,0
	li $v1,0
	
	jal contaOccorrenzeRec #chiamo la funzione principale
	
	#syscall
	
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
	
	contaOccorrenzeRec:
	
		#prericorsione per scandire il primo valore dell'array dato che non ha precedenti
		lb $t0,($a0)				#carico in $t0il primo valore dell'array
		beq $t0,'\n',casobase 			#controllo che non sia anche l'ultimo (array vuoto)
		subi $t0,$t0,48				#converto da carattere a valore
		addi $a0,$a0,1				#faccio salire il puntatore di un byte
		add $v1,$v1,$t0				#sommo alla somama degli elementi il valore contenuto in $t0
		
		ricorsione:
		
		lb $t2,($a0)				#carico in $t2 il valore contenuto nella memoria all'indirizzo contenuto in $a0
		beq $t2,'\n',casobase			#se mi trovo sull'ultimo elemento salto al caso base
		subi $t2,$t2,48				#altrimenti converto...
		subi $a0,$a0,1				#faccio scendere il puntatore di 1 byte per prendere il carattere precendente
		lb $t0,($a0)				#carico in $t0, il byte (il carattere) precedente
		subi $t0,$t0,48				#converto...
		addi $a0,$a0,1				#incremento l'indirizzo di 1 (byte)
		
		subi $sp,$sp,16				#carico lo stack con i valori che mi serviranno nella ricorsione
		sw $a0,12($sp)	
		addi $a0,$a0,1				#incremento l'indirizzo di uno per scorrere l'array
		sw $ra,8($sp)
		sw $t0,4($sp)
		sw $t2,($sp)
		
		jal ricorsione				#la funzione richiama se stessa con l'indirizzo contenuto in $a0 incrementato di 1
		
		lw $a0,12($sp)				#svuoto lo stack
		lw $ra,8($sp)
		lw $t0,4($sp)
		lw $t2,($sp)
		addi $sp,$sp,16				# //////////////
		
		bne $t0,$t2,nonuguali			#controllo come nel caso iterativo se due valori consecutivi sono uguali
		addi $v0,$v0,1
		nonuguali:
		add $v1,$v1,$t2				#a prescindere dal controllo precedente la somma degli elementi sale del valore memorizzato in $t2
		jr $ra
		
	casobase:
		jr $ra