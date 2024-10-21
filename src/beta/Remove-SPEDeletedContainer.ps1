<#
.SYNOPSIS
    Deletes a container or all containers for the specified ContainerTypeId.
.DESCRIPTION
    Deletes a container for the specified ContainerId  or all containers for the specified ContainerTypeId.
.PARAMETER ContainerId
    The ContainerId of the container to delete.
.PARAMETER ContainerTypeId
    The ContainerTypeId of the containers to delete.
.EXAMPLE
    PS C:\> Remove-SPEDeletedContainer -ContainerId <Your Container Id>
    Deletes the container deleted with the specified ContainerId.
.EXAMPLE
    PS C:\> Remove-SPEDeletedContainer -ContainerTypeId <Your Container Type Id>
    Deletes all containers deleted for the specified ContainerTypeId.
#>

param(
    [Parameter(ParameterSetName='One', Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(ParameterSetName='All', Mandatory=$true)]
    [string] $ContainerTypeId
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    Switch($PSCmdlet.ParameterSetName) {
        'All' {
            $DeletedContainersData = .\beta\Get-SPEDeletedContainer -ContainerTypeId $ContainerTypeId
            $DeletedContainersCollection = $(ConvertFrom-Json $DeletedContainersData).value

            foreach($DeletedContainer in $DeletedContainersCollection) {
                $DeletedContainerId = $DeletedContainer.id
                $Request = Invoke-MgGraphRequest -Method DELETE -Uri "https://graph.microsoft.com/beta/storage/fileStorage/deletedContainers/$DeletedContainerId" -Body $Body -ErrorAction Stop
            }
        }
        'One' {
            $Request = Invoke-MgGraphRequest -Method DELETE -Uri "https://graph.microsoft.com/beta/storage/fileStorage/deletedContainers/$ContainerId" -Body $Body -ErrorAction Stop

            $Request
        }
    }
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Error -Message $_ -ErrorAction Stop
}