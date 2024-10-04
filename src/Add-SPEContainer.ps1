<#
.SYNOPSIS
    Creates a new container.
.DESCRIPTION
    Creates a new container for the specified ContainerTypeId.
.PARAMETER ContainerTypeId
    The ContainerTypeId of the container to create.
.PARAMETER DisplayName
    The display name of the container.
.PARAMETER Description
    The description of the container.
.PARAMETER OCR
    Enables OCR on the container.
.EXAMPLE
    PS C:\> Add-SPEContainer -ContainerTypeId <Your ContainerType Id> -DisplayName "My container" -Description "This is my container" -OCR
    Creates a new container with the specified ContainerTypeId, display name, description and OCR enabled.
.EXAMPLE
    PS C:\> Add-SPEContainer -ContainerTypeId <Your ContainerType Id> -DisplayName "My container" -Description "This is my container"
    Creates a new container with the specified ContainerTypeId, display name and description.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerTypeId,
    [Parameter(Mandatory=$true)]
    [string] $DisplayName,
    [Parameter(Mandatory=$true)]
    [string] $Description,
    [switch] $OCR
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        displayName = $DisplayName
        description = $Description
        containerTypeId = $ContainerTypeId
    }
    
    If($PSBoundParameters.ContainsKey('OCR')) {
        $Body.Add('settings', @{
            isOcrEnabled = $OCR
        })
    }

    $Request = Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers" -Body $Body -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}