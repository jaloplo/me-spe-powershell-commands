<#
.SYNOPSIS
    Retrieves all columns of a container or a specific column of a container.
.DESCRIPTION
    Retrieves all columns of a container or a specific column of a container. The columns are returned as a list of columns. 
.PARAMETER ContainerId
    The ContainerId of the container to retrieve the column from.
.PARAMETER ColumnId
    The Id of the column to retrieve. If not specified, all columns of the container are returned.
.EXAMPLE
    PS C:\> Get-SPEContainerColumn -ContainerId <Your Container Id>
    Retrieves all columns of the container with the specified ContainerId. The columns are returned as a list of columns.
.EXAMPLE
    PS C:\> Get-SPEContainerColumn -ContainerId <Your Container Id> -ColumnId <Your Column Id>
    Retrieves the column with the specified ColumnId of the container with the specified ContainerId. The column is returned as a list of columns.
#>

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
    Write-Error -Message $_ -ErrorAction Stop
}