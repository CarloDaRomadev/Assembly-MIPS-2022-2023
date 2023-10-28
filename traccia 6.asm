#soluzione iterativa

.globl main

.data
    buffer: .space 20

.text

main:
    	li $v0, 8       # Codice per input stringa
    	la $a0, buffer  # Carica indirizzo base in $a0
    	li $a1, 20      # Alloca al massimo 20 caratteri
    	syscall         # $a0 contiene l'indirizzo base della stringa
	
	jal contaoccorrenze 
	
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
	
	contaoccorrenze:
		li $v0,0	#inizializzo il registro che contiene la somma dei valori presi a due a due
		li $v1,0	#inizializzo il registro che contiene il numero di caratteri presenti nella stringa
		
		while:
			lb $t0,($a0) 			#carico in $t0 il byte all'indirizzo contenuto in $a0
			beq $t0,'\n',fine		#se la stringa è finita salto a fine
			subi $t0,$t0,48			#converto da carattere a valore
			addi $v1,$v1,1 			#aggiungo 1 al contatore dei caratteri
			addi $a0,$a0,1 			#l'indirizzo sale di un byte
			lb $t1,($a0) 			#carico in $t0 il byte all'indirizzo contenuto in $a0
			beq $t1,'\n',ultimonumero 	#se la stringa è finita salto a ultimonumero (caso stringa dispari)
			subi $t1,$t1,48			#converto da carattere a valore
			mul $t0,$t0,10 			#moltiplico per 10 la prima cifra
			add $t2,$t0,$t1 		#valore finale da inserire nella somma
			add $v0,$v0,$t2			#sommo il valore finale nel registro
			addi $v1,$v1,1 			#aggiungo 1 al contatore dei caratteri
			addi $a0,$a0,1 			#l'indirizzo sale di un byte per passare ai due numeri successivi
			j while				#torno al while
	fine:
	jr $ra
	
	ultimonumero:
	add $v0,$v0,$t0
	jr $ra
	