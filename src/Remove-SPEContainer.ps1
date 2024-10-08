<#
.SYNOPSIS
    Deletes a container.
.DESCRIPTION
    Deletes a container for the specified ContainerId.
.PARAMETER ContainerId
    The ContainerId of the container to delete.
.EXAMPLE
    PS C:\> Remove-SPEContainer -ContainerId <Your Container Id>
    Deletes the container with the specified ContainerId.
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
    $Request = Invoke-MgGraphRequest -Method DELETE -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId" -Body $Body -ErrorAction Stop

    $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}