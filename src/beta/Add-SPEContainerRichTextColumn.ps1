<#
.SYNOPSIS
    Adds a rich text column to a container.
.DESCRIPTION
    Adds a rich text column to a container. The column is added to the container only if the column does not already exist.
.PARAMETER ContainerId
    The ContainerId of the container to add the column to.
.PARAMETER Name
    The name of the column to add.
.PARAMETER Description
    The description of the column.
.PARAMETER EnforceUniqueValues
    Specifies whether the column should enforce unique values. The default value is false.
.PARAMETER MaximumLength
    The maximum length of the column values.
.PARAMETER AppendChanges
    Specifies whether the column should append changes to existing values. The default value is false.
.EXAMPLE
    PS C:\> Add-SPEContainerRichTextColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -EnforceUniqueValues -MaximumLength 100 -AppendChanges
    Adds a rich text column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column enforces unique values, has a maximum length of 100 and appends changes to existing values.
.EXAMPLE
    PS C:\> Add-SPEContainerRichTextColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -MaximumLength 100 -AppendChanges
    Adds a rich text column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column does not enforce unique values, has a maximum length of 100 and appends changes to existing values.
.EXAMPLE
    PS C:\> Add-SPEContainerRichTextColumn -ContainerId <Your Container Id> -Name "MyColumn" -Description "This is my column" -MaximumLength 100
    Adds a rich text column named "MyColumn" with the specified description to the container with the specified ContainerId. The column is added to the container only if the column does not already exist. The column does not enforce unique values, has a maximum length of 100 and does not append changes to existing values.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $Name,
    [string] $Description,
    [switch] $EnforceUniqueValues,
    [string] $MaximumLength,
    [switch] $AppendChanges
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        name = $Name
        description = $Description
        text = @{
            appendChangesToExistingText = $AppendChanges.ToBool()
            maxLength = $MaximumLength
            textType = "richText"
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