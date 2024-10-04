<#
.SYNOPSIS
    Adds a number column to a container.
.DESCRIPTION
    Adds a number column to a container. The column is added to the container only if the column does not already exist.
.PARAMETER ContainerId
    The ContainerId of the container to add the column to.
.PARAMETER Name
    The name of the column to add.
.PARAMETER Description
    The description of the column.
.PARAMETER EnforceUniqueValues
    Specifies whether the column should enforce unique values. The default value is false.
.PARAMETER Minimum
    The minimum value of the column. The default value is 0.
.PARAMETER Maximum
    The maximum value of the column. The default value is 100.
.EXAMPLE
    PS C:\> Add-SPEContainerNumberColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -EnforceUniqueValues -Minimum 0 -Maximum 100
    Adds a number column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column enforces unique values and has a minimum value of 0 and a maximum value of 100.
.EXAMPLE
    PS C:\> Add-SPEContainerNumberColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -Minimum 0 -Maximum 100
    Adds a number column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column does not enforce unique values and has a minimum value of 0 and a maximum value of 100.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $Name,
    [string] $Description,
    [switch] $EnforceUniqueValues,
    [int] $Minimum = 0,
    [int] $Maximum = 100
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        displayName = $Name
        description = $Description
        number = @{
            maximum = $Maximum
            minimum = $Minimum
        }
    }

    If($PSBoundParameters.ContainsKey('EnforceUniqueValues')) {
        $Body.Add('enforceUniqueValues', $EnforceUniqueValues.ToBool())
    }

    $Request = Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/beta/storage/fileStorage/containers/$ContainerId/columns" -Body $Body -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}