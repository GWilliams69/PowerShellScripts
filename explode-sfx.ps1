Write-host "Extracting $Deployed.TargetFileName"
$process = Start-Process -filepath $Deployed.TargetFileName -WorkingDirectory $Deployed.targetPath -NoNewWindow -PassThru -Wait
$process.ExitCode
