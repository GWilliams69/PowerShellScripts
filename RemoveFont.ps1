#*********************************************
#Declare Parameters
#*********************************************
param(
	[string] $file = "glyphicons-halflings-regular.ttf",
	[switch] $help = $false
)


#*********************************************
#Declare Global Variables and Constants
#*********************************************

$hashFontFileTypes.Add(".ttf"," (TrueType)")
$fontRegistryPath = "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
$fontsFolderPath = "C:\inetpub\wwwroot\PulseUnifiedAPIToken\fonts"
function Remove-SingleFont($file)

#*******************************************************************
# Function Remove-SingleFont()
#
# Purpose:  Uninstall a font file
#
# Input:    $file    Font file name
#
# Returns:  0 - success, 1 - failure
#
#*******************************************************************
function Remove-SingleFont($file)
{
    try
    {
        $fontFinalPath = Join-Path $fontsFolderPath $file
        $retVal = [FontResource.AddRemoveFonts]::RemoveFont($fontFinalPath)
        if ($retVal -eq 0) {
            Write-Host "Font `'$($file)`' removal failed"
            Write-Host ""
            1
        }
        else
        {
            $fontRegistryvaluename = (Get-RegistryStringNameFromValue $fontRegistryPath $file)
            Write-Host "Font: $($fontRegistryvaluename)"
            if ($fontRegistryvaluename -ne "")
            {
                Remove-ItemProperty -path $fontRegistryPath -name $fontRegistryvaluename
            }
            Remove-Item $fontFinalPath
            if ($error[0] -ne $null)
            {
                Write-Host "An error occured removing $`'$($file)`'"
                Write-Host ""
                Write-Host "$($error[0].ToString())"
                $error.clear()
            }
            else
            {
                Write-Host "Font `'$($file)`' removed successfully"
                Write-Host ""
            }
            0
        }
        ""
    }
    catch
    {
        Write-Host "An error occured removing `'$($file)`'"
        Write-Host ""
        Write-Host "$($error[0].ToString())"
        Write-Host ""
        $error.clear()
        1
    }
}
	
