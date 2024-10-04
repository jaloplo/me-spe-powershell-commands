<#
.SYNOPSIS
    Retrieves all properties of a container or a specific property of a container.
.DESCRIPTION
    Retrieves all properties of a container or a specific property of a container.
.PARAMETER ContainerId
    The ContainerId of the container to retrieve the properties.
.PARAMETER PropertyName
    The name of the property to retrieve.
.EXAMPLE
    PS C:\> Get-SPEContainerProperty -ContainerId <Your Container Id>
    Retrieves all properties of the container with the specified ContainerId.
.EXAMPLE
    PS C:\> Get-SPEContainerProperty -ContainerId <Your Container Id> -PropertyName "MyProperty"
    Retrieves the property "MyProperty" of the container with the specified ContainerId.
#>

param(
    [Parameter(ParameterSetName='One', Mandatory=$true)]
    [Parameter(ParameterSetName='All', Mandatory=$true)]
    [string] $ContainerId,
    
    [Parameter(ParameterSetName='One', Mandatory=$true)]
    [string] $PropertyName
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    Switch($PSCmdlet.ParameterSetName) {
        'All' {
            $Request = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/customProperties" -ErrorAction Stop

            ConvertTo-Json -InputObject $Request
        }
        'One' {
            $Request = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/customProperties/$PropertyName" -ErrorAction Stop

            ConvertTo-Json -InputObject $Request
        }
    }
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}