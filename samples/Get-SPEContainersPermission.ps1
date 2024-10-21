<#
.SYNOPSIS
    Retrieves the permissions of all containers for the specified ContainerTypeId and returns a hash per user.
.DESCRIPTION
    Retrieves the permissions of all containers for the specified ContainerTypeId and returns a hash per user. The hash contains the roles and the container ids of the containers that the user has permissions to.
.PARAMETER ContainerTypeId
    The ContainerTypeId of the containers to retrieve.
.EXAMPLE
    PS C:\> Get-SPEContainersPermission -ContainerTypeId 21ca259c-ab7e-0175-13e2-d0fd01f3d2e7
    Retrieves the permissions of all containers for the specified ContainerTypeId and returns a hash per user.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerTypeId
)

$ContainersData = .\Get-SPEContainer -ContainerTypeId $ContainerTypeId

$ContainersCollection = $(ConvertFrom-Json $ContainersData).value

$UsersReport = @{}

foreach($Container in $ContainersCollection) {
    $PermissionsData = .\Get-SPEContainerPermission -ContainerId $Container.id

    $PermissionsCollection = $(ConvertFrom-Json $PermissionsData).value

    foreach($Permission in $PermissionsCollection) {
        $UsersReport[$Permission.grantedToV2.user.email] += @(@{
            Role = $Permission.roles -join ", "
            ContainerId = $Container.id
            ContainerName = $Container.displayName
        })
    }
}

$UsersReport