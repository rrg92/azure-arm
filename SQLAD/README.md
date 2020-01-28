# Template SQLAD

Cria um domínio com um controlador de domínio e membros com SQL Server instalado!

Parametros obrigatórios:

* Usuário e senha
* Nome do domínio


O template irá usar o nome do resource group como base!  
Recomendo implantar este template em um resource group vazio!


# Estrutura criada

* Uma máquina que é o controlador de domínio
    - Está máquina terá duas interfaces de rede: uma pública e uma interna.
    - A interface pública é para o Ip Público da máquina
    - A interface interna é para o IP interno
    - A máquina será promovida a controladora de domínio


* Mínimo de 2 máquinas com SQL Server instalado
    * Cada máquina SQL
        - Terá duas interfaces de rede: uma pública e uma interna.
        - A interface pública é para o Ip Público da máquina
        - A interface interna é para o IP interno
        - A interface interna terá como DNS, o AD.
        - Discos adicionais de 64GB. O número de discos é variável.

