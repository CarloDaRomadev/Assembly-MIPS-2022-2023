.globl main

.data
 M: .word 1, 1, 4, 2, 2
 N: .word 5
 #M: .word 0, 6, 7, 8, 8, 8, 6
 #N: .word 7
 S: .asciiz "\n"

.text
main:
	la $a0,M #carico l'indirizzo base della matrice
	lw $a1,N #carico la len dell'array di word
	li $v0,0 #inizializzo la somma degli elementi che rispettano la proprità 
	li $v1,0 #inizializzo il conteggio degli elementi che rispettano la proprietà
	jal SommaContaUgualiPrec
	
	#chiamate al sistema
	move $a0,$v0
	li $v0,1
	syscall
	la $a0,S
	li $v0,4
	syscall
	move $a0,$v1
	li $v0,1
	syscall
	li $v0,10
	syscall
	#primo numero stampato = somma valori
	#secondo numero stampato = conteggio valori
	
	
	SommaContaUgualiPrec:
		mul $t0,$a1,4 #calcolo lo sfasamento
		add $t1,$a0,$t0 #indirizzo base + sfasamento = ultimo indice vettore
		lw $t2,($a0) #carico in $t2 il primo numero del vettore
		addi $a0,$a0,4 #faccio salire di 4 (una word) il puntatore
		
		while:
			bgt $a0,$t1,end #se sono arrivato a fine array salto alla fine
			lw $t3,($a0) #carico la word dalla memoria
			bne $t2,$t3,diversi #se i due registri contengono numeri diversi, salto a "diversi" altrimenti: 
			add $v0,$v0,$t3 #la somma dei valori sale del valore contenuto in $t3 (va bene anche il valore in $t2)
			addi $v1,$v1,1 #il conteggio dei valori sale di uno
			diversi:
			move $t2, $t3 #sposto il numero contenuto in $t3 in $t2
			addi $a0,$a0,4 #faccio salire il puntatore di 4 (1 word avanti)
			j while #ricomincio il ciclo
			
		end:
			jr $ra #torno sopra nel main per le syscall
			
			  
			