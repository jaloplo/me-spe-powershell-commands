<#
.SYNOPSIS
    Retrieves a list of containers for the specified ContainerTypeId or retrieve a specific container for the specified ContainerId.
.DESCRIPTION
    Retrieves a list of containers for the specified ContainerTypeId or retrieve a specific container for the specified ContainerId.
.PARAMETER ContainerTypeId
    The ContainerTypeId of the containers to retrieve.
.PARAMETER ContainerId
    The ContainerId of the container to retrieve.
.EXAMPLE
    PS C:\> Get-SPEContainer -ContainerTypeId 21ca259c-ab7e-0175-13e2-d0fd01f3d2e7
    Retrieves a list of containers for the specified ContainerTypeId.
.EXAMPLE
    PS C:\> Get-SPEContainer -ContainerId b!akAYUllX7vCyqZXOFnr31G_74G4KisBBmvqKuWKLsyYlz6F-WeE9TZwy2sfPOorE
    Retrieves a specific container for the specified ContainerId.
#>

param(
    [Parameter(ParameterSetName='All', Mandatory=$true)]
    [string] $ContainerTypeId,

    [Parameter(ParameterSetName='One', Mandatory=$true)]
    [string] $ContainerId
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    Switch($PSCmdlet.ParameterSetName) {
        'All' {
            $Request = Invoke-MgGraphRequest -Method GET -Uri $('https://graph.microsoft.com/v1.0/storage/fileStorage/containers?$filter=containerTypeId eq ' + $ContainerTypeId) -ErrorAction Stop

            ConvertTo-Json -InputObject $Request
        }
        'One' {
            $Request = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId" -ErrorAction Stop

            ConvertTo-Json -InputObject $Request
        }
    }
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}