param(
    $DomainName = $Env:AD_DOMAIN_NAME
    , $SafePassword = $Env:AD_SAFE_PASSWORD
    ,[switch]$NoExitCode
)

$ErrorActionPreference = "Stop";
$LogFile = "$PsScriptRoot.log"

function log {
    $ts 	= (Get-Date).ToString("yyyy-MM-SS HH:mm:ss")
    $m	= "$ts " + ($Args -Join " ");

    
    $m | tee-object $LogFile
}

log "Script started at $(Get-Date)..."

try {
    log "Domain: $DomainName"

    if(!$DomainName){
        throw "INVALID_DOMAIN: EMPTY_DOMAIN"
    }

    #Get the first part!
    $DomainParts = $DomainName.split('.');

    if($DomainParts.length -eq 1){
        throw "INVALID_DOMAIN: TOP_LEVEL_NOTSUPPORTED: $DomainName"
    }

    $DomainNetBios = $DomainParts[0];
    log "   DomainNetBios: $DomainNetBios".


    log "Installing window feature AD-Domain-Services"
    Install-WindowsFeature AD-Domain-Services

    log "Importing ad deployment module"
    Import-Module ADDSDeployment

    $SecureStringSafePassword = ConvertTo-SecureString -String $SafePassword -AsPlainText -Force;

    $AdForestParams = @{
        CreateDnsDelegation     = $false
        DatabasePath            = 'C:\Windows\NTDS'
        DomainMode              = 'Win2012R2'
        DomainName              = $DomainName
        DomainNetbiosName       = $DomainNetBios
        ForestMode              = "Win2012R2"
        InstallDns              = $true
        LogPath                 = 'C:\Windows\NTDS'
        NoRebootOnCompletion    = $false
        SysvolPath              = 'C:\Windows\SYSVOL'
        Force                   = $true
        SafeModeAdministratorPassword = $SecureStringSafePassword
    }

    Log "Installing forest...";
    Install-ADDSForest @AdForestParams;
    $ExitCode = 0;
} catch {
    $ExitCode = 1;
    log "INSTALL FOREST FAIL: $_";
} finally {
    if(!$NoExitCode){
        exit $ExitCode
    }
}