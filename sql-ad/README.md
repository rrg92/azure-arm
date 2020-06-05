#  sql-ad: Crie um domínio com SQL Servers

Cria um domínio, com um controlador de domínio e variáveis números de nodes.
Os valores padrões são úteis para construir AlwaysON com SQL Server.

Parametros obrigatórios:

* Usuário e senha
* Nome do domínio ( PART1.PART2, ex.: thesqltimes.corp )

O número de máquinas membros do domínio é controlado pelo parâmetr `IpSQL`. Cada IP deve ser separado por vírgula e entre aspas duplas (syntaxe de array).  
Se alterar a rede do IP, alterar também no parâmetro `NetworkRange`.   
 
O template irá usar o nome do resource group como base!  
Recomendo implantar este template em um resource group vazio!


# Estrutura criada

* Uma máquina virtual, que é o controlador de domínio
    - A máquina será promovida a controladora de domínio


* Máquinas virtuais
    - Cada máquina terá as mesmas configurações
    - Ao final, elas serão incluídas no domínio criado