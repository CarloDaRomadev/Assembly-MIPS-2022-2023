.globl main

.data

 #test
 
 # M: .half 0, 1, 2,   
 #          3, 4, 5,   
 #          6, 7, 8
 
 # N: .byte 3
 
 M: .half 5, 6, 4, 8,   
          2, 5, 2, 6,   
          1, 9, 8, 4,   
          7, 3, 2, 2
           
 N: .byte 4
 
 S: .asciiz "\n"
 
.text
	

main:
	la $a0,M #carico l'indirizzo base della matrice
	lb $a1,N #carico il lato della matrice
	li $v0,0 #totale somma numeri riga e colonna pari
	li $v1,0 #totale somma numeri riga e colonna dispari
	
	jal sommascacchiera #salvo in $ra l'istruzione successiva, tornerò quì alla fien per printare
	
	
	move $a0,$v0
	li $v0,1      
	syscall	      #stampo sommapari
	la $a0,S
	li $v0,4
	syscall       #stampo spazio
	move $a0,$v1  
	li $v0,1
	syscall       #stampo sommadispari
	li $v0,10
	syscall       #chiudo il programma
	
sommascacchiera:
	
	li $t0,0 #inizializzo contatore generale
	li $t1,0 #inizializzo contatore righe
	li $t2,0 #inizializzo contatore colonne
	mul $s0,$a1,$a1 #trovo la fine della matrice
	
	while:
		beq $t0,$s0,end #salto a end se sono sull'ultimo elemento
		beq $t2,$a1,aggiungiriga #salto ad aggiungi riga se sono sull'ultima colonna
		ritorna: #(torno da aggiungi riga)
		divu $t3,$t2,2 #controllo se la colonna è pari (divisa per due da come resto zero?)
		mfhi $t4 #sposto da $hi (registro dove è salvato il resto della divisione 
		beq $t4,0,colonnapari #e controllo se è 0 o non 0, se è 0 salto a colonnapari
		j colonnadispari #altrimenti salto a colonna dispari
		
	colonnapari:
		divu $t3,$t1,2 #controllo ora se la riga è pari con lo stesso procedimento usato per la verifica di parità della colonna
		mfhi $t4 # //
		bne $t4,0,riganonpari #se non l'indice di riga non è pari salto a riga non pari
		lh $t5,($a0) #altrimenti vado a caricare su $t5 la halfword in $a0
		add $v0,$v0,$t5 #e la sommo nella somma generale dei nuemri con indice di riga e colonna pari
		riganonpari: 
		addi $t0,$t0,1 #faccio salire $t0 di 1 (contatore generale)
		addi $t2,$t2,1 #      //      $t2 di 1 (contatore colonna)
		addi $a0,$a0,2 #sposto il puntatore di due (cioè di 1 halfword)
		j while
		
	colonnadispari:
		divu $t3,$t1,2
		mfhi $t4
		beq $t4,0,riganondispari
		lh $t5,($a0)
		add $v1,$v1,$t5		 #procedimento simile al caso pari
		riganondispari:
		addi $t0,$t0,1
		addi $t2,$t2,1
		addi $a0,$a0,2
		j while
		
	aggiungiriga:
		li $t2,0 #resetto il contatore di colonna
		addi $t1,$t1,1 #faccio salire di 1 il contatore di riga
		j ritorna #ritorno su (ritorna)
					
	end:
		jr $ra #torno nel main per printare
	