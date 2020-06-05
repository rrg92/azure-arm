#  X-VM: Crie X Virtual Machines

Este template permite criar um número variável de máquinas virtuais com a mesma configuração (por isso o X).  
Especifique o número no parâmetro `Ips`. Este parâmetro controla os ips utilizados em cada máquina, e, consequentemente, o número de máquinas.  

Especifique IPs na rede definida por `NetworkRange`, pois é com base nesse parâmetro que ele irá configurar a virtual network!

O nome do Resource Group será usado como prefixo no nome dos recursos.

## Resumo dos recursos criados

* 1 virtual network
  - O nome será `NomeResourceGroup`-NETWORK
* X IPs públicos
  - O nome será `NomeResourceGroup`-PIP-`NumeroMaquina` (NumeroMaquina começa em 1)
* X interfaces de redes
  - O nome será `NomeResourceGroup`-NETINTERFACE-PIP-`NumeroMaquina` (NumeroMaquina começa em 1)
* X máquina virtuais
  - Cada máquina usará o Windows
  - O nome será `NomeResourceGroup`-VM-`NumeroMaquina` (NumeroMaquina começa em 1)

Onde `X` é o número de IPs definido no parâmetro `Ips`