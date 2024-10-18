<#
.SYNOPSIS
    Updates a permission of a container.
.DESCRIPTION
    Updates a permission of a container. You can update the role of a permission for the specified role and login. The permission is updated in the container only if the user is a member of the container.
.PARAMETER ContainerId
    The ContainerId of the container to update the permission of.
.PARAMETER PermissionId
    The Id of the permission to update.
.PARAMETER Role
    The role of the permission to update. The role can be "reader", "writer", "manager" or "owner".
.EXAMPLE
    PS C:\> Set-SPEContainerPermission -ContainerId <Your Container Id> -PermissionId <Your Permission Id> -Role "reader"
    Updates the permission with the specified PermissionId to a reader permission in the container with the specified ContainerId.
.EXAMPLE
    PS C:\> Set-SPEContainerPermission -ContainerId <Your Container Id> -PermissionId <Your Permission Id> -Role "writer"
    Updates the permission with the specified PermissionId to a writer permission in the container with the specified ContainerId.
.EXAMPLE
    PS C:\> Set-SPEContainerPermission -ContainerId <Your Container Id> -PermissionId <Your Permission Id> -Role "manager"
    Updates the permission with the specified PermissionId to a manager permission in the container with the specified ContainerId.
.EXAMPLE
    PS C:\> Set-SPEContainerPermission -ContainerId <Your Container Id> -PermissionId <Your Permission Id> -Role "owner"
    Updates the permission with the specified PermissionId to an owner permission in the container with the specified ContainerId.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $PermissionId,
    [Parameter(Mandatory=$true)]
    [ValidateSet("reader", "writer", "manager", "owner")]
    [string] $Role
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        roles = @($Role)
    }

    $Request = Invoke-MgGraphRequest -Method PATCH -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/permissions/$PermissionId" -Body $Body -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Error -Message $_ -ErrorAction Stop
}