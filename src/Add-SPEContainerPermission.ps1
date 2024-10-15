<#
.SYNOPSIS
    Adds a permission to a container.
.DESCRIPTION
    Adds a permission to a container. You can add permissions to a container for the specified role and login. The permission is added to the container only if the user is not already a member of the container.
.PARAMETER ContainerId
    The ContainerId of the container to add the permission to.
.PARAMETER Role
    The role of the permission to add. The role can be "reader", "writer", "manager" or "owner".
.PARAMETER Login
    The login of the user to add the permission to.  The login can be the email address or the user principal name.
.EXAMPLE
    PS C:\> Add-SPEContainerPermission -ContainerId <Your Container Id> -Role "reader" -Login <Your Login>
    Adds a reader permission to the container with the specified ContainerId and login.
.EXAMPLE
    PS C:\> Add-SPEContainerPermission -ContainerId <Your Container Id> -Role "writer" -Login <Your Login>
    Adds a writer permission to the container with the specified ContainerId and login.
.EXAMPLE
    PS C:\> Add-SPEContainerPermission -ContainerId <Your Container Id> -Role "manager" -Login <Your Login>
    Adds a manager permission to the container with the specified ContainerId and login.
.EXAMPLE
    PS C:\> Add-SPEContainerPermission -ContainerId <Your Container Id> -Role "owner" -Login <Your Login>
    Adds an owner permission to the container with the specified ContainerId and login.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [ValidateSet("reader", "writer", "manager", "owner")]
    [string] $Role,
    [Parameter(Mandatory=$true)]
    [string] $Login
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        roles = @($Role)
        grantedToV2 = @{
            user = @{
                userPrincipalName = $Login
            }
        }
    }

    $Request = Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/permissions" -Body $Body -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}