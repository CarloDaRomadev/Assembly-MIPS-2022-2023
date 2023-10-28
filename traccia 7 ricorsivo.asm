#soluzione ricorsiva

.data
    buffer: .space 26
    output: .byte  0,0,0,0,0,0,0,0,0  # Un carattere extra per la fine della stringa

.text

main:
    li $v0, 8       # Codice per input stringa
    la $a0, buffer  # Carica indirizzo base in $a0
    li $a1, 26      # Alloca al massimo 24 caratteri + \n + \0
    syscall         # $a0 contiene l'indirizzo base della stringa
    la $a2, output
# ... A QUI

##########################################
## INSERIRE IL PROPRIO CODICE QUI

jal CodificaOttaleRec

add $t4,$v0,$0

#syscall

move $a0,$a2
li $v0,4
syscall

li $a0,'\n'
li $v0,11
syscall

move $a0,$t4
li $v0,1
syscall

li $a0,'\n'
li $v0,11
syscall

move $a0,$v1
li $v0,1
syscall

li $a0,'\n'
li $v0,11
syscall

li $v0,10
syscall


CodificaOttaleRec:
	li $v0,0
	li $v1,0
	ricorsione:
	lb $t0,($a0)		#carico dall'indirizzo presente in $a0 il nuovo caratere
	beq $t0,'\n',casobase   #se sono arrivato a fine stringa salto a casobase
	lb $t1,1($a0)		#carico dall'indirizzo presente in $a0 shiftato di 1 (byte) il nuovo caratere
	beq $t1,'\n',casobase2	#se sono arrivato a fine stringa salto a casobase2 (array con numero di caratteri non multiplo di 3)
	lb $t2,2($a0)		#carico dall'indirizzo presente in $a0 shiftato di 2 (byte) il nuovo caratere
	beq $t2,'\n',casobase2 	#se sono arrivato a fine stringa salto a casobase2 (array con numero di caratteri non multiplo di 3)
	
	subi $sp,$sp,24		#carico lo stack
	sw $ra,($sp)		
	sw $a2,4($sp)
	sw $a0,8($sp)
	sw $t0,12($sp)
	sw $t1,16($sp)
	sw $t2,20($sp)		#	//
	
	addi $a0,$a0,3		#incremento di 3(byte) l'indirizzo per scorrere l'array
	addi $a2,$a2,1		#incremento di 1(byte) l'inidirizzo del nuovo nettore così che il nuovo cararttere sia messo nella posizione successiva a quello inserito
	
	jal ricorsione
	
	lw $ra,($sp)		#svuoto lo stack
	lw $a2,4($sp)
	lw $a0,8($sp)
	lw $t0,12($sp)
	lw $t1,16($sp)
	lw $t2,20($sp)
	addi $sp,$sp,24		#      // 
	addi $v1,$v1,1		#faccio salire il contatore dei caratteri di 1		
	
	subi $t0,$t0,48		#converto la terna di caratteri in valori
	subi $t1,$t1,48		#sottraendo '0'
	subi $t2,$t2,48		
	sll $t0,$t0,2		#converto la terna in notazione binaria, la prima cifra varrà 4 se settata a 1
	sll $t1,$t1,1		#la seconda 2 (la terza 1)
	add $t3,$t1,$t0		#sommo questi valori per ottenere il numero in ottale
	add $t3,$t3,$t2		#in $t3 ci sarà il numero in notazione ottale.
	addi $t3,$t3,48		#converto questo valore in carattere ascii
	sb $t3,($a2)		#inserisco in in memoria, all'indirizzo $a2 il nuovo ottale (byte)
	jr $ra			#salto all'istruzione dopo l'istruzione chiamante
	
	casobase:
	jr $ra
	
	casobase2:
	li $v0,1		#setto il bit di scorrimento parziale contenuto in $v0 ad 1
	jr $ra