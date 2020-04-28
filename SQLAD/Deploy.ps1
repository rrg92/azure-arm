<#
    .SYNOPSIS
        Deploy the SQLAD.json template!

    .DESCRIPTION
        Deploy a SQLAD template to a azure subscription. 
>#>
[CmdletBinding()]
param(
    #Resource group name
        $ResourceGroup
   
    ,#Region where create resource group
        $Region

    ,#Domain name when create the  doain
        $DomainName
    
    ,#USer and password to be used in machine administrators  and domain administrators
        $UserCredential = $null

    ,#AD Machine Size
        $AdMachineSize = $null

    ,#SQl Size
        $SQLMachineSize = $null

    ,#Other templates paraneters 
        $Params = @{}

    ,[switch]$Execute

    ,#Machine priority
        [switch]$RegularSQL

    ,#Machine priority
        [switch]$RegularAD
)

$ErrorActionPreference = "Stop";

$TemplateFile = "$PsScriptRoot\SQLAD.json";

if(-not(Test-Path $TemplateFile)){
    throw "TEMPLATE SQLAD not found!"
}


if(!$UserCredential){
    write-host "Provide credentials for user..."
    $UserCredential = Get-Credential;
}


if(!$DomainName){
    throw "INVALID_DOMAIN: $Domain"
}

if(!$ResourceGroup){
    throw "EMPTY_RESOURCEGROUP: $ResourceGroup"
}

if(!$Region){
    throw "EMPTY_REGION: $Region"
}


$Params['adminUsername']    = $UserCredential.GetNetworkCredential().UserName;
$Params['adminPassword']    = $UserCredential.GetNetworkCredential().Password;
$Params['DomainName']       = $DomainName;

if($AdMachineSize){
    $Params['AdMachineSize'] = $AdMachineSize
}

if($SQLMachineSize){
    $Params['SQLMachineSize'] = $SQLMachineSize
}

if($RegularSQL){
     $Params['SQLMachinePriority'] = "Regular"
}

if($RegularAD){
     $Params['ADMachinePriority'] = "Regular"
}

write-host "Getting Az module..."
import-module Az.Accounts;
import-module Az.Resources;


#Connect to the Azure!
$Context = Get-AzContext;

if(!$Context){
    throw "AZ_CONTEXT_NOTSET: Use Connect-AzAccount and Set-Azcontext to provide one!"
}



if($Execute){
    write-host "Trying create the resource group!"

    $NewResGroup = New-AzResourceGroup -Location $Region -Name $ResourceGroup;

    write-host "Starting the deploy..."
    $r = New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile $TemplateFile -TemplateParameterObject $Params -Verbose;
} else {
    write-host "Template file: " $TemplateFile
    write-host "Context Account:" $Context.Account
    write-host "Resource Group: " $ResourceGroup
    write-host "Resource Group: " $Region
    write-host ($Params|out-string)
}








