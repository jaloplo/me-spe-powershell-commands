<#
.SYNOPSIS
    Deletes a file from a container.
.DESCRIPTION
    Deletes a file from a container. The file is move to the recycle bin.
.PARAMETER ContainerId
    The ContainerId of the container to delete the file.
.PARAMETER FileId
    The Id of the file to delete.
.EXAMPLE
    PS C:\> Remove-SPEFile -ContainerId <Your Container Id> -FileId <Your File Id>
    Deletes the file with the specified FileId from the container with the specified ContainerId.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $FileId
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Request = Invoke-MgGraphRequest -Method DELETE -Uri $("https://graph.microsoft.com/v1.0/drives/$ContainerId/items/$FileId") -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}