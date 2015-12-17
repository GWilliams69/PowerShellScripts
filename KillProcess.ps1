# PowerShell 'Stops' Windows Process
$processName = if($deployed.processName) { $deployed.processName } else { $deployed.name }
Clear-Host 

$process = Get-Process $processName -ErrorAction silentlycontinue
if ($process) {
   Write-Host "Stopping process [$processName]."
   Stop-Process -name $processName -Force
}
else {
  "does not exist"
}
