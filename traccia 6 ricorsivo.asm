#soluzione ricorsiva

.globl main

.data
    buffer: .space 20

.text

main:
    	li $v0, 8       # Codice per input stringa
    	la $a0, buffer  # Carica indirizzo base in $a0
    	li $a1, 20      # Alloca al massimo 20 caratteri
    	syscall         # $a0 contiene l'indirizzo base della stringa
	
	jal contaoccorrenzeRec
	
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
	
	contaoccorrenzeRec:
		li $v0,0	#inizializzo il registro che contiene la somma dei valori presi a due a due
		li $v1,0	#inizializzo il registro che contiene il numero di caratteri presenti nella stringa
		
		ricorsione:
		lb $t0,($a0)			#caricamento prima cifra della coppia dalla memoria
		lb $t1,1($a0)			# //         seconda               //
		beq $t0,'\n',casobase		#se sono arrivato a fine array salto a "casobase"(caso numero caratteri pari)
		beq $t1,'\n',casobase2		#(caso numero caratteri dispari)
		
		subi $sp,$sp,16			#carico lo stack
		sw $ra,($sp)			#con il return address
		sw $a0,4($sp)			#l'indirizzo che uso per scorrere il vettore
		sb $t0,8($sp)			#$t0, che contiene la prima cifra delle coppie
		sb $t1,12($sp)			#$t1, che contiene la seconda cifra delle coppie
		addi $a0,$a0,2			#faccio salire l'indirizzo di scorrimento di un byte per scorrere il vettore
		
		jal ricorsione			#salto alla label ricorsione
		
		lw $ra,($sp)			#svuoto lo stack
		lw $a0,4($sp)
		lb $t0,8($sp)
		lb $t1,12($sp)
		addi $sp,$sp,16
		
		subi $t0,$t0,48			#converto da carattere a numero
		subi $t1,$t1,48			#         //       // 
		
		mul $t3,$t0,10			#trasformo in notazione decimale le due cifre
		add $t3,$t3,$t1			#la prima cifra vale 10 volte la seconda
		add $v0,$v0,$t3			#aggiorno $v0 andandogli a sommare il numero in notazione decimale
		addi $v1,$v1,2			#al contatore dei caratteri aggiungo 2
		jr $ra				#salto all' istruzione contenuta in $ra
		
		casobase:			#raggiungo questa label se il numero di caratteri è pari
		jr $ra				#salto all'istruzione salvata in $ra
		
		casobase2:			#raggiungo questa label se il numero di caratteri è dispari
		subi $t0,$t0,48			#converto da carattere a numero
		add $v0,$v0,$t0			#sommo il numero ottenuto in $v0
		addi $v1,$v1,1			#faccio salire il contatore dei caratteri di 1
		jr $ra				#salto all'istruzione salvata in $ra
		