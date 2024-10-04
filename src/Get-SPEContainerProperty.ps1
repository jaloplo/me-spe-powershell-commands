param(
    [Parameter(ParameterSetName='One', Mandatory=$true)]
    [Parameter(ParameterSetName='All', Mandatory=$true)]
    [string] $ContainerId,
    
    [Parameter(ParameterSetName='One', Mandatory=$true)]
    [string] $PropertyName
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    Switch($PSCmdlet.ParameterSetName) {
        'All' {
            $Request = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/customProperties" -ErrorAction Stop

            ConvertTo-Json -InputObject $Request
        }
        'One' {
            $Request = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/customProperties/$PropertyName" -ErrorAction Stop

            ConvertTo-Json -InputObject $Request
        }
    }
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}