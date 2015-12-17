$serviceName = if($deployed.serviceName) { $deployed.serviceName } else { $deployed.name }

function Stop-Service-With-Timeout($serviceName, $timeout) {

    $scriptBlock = {
        param($serviceName)
        Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $ServiceName

    Write-Host "Waiting for service [$serviceName] to stop..."

    # wait until the service becomes responsive
    Wait-Job -Job $job -Timeout $timeout | Out-Null

    # wait until the service transitions Running -> StopPending -> Stopped
    $retries = 0;
    while ((Get-Service -Name $serviceName).Status -ne "Stopped") {
        Start-Sleep -Seconds 1 | Out-Null
        if($retries++ -ge $timeout) {
            $serviceStatus = (Get-Service -Name $serviceName).Status
            Write-Host "Cannot stop service [$ServiceName]. Current state is [$serviceStatus] instead of [Stopped]. Please check the Services control panel and the Event Viewer."
            Exit 1
        }
    }

    # Wait for file handles to be released
    Start-Sleep -Seconds 1

    Write-Host "Service [$serviceName] has successfully been stopped."
}

if (Get-Service -Name "$serviceName" -ErrorAction SilentlyContinue)
     {
      Write-Host "Stopping service [$serviceName]."
      Stop-Service-With-Timeout $serviceName $deployed.stopTimeout
     }
else {
      Write-Host "Unable to stop service [$serviceName] because it does not exist."
     }