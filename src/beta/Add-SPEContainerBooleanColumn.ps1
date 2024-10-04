<#
.SYNOPSIS
    Adds a boolean column to a container.
.DESCRIPTION
    Adds a boolean column to a container. The column is added to the container only if the column does not already exist.
.PARAMETER ContainerId
    The ContainerId of the container to add the column to.
.PARAMETER Name
    The name of the column to add.
.PARAMETER Description
    The description of the column.
.PARAMETER EnforceUniqueValues
    Specifies whether the column should enforce unique values. The default value is false.
.EXAMPLE
    PS C:\> Add-SPEContainerBooleanColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -EnforceUniqueValues
    Adds a boolean column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist.
.EXAMPLE
    PS C:\> Add-SPEContainerBooleanColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column"
    Adds a boolean column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column does not enforce unique values.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $Name,
    [string] $Description,
    [switch] $EnforceUniqueValues
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        displayName = $Name
        description = $Description
        boolean = @{}
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