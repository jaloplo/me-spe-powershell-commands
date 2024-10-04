<#
.SYNOPSIS
    Deletes a column of a container.
.DESCRIPTION
    Deletes a column of a container.
.PARAMETER ContainerId
    The ContainerId of the container to delete the column from.
.PARAMETER ColumnId
    The Id of the column to delete.
.EXAMPLE
    PS C:\> Remove-SPEContainerColumn -ContainerId <Your Container Id> -ColumnId <Your Column Id>
    Deletes the column with the specified ColumnId from the container with the specified ContainerId.
#>

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