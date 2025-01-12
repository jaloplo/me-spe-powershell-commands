<#
.SYNOPSIS
    Uploads a file to a container.
.DESCRIPTION
    Uploads a file to a container. The file is uploaded to the root folder of the container.
.PARAMETER ContainerId
    The ContainerId of the container to upload the file.
.PARAMETER FileName
    The name of the file to upload.
.PARAMETER FilePath
    The path of the file to upload.
.EXAMPLE
    PS C:\> Add-SPEFile -ContainerId <Your Container Id> -FileName "MyFile.txt" -FilePath "C:\MyFile.txt"
    Uploads the file "MyFile.txt" to the container with the specified ContainerId.
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $ContainerId,
    [Parameter(Mandatory=$true)]
    [string] $FileName,
    [Parameter(Mandatory=$true)]
    [string] $FilePath
)

$isConnected = $null -ne $(Get-MgContext)

If(-not $isConnected) {
    Throw "Please connect to Microsoft Graph API using Connect-MgGraph first."
}

Try {
    $FileContent = Get-Content -Path $FilePath -Raw

    $Request = Invoke-MgGraphRequest -Method PUT -Uri $("https://graph.microsoft.com/v1.0/drives/$ContainerId/root:/" + $FileName + ":/content") -Body $FileContent -ErrorAction Stop

    ConvertTo-Json -InputObject $Request
}
Catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}