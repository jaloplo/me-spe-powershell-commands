<#
.SYNOPSIS
    Adds a choice column to a container.
.DESCRIPTION
    Adds a choice column to a container. The column is added to the container only if the column does not already exist.
.PARAMETER ContainerId
    The ContainerId of the container to add the column to.
.PARAMETER Name
    The name of the column to add.
.PARAMETER Description
    The description of the column.
.PARAMETER EnforceUniqueValues
    Specifies whether the column should enforce unique values. The default value is false.
.PARAMETER Choices
    The choices of the column. The choices are the values that can be selected from the column. The choices must be unique. The choices must be strings.
    The choices can be any combination of letters, numbers, and symbols. The choices cannot be empty.
.EXAMPLE
    PS C:\> Add-SPEContainerChoiceColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -EnforceUniqueValues -Choices @("Choice1", "Choice2", "Choice3")
    Adds a choice column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column enforces unique values and has the choices "Choice1", "Choice2" and "Choice3".
.EXAMPLE
    PS C:\> Add-SPEContainerChoiceColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -Choices @("Choice1", "Choice2", "Choice3")
    Adds a choice column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column does not enforce unique values and has the choices "Choice1", "Choice2" and "Choice3".
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $Name,
    [string] $Description,
    [switch] $EnforceUniqueValues,
    [Parameter(Mandatory=$true)]
    [array] $Choices
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        displayName = $Name
        description = $Description
        choice = @{
            allowTextEntry = $false
            choices = $Choices
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