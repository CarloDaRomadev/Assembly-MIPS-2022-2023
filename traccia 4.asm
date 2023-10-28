#Soluzione iterativa

.data
    buffer: .space 20

.text

main:
    li $v0, 8       # Codice per input stringa
    la $a0, buffer  # Carica indirizzo base in $a0
    li $a1, 20      # Alloca al massimo 20 caratteri
    syscall         # $a0 contiene l'indirizzo base della stringa

	jal contaDivDueQuattro
	
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
	
	contaDivDueQuattro:
	li $t1,'\n'		#carico in $t1 il carattere finale della stringa
	lb $t2,($a0)		#carico in $t2 il carattere della stringa nell'indirizzo contenuto in $a0
	addi $a0,$a0,1          #faccio salire $a0 di un byte
	beq $t2,$t1,fine        #se questi due registri contengono lo stesso valore significa che sono sull'ultimo carattere della stringa
	subi $t2,$t2,48 	#trasformo il carattere in numero e lo inserisco in $t2
	beq $t2,$0,zero 	#se il nuemro è zero torno all'inizio del ciclo 
	divu $t0,$t2,2 		#controllo se è divisibile per 2
# blt $t0,$0,nonmultiplo2	#controllo se il numero è positivo
	mfhi $t3 		#sposto il resto della divisione in $t3
	bne $t3,$0,nonmultiplo2 #se non è multiplo di 2 salto a nonmultiplo2
	addi $v0,$v0,1 		#altrimwnti il contatore sale di 1
	
	nonmultiplo2:
	
	divu $t0,$t2,4 		#controllo se è divisibile per 4
# blt $t0,$0,fine		#controllo se il nuemero è positivo
	mfhi $t3 		#sposto il resto della divisione in $t3
	bne $t3,$0,nonmultiplo4 #...
	addi $v1,$v1,1 		#...
	
	nonmultiplo4:
	
	j contaDivDueQuattro #salgo a inizio ciclo
	
	zero:
	
	j contaDivDueQuattro #salgo a inizio ciclo
	
	fine:
	
	jr $ra #ritorno nel main