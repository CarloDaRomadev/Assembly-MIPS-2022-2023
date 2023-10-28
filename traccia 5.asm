#soluzione iterativa

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

#inizializzo le variabili 
	li $v0,0 #contatore consecutivi uguali
	li $v1,0 #contatore somma cifre
	
	jal contaOccorrenze
	
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
	
	contaOccorrenze:			#preciclo per il primo elemento dato che non ha elementi precedenti, questo può essere implementato diversamente ma ritengo che questo sia il più chiaro e semplice.
		lb $t0,($a0)			#carico in $t0 il primo byte del vettore
		beq $t0,'\n',fine		#se è anche l'ultimo, cioè, se il vettore non esiste vado a "fine"
		subi $t0,$t0,48			#altrimenti trasform oil numero da "carattere" a "cifra" togliendogli 48 (zero a carattere)
		addi $a0,$a0,1			#aggiungo 1 al puntatore per scorrere per andare all'elemento successivo
		add $v1,$v1,$t0
	while:
		lb $t2,($a0)				#carico in $t2 il byte successivo del vettore
		beq $t2,'\n',fine			#se questo è l'ultimo vado a fine
		subi $t2,$t2,48				#converto...
		addi $a0,$a0,-1 			#vedo se il valore precedente ($t0), che nel primo caso troviamo nel preciclo mentre in tutti gli altri casi nel ciclo, è uguale al valore presenter in $t2 
		lb $t0,($a0)				#carico $t0, (nel primo ciclo è superfluo)
		subi $t0,$t0,48				#converto...
		bne $t0,$t2,nonugualealprecedente	#se i due registri contengono valori differenti salto a "nonugualealprecedente"
		addi $v0,$v0,1				#altrimenti il contatore dei consecutivi uguali sale
		nonugualealprecedente:
		addi $a0,$a0,2
		add $v1,$v1,$t2				#sommo a $v1 il nuovo valore
		j while					#ritorno all'inizio del ciclo
					
	fine:	
		jr $ra #ritorno nel main per le syscall	