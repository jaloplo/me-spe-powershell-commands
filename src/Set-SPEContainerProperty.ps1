<#
.SYNOPSIS
    Creates or updates a property of a container.
.DESCRIPTION
    Creates or updates a property of a container. You can make the property searchable. If the property already exists, it will be updated. Otherwise, it will be created.
.PARAMETER ContainerId
    The ContainerId of the container to update.
.PARAMETER PropertyName
    The name of the property to update. The name must be unique. It cannot be changed after the property is created.
.PARAMETER PropertyValue
    The value of the property to update.
.PARAMETER Searchable
    Specifies whether the property is searchable. The default value is false.
.EXAMPLE
    PS C:\> Set-SPEContainerProperty -ContainerId <Your Container Id> -PropertyName "MyProperty" -PropertyValue "MyValue" -Searchable
    Creates or updates the property "MyProperty" with the value "MyValue" and makes it searchable.
.EXAMPLE
    PS C:\> Set-SPEContainerProperty -ContainerId <Your Container Id> -PropertyName "MyProperty" -PropertyValue "MyValue"
    Creates or updates the property "MyProperty" with the value "MyValue". The property is not searchable.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $PropertyName,
    [Parameter(Mandatory=$true)]
    [string] $PropertyValue,
    [switch] $Searchable
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        $PropertyName = @{
            value = $PropertyValue
        }
    }

    If($PSBoundParameters.ContainsKey('Searchable')) {
        $Body[$PropertyName].Add("isSearchable", $Searchable.ToBool())
    }

    $Request = Invoke-MgGraphRequest -Method PATCH -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/customProperties" -Body $Body -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}