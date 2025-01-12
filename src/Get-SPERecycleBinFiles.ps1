<#
.SYNOPSIS
    Retrieves a list of files in the recycle bin for the specified ContainerId.
.DESCRIPTION
    Retrieves a list of files in the recycle bin for the specified ContainerId. The recycle bin is a special container that contains all deleted files in the specified container.
.PARAMETER ContainerId
    The ContainerId of the container to retrieve the recycle bin files.
.EXAMPLE
    PS C:\> Get-SPERecycleBinFiles -ContainerId b!akAYUllX7vCyqZXOFnr31G_74G4KisBBmvqKuWKLsyYlz6F-WeE9TZwy2sfPOorE
    Retrieves a list of files in the recycle bin for the specified ContainerId.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Request = Invoke-MgGraphRequest -Method GET -Uri $("https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/recycleBin/items") -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    $_
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}