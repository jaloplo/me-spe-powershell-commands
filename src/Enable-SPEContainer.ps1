<#
.SYNOPSIS
    Activates a container.
.DESCRIPTION
    Activates a container for the specified ContainerId.
.PARAMETER ContainerId
    The ContainerId of the container to activate.
    You can activate a container to make it available for use.
.EXAMPLE
    PS C:\> Enable-SPEContainer -ContainerId <Your Container Id>
    Activates the container with the specified ContainerId.
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
    $Request = Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/activate" -ErrorAction Stop

    $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}