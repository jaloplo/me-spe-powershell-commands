<#
.SYNOPSIS
    Adds a currency column to a container.
.DESCRIPTION
    Adds a currency column to a container. The column is added to the container only if the column does not already exist.
.PARAMETER ContainerId
    The ContainerId of the container to add the column to.
.PARAMETER Name
    The name of the column to add.
.PARAMETER Description
    The description of the column.
.PARAMETER EnforceUniqueValues
    Specifies whether the column should enforce unique values. The default value is false.
.PARAMETER Locale
    The locale of the column. Specifies the locale from which to infer the currency symbol. More information about the supported locales can be found in https://learn.microsoft.com/en-us/globalization/locale/locale.
.EXAMPLE
    PS C:\> Add-SPEContainerCurrencyColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -EnforceUniqueValues -Locale "en-US"
    Adds a currency column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column enforces unique values and has the locale "en-US".
.EXAMPLE
    PS C:\> Add-SPEContainerCurrencyColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -Locale "en-US"
    Adds a currency column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column does not enforce unique values and has the locale "en-US".
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $Name,
    [string] $Description,
    [switch] $EnforceUniqueValues,
    [Parameter(Mandatory=$true)]
    [string] $Locale
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        displayName = $Name
        description = $Description
        currency = @{
            local = $Locale
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