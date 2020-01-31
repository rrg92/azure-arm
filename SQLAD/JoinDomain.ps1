param(
         [string[]]$Computers = @()
        ,[string]$Domain
        ,[string]$User
        ,[string]$Password
        ,[string]$DomainUser
        ,[string]$DomainPassword
        ,[switch]$NoExitCode
)

$ErrorActionPreference = "Stop";
$LogFile = "$PsScriptRoot.log"

function log {
    $ts 	= (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $m	= "$ts " + ($Args -Join " ");

    
    $m | tee-object $LogFile
}

log "Script started at $(Get-Date)...Log file is $LogFile"

try {

    if($Computers.count -eq 1){
        $Computers = $Computers -Split ",";
    }


    log "Domain: $Domain Computers: $Computers";

    #Get the first part!
    $DomainParts = $Domain.split('.');
    $DomainNetBios = $DomainParts[0].ToUpper();

    $UserSecPasswod = ConvertTo-SecureString $Password -AsPlainText -Force
    $LocalCredential = New-Object System.Management.Automation.PSCredential ($User, $UserSecPasswod)
    log "Local user: $User";

    if(!$DomainUser){
        $DomainUser = $User
    }

    if(!$DomainPassword){
        $DomainPassword = $Password
    }

    $FullDomainUser = "$DomainNetBios\$DomainUser"
    $DomainSecPasswod = ConvertTo-SecureString $DomainPassword  -AsPlainText -Force
    $DomainCredential = New-Object System.Management.Automation.PSCredential ($FullDomainUser, $DomainSecPasswod)
    log "Local user: $FullDomainUser";

    log "Invoking add computer..."
    Add-Computer -ComputerName $Computers -LocalCredential $LocalCredential -DomainName $Domain -Credential $DomainCredential -Restart -Force;
    log "SUCCESS!"
} catch {
    $ExitCode = 1;
    log "FAIL: $_";
    throw;
} finally {
    if(!$NoExitCode){
        exit $ExitCode
    }
}