#Soluzione ricorsiva

.data
    buffer: .space 20

.text

main:
    li $v0, 8       # Codice per input stringa
    la $a0, buffer  # Carica indirizzo base in $a0
    li $a1, 20      # Alloca al massimo 20 caratteri
    syscall         # $a0 contiene l'indirizzo base della stringa

	jal contaDivDueQuattroRec
	
	move $a0,$v0
	subi $a0,$a0,8 #sottraggo il valore usato per la prima syscall
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
	
	contaDivDueQuattroRec:
	lb $t2,($a0)
	beq $t2,'\n',casobase		#se arrivo all'ultimo elemento vado ne caso base
	
	subi $sp,$sp,12			#carico lo stack con:
	sw $a0,8($sp)			#$a0, l'indirizzo che mi serve per scorrere il vettore
	addi $a0,$a0,1			#dopodiche $a0 sale di un byte (per scorrere il vettore)
	sw $ra,4($sp)			#il return address che mi servira per tornare alla chiamata ricorsiva chiamante
	sb $t2,($sp)			#il valore presente nel vettore all'indirizzo contenuto in $a0
	
	jal contaDivDueQuattroRec	#salto alla funzione e salvo in $ra l'indirizzo dell'istruzione successiva
	
	lw $a0,8($sp)   		#svuto lo stack
	lw $ra,4($sp)			
	lb $t2,($sp)
	addi $sp,$sp,12
	
	subi $t2,$t2,48			#tolgo al numero presente in $t2 48 perpassare dal numero "carattere" a numero "cifra"
	
	beq $t2,$0,zero			#salto a zero se il numero è zero
	
	divu $t5,$t2,2			#altrimenti controllo se è divisibile per 2 (in $t5 c'è il risultato della divisione tra il valore contenuto nel registro $t2 e 2)
	mfhi $t3			#sposto il resto della divisione tra il contenuto di $t2 e 2 in $t3
	bne $t3,$0 nonmultiplo2		#se il resto non è 0, il numero presente in %t2 non è divisibile per due, salto a nonmultiplo2
	addi $v0,$v0,1			#in caso contario aggiungo 1 al contatore
	
	nonmultiplo2:
	
	divu $t5,$t2,4			#controllo se è divisibile per 4
	mfhi $t3
	bne $t3,$0 nonmultiplo4		#procedimento simile a quello sopra...
	addi $v1,$v1,1
	
	nonmultiplo4:
	
	jr $ra #ritorno alla funzione chiamante
	
	zero:
	
	jr $ra #ritorno alla funzione chiamante 
	
	casobase:
	
	jr $ra #ritorno alla funzione chiamante