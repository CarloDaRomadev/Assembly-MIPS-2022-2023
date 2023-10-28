#soluzione itearativa

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
subi $sp,$sp,4			#carico nello stack a2 per non perdere l'indirizzo iniziale della stringa di output.
sw $a2,($sp)

jal CodificaOttale

add $t4,$v0,$0

lw $a2,($sp)
addi $sp,$sp,4

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


CodificaOttale:
	
	li $v0,0
	li $v0,0
	
	while:
		li $t0,0		#inizializzo registri che conterranno i caratteri, se il registro $t1 o $t2 a fine stringa contengono 0 siginifica che sono stati scartati dei caratteri
		li $t1,0		# //
		li $t2,0		# //
		lb $t0,($a0)		#carico dall'indirizzo presente in $a0 il nuovo caratere
		beq $t0,'\n',fine	#se sono arrivato a fine stringa salto a fine
		lb $t1,1($a0)		#carico dall'indirizzo presente in $a0 shiftato di 1 (byte) il nuovo caratere
		beq $t1,'\n',fine	#se sono arrivato a fine stringa salto a fine
		lb $t2,2($a0)		#carico dall'indirizzo presente in $a0 shiftato di 2 (byte) il nuovo caratere
		beq $t2,'\n',fine	#se sono arrivato a fine stringa salto a fine
		
		addi $v1,$v1,1		#se tutti e tre i registri sono stati riempiti faccio salire il conteggio dei valori ottali
		
		subi $t0,$t0,48			#converto da simbolo a valore
		subi $t1,$t1,48			#            //
		subi $t2,$t2,48			#            //
		
		sll $t0,$t0,2		#trasformo la stringa in notazione binaria, la prima cifra del terzetto varra 4 se settata a 1,
		sll $t1,$t1,1		#la seconda 2 (la prima 1)
		add $t3,$t0,$t1		#trovo il numero in ottale		
		add $t3,$t3,$t2	
		addi $t3,$t3,48		#trasformo il valore in carattere
		sb $t3,0($a2)		#inserisco il carattere in memoria
		addi $a2,$a2,1		#faccio salire l'indirizzo di 1 (byte), così il prossimo carattere che storo andra a finire nel byte di memoria successivo
		addi $a0,$a0,3		#l'inirizzo di scorrimento sale di 3 (byte)
		j while			#salto a while
		
		fine:			#raggiungo la fine della stringa
		sne $v0,$t2,0		#se uno dei due registri non si è riempito significa che ho dovuto scaratare valori dalla stringa
		sne $v0,$t1,0		#quindi $v0 viene settato a1 altrimenti rimane 0
		
		jr $ra 			#salto all'istruzione dopo la chiamata a funzione