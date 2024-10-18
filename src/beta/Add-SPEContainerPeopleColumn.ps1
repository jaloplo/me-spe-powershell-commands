<#
.SYNOPSIS
    Adds a people column to a container.
.DESCRIPTION
    Adds a people column to a container. The column is added to the container only if the column does not already exist.
.PARAMETER ContainerId
    The ContainerId of the container to add the column to.
.PARAMETER Name
    The name of the column to add.
.PARAMETER Description
    The description of the column.
.PARAMETER EnforceUniqueValues
    Specifies whether the column should enforce unique values. The default value is false.
.PARAMETER MultipleSelection
    Specifies whether the column should allow multiple selection. The default value is false.
.EXAMPLE
    PS C:\> Add-SPEContainerPeopleColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -EnforceUniqueValues
    Adds a people column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column enforces unique values.
.EXAMPLE
    PS C:\> Add-SPEContainerPeopleColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column"
    Adds a people column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column does not enforce unique values.
.EXAMPLE
    PS C:\> Add-SPEContainerPeopleColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -MultipleSelection
    Adds a people column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column allows multiple selection.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $Name,
    [string] $Description,
    [switch] $EnforceUniqueValues,
    [switch] $MultipleSelection
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        displayName = $Name
        description = $Description
        personOrGroup = @{
            allowMultipleSelection = $MultipleSelection.ToBool()
            chooseFromType = "peopleOnly"
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
    Write-Error -Message $_ -ErrorAction Stop
}