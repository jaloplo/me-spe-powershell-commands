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