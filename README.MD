# Azure ARM Templates

Este repositório fornece alguns templates do Azure Resource Manager (ARM).  

Esta feature do azure permite que você crie diversos ambientes usando um arquivo `json`!

Se você não conhece a sintae, recomendo começar pela documentação em:  
https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax

Lá tem tutorias bem bacanas! Outra dica, é fazer o deploy pelo portal exportar o template que ele gera!  Explore-o!
Isso vai te ajudar a aprender também!

## Organização

Este repositório está organizando em subdiretórios. Cada um deles representa um template que implementa algo.  
Cada subdiretório deverá conter um `README` explicando o objetivo dele e como usá-lo!  

Arquivos adicionais podem ser fornecidos! Cada caso é um caso!  
Se as instruções não estiverem claras ou estiver faltando algo, abra uma Issue ou Pull Request!

## Como testar os templates

Você pode testar estes templates copiando eles para o portal do Azure. Procure por `Templates`, e então você vai encontrar as opções para fazer o upload de um arquivo ou mesmo copiar e colar!
Porém, isso pode ficar chato se você precisar fazer testes frequentes (caso queria modificar, por exemplo).

Por isso, recomendo usar o [módulo do Azure] para powershell (chamado `Az`)

O cmdlet que te permitirá fazer isso é o [Test-AzResourceGroupDeployment]:

```posh
import-module Az.Resources;

Test-AzResourceGroupDeployment -TemplateFile FilePath -ResourceGroupName ResourceGroupName -TemplateParameterObject @{  Param1 = "Valor1"; Param2 = Valor2; Param3 = Valor1,Valor2,Valor3  }
```

Você deverá está conectando a uma conta válida do azure, uma vez que o teste valida syntaxe e também a existência do resource group.  
Consulte o help para mais informações!

# Regiões do Azure (location parameter)

Muitos dos parâmetros no template envolvem especificar uma região, geralmente através do nome `location`.  
Você pode usar a seguinte referência para saber mais sobre as regiões:  
https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/resource-location?tabs=azure-powershell

O seguinte comando também pode ser útil:

```posh
Get-AzLocation
```

# Imagens

As imagens especificam qual é o sistema operacional que vai rodar em uma determinada máquina!
É interessante aprender como o Azure organiza estas imagens. Aqui uma referência e alguns links úteis

* Conceitos  
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage

* Objeto `imageReference` (referência ARM template)  
https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/2019-07-01/virtualmachines#ImageReference


* Passo a passo para encontrar uma imagem  (você precisará procurar em uma região específica)

```posh

#1. Encontre um `publsher`  
Get-AzVMImagePublisher -Location $locName | Select PublisherName

#2. Encontre uma `offer` de um `publisher`
Get-AzVMImageOffer -Location $locName -PublisherName $pubName | Select Offer

#3. Encontra uma `SKU`
Get-AzVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName | Select Skus

#4. Encontra uma versão da SKU (a imagem propriamente em si)
Get-AzVMImage -Location $locName -PublisherName $pubName -Offer $offerName -Sku $skuName | Select Version

```
**Dica**: Geralmente especificando o nome `latest` na versão, você referencia a última versão daquele SKU.
    
Por Exemplo, no caso de uma imagem SQL Server:

* O publisher é MicrosoftSQLServer
* A offer é a versão e sistema operacional, por exemplo SQL Server 2019, em um Wndows Server 2019 (o nome da offer é `sql2019-ws2019`)
* A SKU é a edição (developer, enterprise, etc.). Por exemplo, para a offer `sql2019-ws2019`, temos uma SKU `sqldev` (SQL Serverloper)
* A imagem é a versão sql 2019 developer com algum cumulative update aplicado. Geralmente será o build number 15.XX.YYYY (consulte sempre com os comandos acima para obter um valor atualizado)


Se você quiser, pode usar o site [https://az-vm-image.info/] para uma interface mais amigável!


[módulo do Azure]: https://docs.microsoft.com/en-us/powershell/azure/install-az-ps
[Test-AzResourceGroupDeployment]: https://docs.microsoft.com/en-us/powershell/module/az.resources/test-azresourcegroupdeployment?view=azps-3.3.0
[https://az-vm-image.info/]: https://az-vm-image.info/
