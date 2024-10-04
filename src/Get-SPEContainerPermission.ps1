param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Request = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/permissions" -ErrorAction Stop

    ConvertTo-Json -InputObject $Request -Depth 10
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}