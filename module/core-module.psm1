$scriptRootPath = (Get-Item $PSScriptRoot).Parent.FullName
$scriptFiles = Get-ChildItem -path "$scriptRootPath\core\*.ps1"
foreach ($script in $scriptFiles)
{
    try
    {       
        . $script.FullName 
    }
    catch [System.Exception]
    {
        throw
    }
}