param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [ValidateSet("reader", "writer", "manager", "owner")]
    [string] $Role,
    [Parameter(Mandatory=$true)]
    [string] $Login
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        roles = @($Role)
        grantedToV2 = @{
            user = @{
                userPrincipalName = $Login
            }
        }
    }

    $Request = Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/permissions" -Body $Body -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}