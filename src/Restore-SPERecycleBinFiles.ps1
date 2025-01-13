<#
.SYNOPSIS
    Restores a file or multiple files from the recycle bin for a container specified.
.DESCRIPTION
    Restores a file or multiple files from the recycle bin for a container specified. The recycle bin is a special container that contains all deleted files in the specified container.
.PARAMETER ContainerId
    The ContainerId of the container to restore the recycle bin files.
.PARAMETER FileIds
    The array of file ids to restore.
.EXAMPLE
    PS C:\> Restore-SPERecycleBinFiles -ContainerId <Your Container Id> -FileIds @("<File Id 1>", "<File Id 2>")
    Restores the files with the specified FileIds from the recycle bin for the specified ContainerId.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [Array] $FileIds
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        ids = $FileIds
    }

    $Request = Invoke-MgGraphRequest -Method POST -Uri $("https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/recycleBin/items/restore") -Body $Body -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    $_
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}