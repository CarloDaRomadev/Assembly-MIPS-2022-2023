.globl main
.data
 S: .ascii "0110101011\n"
 C: .ascii "\n"
.text 
main:
	la $t1,C
	la $a0,S
	lb $t2,($t1)		
	contaOccorrenze:
	
	jal while 	#"jumpo" alla label while e salvo nel registro $ra l'istruzione successiva a questa
	
	#chiamate a sistema
	move $a0,$v0
	li $v0,1
	syscall
	move $a0,$t1
	li $v0,4
	syscall
	move $a0,$v1
	li $v0,1
	syscall
	li $v0,10
	syscall
	
	while:
	lb $t0,($a0)
	addi $a0,$a0,1
	beq $t0,$t2,fine
	subi $t0,$t0,48 
			#	dato che "0" in ascii è 110000
			#	quindi sottraggo 48
	bne $t0,$0,uno
	addi $v0,$v0,1  #contatore occorrenze 0 sale di 1
	j while		#torno all'inizio del ciclo
	
	uno:
	
	addi $v1,$v1,1  #contatore occorrenze 0 sale di 0
	j while		#contatore occorrenze 1 sale di 1
	
	fine:
	jr $ra		#torno alla riga dopo il comando jal