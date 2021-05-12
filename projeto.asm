.data

arquivo_entrada:	.asciiz "teste.txt"
arquivo_saida:		.asciiz "resposta.txt"
buffer:			.space 512

.text

#abrir arquivo
li $v0, 13			#código para abrir arquivo
la $a0, arquivo_entrada		#salvando nome de arquivo que queremos abrir no registrador $a0
li $a1, 0			#escolhendo modo apenas de leitura
syscall                         #chamando função
move $s1, $v0			#passando o arquivo de $v0 para $s1

#ler o arquivo
li $v0, 14			#código para ler arquivo
move $a0, $s1			#passando os bytes de $s1 como parâmetro da função 
la $a1, buffer			#passando o buffer para salvar os bytes 
li $a2, 512			#tamanho de buffer definido em .data
syscall                         #chamando função

#fechar arquivo
li $v0, 16			#código para fechar arquivo
move $a0, $s1			#passando como parâmetro o arquivo aberto
syscall

#printando string
li $v0, 4          
la $a0, buffer
syscall