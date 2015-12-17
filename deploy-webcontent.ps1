# Remove old web content if it's still there
if (Test-Path $deployed.targetPath) {
	Write-Host "Removing old web content from [$($deployed.targetPath)]."
	#Remove-Item -Recurse -Force $deployed.targetPath
}

# Copy new web content
Write-Host "Copying web content to [$($deployed.targetPath)]."
Copy-Item -Recurse -Force $deployed.file $deployed.targetPath
