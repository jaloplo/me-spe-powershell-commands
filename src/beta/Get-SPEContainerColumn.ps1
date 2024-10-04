param(
    [Parameter(ParameterSetName='One', Mandatory=$true)]
    [Parameter(ParameterSetName='All', Mandatory=$true)]
    [string] $ContainerId,
    
    [Parameter(ParameterSetName='One', Mandatory=$true)]
    [string] $ColumnId
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    Switch($PSCmdlet.ParameterSetName) {
        'All' {
            $Request = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/storage/fileStorage/containers/$ContainerId/columns" -ErrorAction Stop

            ConvertTo-Json -InputObject $Request -Depth 10
        }
        'One' {
            $Request = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/storage/fileStorage/containers/$ContainerId/columns/$ColumnId" -ErrorAction Stop

            ConvertTo-Json -InputObject $Request
        }
    }
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}