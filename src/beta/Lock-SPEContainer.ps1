<#
.SYNOPSIS
    Locks a container.
.DESCRIPTION
    Locks a container for modifications.
.PARAMETER ContainerId
    The ContainerId of the container to lock.
.EXAMPLE
    PS C:\> Lock-SPEContainer -ContainerId <Your Container Id>
    Locks the container with the specified ContainerId. The container is locked for modifications.
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
    $Body = @{
        lockState = "lockedReadOnly"
    }

    $Request = Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/beta/storage/fileStorage/containers/$ContainerId/lock" -Body $Body -ErrorAction Stop
    $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Error -Message $_ -ErrorAction Stop
}