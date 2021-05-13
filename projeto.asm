.data

arquivo_entrada:	.asciiz "teste.txt"
arquivo_saida:		.asciiz "resposta.txt"
buffer:			    .space 512
#EOL:                .asciiz '' #utilizaremos EOL (end of line) para identificar o fim de cada palavra

.text


#abrir arquivo
li $v0, 13			        #codigo para abrir arquivo
la $a0, arquivo_entrada		#salvando nome de arquivo que queremos abrir no registrador $a0
li $a1, 0			        #escolhendo modo apenas de leitura
syscall                     #chamando funcao
move $s1, $v0			    #passando o arquivo de v0 para s1

#ler o arquivo
li $v0, 14			        #codigo para ler arquivo
move $a0, $s1			    #passando os bytes de s1 como parametro da funcao 
la $a1, buffer			    #passando o buffer para salvar os bytes 
li $a2, 512			        #tamanho de buffer definido em .data
syscall                     #chamando funcao

#fechar arquivo
li $v0, 16			        #codigo para fechar arquivo
move $a0, $s1			    #passando como parametro o arquivo aberto
syscall


# t0 indice
# t1 e a letra a ser analizada 
# t2 e um indice auxiliar para nao mudar o t0 
# t2 vai ser usado no end_verify
# t3 conta o tamanho de cada palavra
# t4 

# Switch case 
li $t0, 0               #salvando 0 no nosso indice ($t0)
li $t2, 0               #temporario
li $t3, 0               

loop:
    
    
    lb $t1, buffer($t0) #t1 recebe buffer na posicao t0 
    beq $t1, 0, fim
    beq $t1, 10, end_verify #verificando se t0 e igual a "endfile"
    #Casos especificos
    beq $t1, -25, to_upper #ç -> Ç
    beq $t1, -57, to_lower #Ç -> ç
    
    #Agudo ´
    beq $t1, -31, to_upper #á -> Á
    beq $t1, -63, to_lower #Á -> á
    
    beq $t1, -23, to_upper #é -> É
    beq $t1, -55, to_lower #É -> é
    
    beq $t1, -19, to_upper #í -> Í
    beq $t1, -51, to_lower #Í -> í
    
    beq $t1, -13, to_upper #ó -> Ó
    beq $t1, -45, to_lower #Ó -> ó
    
    beq $t1, -6, to_upper #ú -> Ú
    beq $t1, -38, to_lower #Ú -> u
    #Circunflexo ^
    
    beq $t1, -30, to_upper #â -> Â
    beq $t1, -62, to_lower #Â -> â
    
    beq $t1, -22, to_upper #ê -> Ê
    beq $t1, -54, to_lower #Ê -> ê
    
    beq $t1, -18, to_upper #î -> Î
    beq $t1, -50, to_lower #Î -> î 
    
    beq $t1, -12, to_upper #ô -> Ô
    beq $t1, -44, to_lower #Ô -> ô
    
    beq $t1, -5, to_upper #û -> Û
    beq $t1, -37, to_lower #Û -> û
    
    #Til ~ 
    beq $t1, -29, to_upper #â -> Ã
    beq $t1, -61, to_lower #Â -> ã
    
    beq $t1, -11, to_upper #ô -> Õ
    beq $t1, -43, to_lower #Ô -> õ
    
    
    
    # A - Z
    blt $t1, 'A', next_step #se for menos que A 
    blt $t1, '[', to_lower #se for Z até A deixa minusculo
    # a - z
    blt $t1, 'a', next_step  #se for simbolo qualquer de [ até '
    blt $t1, '{', to_upper   #se for entre a e z deixa maiusculo
    
    
    
next_step: 
    addi $t0, $t0, 1
    j loop
    
to_upper:
    sub $t1, $t1, 32 # deixa maiusculo
    sb $t1, buffer($t0)
    j next_step      # proxima letra

to_lower:
    add $t1, $t1, 32 # deixa minusculo
    sb $t1, buffer($t0)
    j next_step      # proxima letra

end_verify:
    addi $t0, $t0, 1
    move $t2, $t0
    
    lb $t4, buffer($t2)                #carregando a letra em t4
    bne $t4,'e',loop                   #verificando se a letra é diferente de 'e'
    addi $t2, $t2, 1                   # t2++
    lb $t4, buffer($t2)
    bne $t4, 'n',loop
    addi $t2, $t2, 1
    lb $t4, buffer($t2)                
    bne $t4, 'd',loop
    addi $t2, $t2, 1
    lb $t4, buffer($t2)
    bne $t4, 'f',loop
    addi $t2, $t2, 1
    lb $t4, buffer($t2)
    bne $t4, 'i',loop
    addi $t2, $t2, 1
    lb $t4, buffer($t2)
    bne $t4, 'l',loop
    addi $t2, $t2, 1
    lb $t4, buffer($t2)
    bne $t4, 'e',loop
    addi $t2, $t2, 1
    lb $t4, buffer($t2)
    beq $t4, 0, fim
    beq $t4, 10, fim
    j loop
    
    #checa se eh endfile

clear_i:
    li $t3, 0 #zerando a contagem




fim: 
li $v1, 1                   #salvando 1 em $v1

#printando string 
li $v0, 4          
la $a0, buffer
syscall

#exemplo file:
#arquitetura
#3Home
#endfile