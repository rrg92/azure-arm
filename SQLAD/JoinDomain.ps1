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
$LogFile = "$PSCommandPath.log"

function log {
    $ts 	= (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $m	= "$ts " + ($Args -Join " ");

    
    $m | tee-object $LogFile -Append
}

log "Script started at $(Get-Date)...Log file is $LogFile"

try {

    if($Computers.count -eq 1){
        $Computers = $Computers -Split ",";
    }


    log "Domain: $Domain Computers: $Computers";

    #wait for domain!
    function WaitConnection($ip,$ports,$seconds = 120){

        $start = Get-Date;

        while( ((Get-Date) - $start).TotalSeconds -lt $seconds  ) {
            
            if($ports | ? {  -not(Test-NetConnection $ip -port $_ -InformationLevel Quiet) } ){
                Start-Sleep -s 1;
                continue;
            } else {
                return $true;
            }
        } 
        
        return $false;
    }

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
    if(WaitConnection $Domain 3389,88,135 500){
        while($true){
            try {
               Add-Computer -ComputerName $Computers -LocalCredential $LocalCredential -DomainName $Domain -Credential $DomainCredential -Restart -Force;
               break;
            } catch {
                $ErrorMsg = $_.Exception.Message;

                if($ErrorMsg -like "*The specified domain either does not exist or could not be contacted*"){
                    log "Waiting domain become available!"
                    Start-Sleep -s 60;
                    continue;
                } else {
                    throw;
                }
            }
        }
    } else {
        throw "AD_CONNECTION_UNAVAIL";
    }

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