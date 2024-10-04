param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $ColumnId
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Request = Invoke-MgGraphRequest -Method DELETE -Uri "https://graph.microsoft.com/beta/storage/fileStorage/containers/$ContainerId/columns/$ColumnId" -ErrorAction Stop

    $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}