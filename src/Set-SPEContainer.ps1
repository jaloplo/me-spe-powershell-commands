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
    Write-Host $_
}