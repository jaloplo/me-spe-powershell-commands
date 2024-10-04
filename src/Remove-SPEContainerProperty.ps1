<#
.SYNOPSIS
    Deletes a property of a container.
.DESCRIPTION
    Deletes a property of a container.
.PARAMETER ContainerId
    The ContainerId of the container to delete the property.
.PARAMETER PropertyName
    The name of the property to delete.
.EXAMPLE
    PS C:\> Remove-SPEContainerProperty -ContainerId <Your Container Id> -PropertyName "MyProperty"
    Deletes the property "MyProperty" of the container with the specified ContainerId.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $PropertyName
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $Body = @{
        $PropertyName = $null
    }

    $Request = Invoke-MgGraphRequest -Method PATCH -Uri "https://graph.microsoft.com/v1.0/storage/fileStorage/containers/$ContainerId/customProperties" -Body $Body -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host $_
}