$serviceName = if($deployed.serviceName) { $deployed.serviceName } else { $deployed.name }

function Start-Service-With-Timeout($serviceName, $timeout) {

    $scriptBlock = {
        param($serviceName)
        Start-Service -Name $serviceName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $ServiceName

    Write-Host "Waiting for service [$serviceName] to start..."

    # wait until the service becomes responsive
    Wait-Job -Job $job -Timeout $timeout | Out-Null

    # wait until the service transitions Stopped -> StartPending -> Running
    $retries = 0;
    while ((Get-Service -Name $serviceName).Status -ne "Running") {
        Start-Sleep -Seconds 1 | Out-Null
        if($retries++ -ge $timeout) {
            $serviceStatus = (Get-Service -Name $serviceName).Status
            Write-Host "Cannot start service [$ServiceName]. Current state is [$serviceStatus] instead of [Running]. Please check the Services control panel and the Event Viewer."
            Exit 1
        }
    }

    # Wait for file handles to be released
    Start-Sleep -Seconds 1

    Write-Host "Service [$serviceName] has successfully been started."
}

#if($deployed.startupType -eq "Disabled") {
 if (Get-Service -Name "$serviceName" -ErrorAction SilentlyContinue)
{
    $Service = Get-WmiObject win32_service -filter "NAME = '$serviceName'"
    If ($Service.Startmode -eq "Disabled")
    {
        Write-Host "Unable to start service [$serviceName] because it has been disabled."
    } else {
        Write-Host "Starting service [$serviceName]."
        Start-Service-With-Timeout $serviceName $deployed.startTimeout
    }
}
else {Write-Host "Unable to start service [$serviceName] because it does not exist."}
