<#
.SYNOPSIS
    Adds a manager permission to a container.
.DESCRIPTION
    Adds a manager permission to a container. You can add permissions to a container for the specified role and login. The permission is added to the container only if the user is not already a member of the container.
.PARAMETER ContainerId
    The ContainerId of the container to add the permission to.
.PARAMETER Login
    The login of the user to add the permission to. The login can be the email address or the user principal name.
.EXAMPLE
    PS C:\> Add-SPEContainerManagerPermission -ContainerId <Your Container Id> -Login <Your Login>
    Adds a manager permission to the container with the specified ContainerId and login.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $Login
)

Try {
    .\Add-SPEContainerPermission.ps1 -ContainerId $ContainerId -Role manager -Login $Login
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}