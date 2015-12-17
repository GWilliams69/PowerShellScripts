

# Copy new web content
Write-Host "Copying web content to [$($deployed.targetPath)]."
Copy-Item -Recurse -Force $deployed.file $deployed.targetPath
