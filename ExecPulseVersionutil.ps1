
Write-host "Building DistributionList"
$path = $Deployed.targetPath + "\" + $Deployed.targetFileName
Write-host $path
Start-Process -FilePath $path -WorkingDirectory $Deployed.targetPath
