param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $PropertyName,
    [Parameter(Mandatory=$true)]
    [string] $PropertyValue,
    [switch] $Searchable
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        $PropertyName = @{
            value = $PropertyValue
        }
    }

    If($PSBoundParameters.ContainsKey('Searchable')) {
        $Body[$PropertyName].Add("isSearchable", $Searchable.ToBool())
    }

    $Request = Invoke-MgGraphRequest -Method PATCH -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/customProperties" -Body $Body -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}