<#
.SYNOPSIS
    Deletes a permission from a container.
.DESCRIPTION
    Deletes a permission from a container. The permission is deleted from the container only if the user is a member of the container.
.PARAMETER ContainerId
    The ContainerId of the container to delete the permission from.
.PARAMETER PermissionId
    The Id of the permission to delete.
.EXAMPLE
    PS C:\> Remove-SPEContainerPermission -ContainerId <Your Container Id> -PermissionId <Your Permission Id>
    Deletes the permission with the specified PermissionId from the container with the specified ContainerId. The permission is deleted from the container only if the user is a member of the container.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $PermissionId
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Request = Invoke-MgGraphRequest -Method DELETE -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/permissions/$PermissionId" -ErrorAction Stop

    $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Error -Message $_ -ErrorAction Stop
}