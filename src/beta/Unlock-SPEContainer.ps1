<#
.SYNOPSIS
    Unlocks a container.
.DESCRIPTION
    Unlocks a container for modifications.
.PARAMETER ContainerId
    The ContainerId of the container to unlock.
.EXAMPLE
    PS C:\> Unlock-SPEContainer -ContainerId <Your Container Id>
    Unlocks the container with the specified ContainerId. The container is unlocked for modifications.
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
    $Request = Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/beta/storage/fileStorage/containers/$ContainerId/unlock" -ErrorAction Stop
    $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Error -Message $_ -ErrorAction Stop
}