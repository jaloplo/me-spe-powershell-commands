<#
.SYNOPSIS
    Deletes a container or all containers for the specified ContainerTypeId.
.DESCRIPTION
    Deletes a container for the specified ContainerId or all containers for the specified ContainerTypeId.
.PARAMETER ContainerId
    The ContainerId of the container to delete.
.PARAMETER ContainerTypeId
    The ContainerTypeId of the containers to delete.
.EXAMPLE
    PS C:\> Remove-SPEContainer -ContainerId <Your Container Id>
    Deletes the container with the specified ContainerId.
.EXAMPLE
    PS C:\> Remove-SPEContainer -ContainerTypeId <Your Container Type Id>
    Deletes all containers for the specified ContainerTypeId.
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
            $ContainersData = .\Get-SPEContainer -ContainerTypeId $ContainerTypeId
            $ContainersCollection = $(ConvertFrom-Json $ContainersData).value

            foreach($Container in $ContainersCollection) {
                $ContainerId = $Container.id
                $Request = Invoke-MgGraphRequest -Method DELETE -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId" -Body $Body -ErrorAction Stop
            }
        }
        'One' {
            $Request = Invoke-MgGraphRequest -Method DELETE -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId" -Body $Body -ErrorAction Stop
    
            $Request
        }
    }
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Error -Message $_ -ErrorAction Stop
}