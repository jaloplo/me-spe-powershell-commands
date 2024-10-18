<#
.SYNOPSIS
    Updates or activate a container.
.DESCRIPTION
    Updates a container for the specified ContainerId.
    You can update the display name, description and OCR settings.
    Activate a container to make it available for use.
.PARAMETER ContainerId
    The ContainerId of the container to update.
.PARAMETER DisplayName
    The display name of the container.
.PARAMETER Description
    The description of the container.
.PARAMETER OCR
    Enables OCR on the container.
.PARAMETER Activate
    Activates the container.
.EXAMPLE
    PS C:\> Set-SPEContainer -ContainerId <Your Container Id> -DisplayName "My container" -Description "This is my container" -OCR
    Updates the container with the specified ContainerId, display name, description and OCR enabled.
.EXAMPLE
    PS C:\> Set-SPEContainer -ContainerId <Your Container Id> -DisplayName "My container" -Description "This is my container"
    Updates the container with the specified ContainerId, display name and description.
.EXAMPLE
    PS C:\> Set-SPEContainer -ContainerId <Your Container Id> -Activate
    Activates the container with the specified ContainerId.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(ParameterSetName='Settings')]
    [string] $DisplayName,
    [Parameter(ParameterSetName='Settings')]
    [string] $Description,
    [Parameter(ParameterSetName='Settings')]
    [switch] $OCR,
    [Parameter(ParameterSetName='Activation', Mandatory=$true)]
    [switch] $Activate
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    Switch($PSCmdlet.ParameterSetName) {
        'Settings' {
            $Body = @{}

            If(-not [String]::IsNullOrEmpty($DisplayName)) {
                $Body.Add('displayName', $DisplayName)
            }

            If(-not [String]::IsNullOrEmpty($Description)) {
                $Body.Add('description', $Description)
            }
            
            If($PSBoundParameters.ContainsKey('OCR')) {
                $Body.Add('settings', @{
                    isOcrEnabled = $OCR
                })
            }

            $Request = Invoke-MgGraphRequest -Method PATCH -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId" -Body $Body -ErrorAction Stop

            ConvertTo-Json -InputObject $Request
        }
        'Activation' {
            $Request = Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/activate" -ErrorAction Stop

            $Request
        }
    }
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Error -Message $_ -ErrorAction Stop
}