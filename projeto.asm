.data

<<<<<<< HEAD
.data
=======
arquivo_entrada:	.asciiz "teste.txt"
arquivo_saida:		.asciiz "resposta.txt"
buffer:			    .space 512
new_string:                 .space 512

>>>>>>> 66dc80dfbe9ad2547a68f42bcb2b5ad87e000a54

.text


<<<<<<< HEAD

.text
=======
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
# t4 recebe letra para trocar case
# t5 e t6 são as letras a ser trocadas

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
    
    #Agudo ?
    beq $t1, -31, to_upper #á -> Á
    beq $t1, -63, to_lower #Á -> á
    
    beq $t1, -23, to_upper #é -> É
    beq $t1, -55, to_lower #É -> é
    
    beq $t1, -19, to_upper #í -> Í
    beq $t1, -51, to_lower #Í -> í
    
    beq $t1, -13, to_upper #ó -> Ó
    beq $t1, -45, to_lower #Ó -> ó
    
    beq $t1, -6, to_upper  #ú -> Ú
    beq $t1, -38, to_lower #Ú -> ú
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
    beq $t1, -29, to_upper #ã -> Ã
    beq $t1, -61, to_lower #Ã -> ã
    
    beq $t1, -11, to_upper #õ -> Õ
    beq $t1, -43, to_lower #Õ -> õ
    
    
    
    # A - Z
    blt $t1, 'A', next_step #se for menos que A 
    blt $t1, '[', to_lower #se for Z at? A deixa minusculo
    # a - z
    blt $t1, 'a', next_step  #se for simbolo qualquer de [ at? '
    blt $t1, '{', to_upper   #se for entre a e z deixa maiusculo
    

reverse:
    jal clear_t0              #salvando 0 no nosso indice ($t0)

reverse_str:
    li $v1, 0                 # zera o retorno da funcao
    jal len                   # chama len e armazena em v1 (que armazena o len da str)
    sub $t3, $t0, $v1 #armazena o primeiro índice da string em t3
    subi $s0, $t0, 1 #armazena o último índice da string em s0
    jal swap #reverte a string da linha atual
    j end_verify_reverse #caso a próxima linha seja "endfile" acabe o processo, se não, repita o processo
    
len:
    lb $t1, buffer($t0) #armazena o caractere atual em t1
    beq $t1, 10, jra #se t1 for quebra de linha ou fim da string, retorne
    beq $t1, 0, jra
    addi $v1,$v1, 1 #adiciona um na contagem de len
    addi $t0,$t0, 1 #avança para o próximo caractere da string
    j len #loop

swap:
    bge $t3, $s0, jra #se t3>=s0, então acabou a operação de swap, segue o código
    lb $t5, buffer($t3) #guarda o caractere de t3 em t5
    lb $t6, buffer($s0) #guarda o caractere de s0 em t6
    sb $t5, buffer($s0) #primeira parte da troca, coloca o caractere de t5 na string na posicao onde estava o caractere de t6
    sb $t6, buffer($t3) #segunda parte da troca, coloca o caractere de t6 na string na posicao onde estava o caractere de t5
    sb $t5, new_string($s0) #salva o caractere alterado numa nova string(que futuramante será o output)
    sb $t6, new_string($t3) #salva o caractere alterado numa nova string(que futuramante será o output)
    addi $t3, $t3,1 # avança para o próximo caractere da string(da esquerda pra direita)
    subi $s0, $s0,1 # avança para o próximo caractere da string(da direita pra esquerda)
    j swap # loop


jra:
    jr $ra

next_step: 
    addi $t0, $t0, 1
    j loop
    
to_upper:
    sub $t1, $t1, 32 # deixa maiusculo
    sb $t1, buffer($t0)
    sb $t1, new_string($t0) #salva o caractere alterado numa nova string(que futuramante será o output)
    j next_step      # proxima letra

to_lower:
    add $t1, $t1, 32 # deixa minusculo
    sb $t1, buffer($t0)
    sb $t1, new_string($t0) #salva o caractere alterado numa nova string(que futuramante será o output)
    j next_step      # proxima letra

end_verify:
    lb $t1, buffer($t0)
    sb $t1, new_string($t0) #salva a quebra de linha na nova string(que futuramante será o output)
    addi $t0, $t0, 1
    move $t2, $t0
    
    lb $t4, buffer($t2)                #carregando a letra em t4
    bne $t4,'e',loop                   #verificando se a letra ? diferente de 'e'
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
    beq $t4, 0, reverse
    beq $t4, 10, reverse
    j loop
    
    #checa se eh endfile
    
end_verify_reverse:
    lb $t1, buffer($t0)
    sb $t1, new_string($t0)
    addi $t0, $t0, 1
    move $t2, $t0
    
    lb $t4, buffer($t2)                #carregando a letra em t4
    bne $t4,'e',reverse_str                   #verificando se a letra ? diferente de 'e'
    addi $t2, $t2, 1                   # t2++
    lb $t4, buffer($t2)
    bne $t4, 'n',reverse_str
    addi $t2, $t2, 1
    lb $t4, buffer($t2)                
    bne $t4, 'd',reverse_str
    addi $t2, $t2, 1
    lb $t4, buffer($t2)
    bne $t4, 'f',reverse_str
    addi $t2, $t2, 1
    lb $t4, buffer($t2)
    bne $t4, 'i',reverse_str
    addi $t2, $t2, 1
    lb $t4, buffer($t2)
    bne $t4, 'l',reverse_str
    addi $t2, $t2, 1
    lb $t4, buffer($t2)
    bne $t4, 'e',reverse_str
    addi $t2, $t2, 1
    lb $t4, buffer($t2)
    beq $t4, 0, fim
    beq $t4, 10, fim
    j reverse_str
    
    #checa se eh endfile

clear_i:
    li $t3, 0 #zerando a contagem
    jr $ra

clear_t0:
    li $t0, 0 #zerando o t0
    jr $ra

fim: 
li $v1, 1                   #salvando 1 em $v1

#printando string 
li $v0, 4          
la $a0, new_string
syscall

#abrir arquivo
li $v0, 13			        #codigo para abrir arquivo
la $a0, arquivo_saida		#salvando nome de arquivo que queremos abrir no registrador $a0
li $a1, 1			        #escolhendo modo de escrita
syscall                     #chamando funcao
move $s1, $v0			    #passando o arquivo de v0 para s1

#escrever o arquivo
li $v0, 15			        #codigo para escrever arquivo
move $a0, $s1			    #passando os bytes de s1 como parametro da funcao 
la $a1, new_string			    #passando o buffer de output
li $a2, 512			        #tamanho de buffer definido em .data
syscall                     #chamando funcao

#fechar arquivo
li $v0, 16			        #codigo para fechar arquivo
move $a0, $s1			    #passando como parametro o arquivo aberto
syscall

li $v0, 10
syscall
#exemplo file:
#arquitetura
#3Home
#endfile
>>>>>>> 66dc80dfbe9ad2547a68f42bcb2b5ad87e000a54
