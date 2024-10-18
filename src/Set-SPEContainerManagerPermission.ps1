<#
.SYNOPSIS
    Sets the manager permission of a permission Id in a container.
.DESCRIPTION
    Sets the manager permission of a permission Id in a container. The permission is updated in the container only if the user is a member of the container.
.PARAMETER ContainerId
    The ContainerId of the container to update the permission of.
.PARAMETER PermissionId
    The Id of the permission to update.
.EXAMPLE
    PS C:\> Set-SPEContainerManagerPermission -ContainerId <Your Container Id> -PermissionId <Your Permission Id>
    Sets the manager permission of the permission with the specified PermissionId in the container with the specified ContainerId. The permission is updated in the container only if the user is a member of the container.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $PermissionId
)
Try {
    .\Set-SPEContainerPermission.ps1 -ContainerId $ContainerId -Role manager -PermissionId $PermissionId
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Error -Message $_ -ErrorAction Stop
}