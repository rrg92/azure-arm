param($Script)

if($script -is [string] -and (Test-path $script)){
    $script = get-content $script | out-string
}

return [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($script.ToString()));