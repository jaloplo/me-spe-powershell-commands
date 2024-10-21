<#
.SYNOPSIS
    Creates the information architecture for a Todo App based on SharePoint Embedded.
.DESCRIPTION
    Creates the information architecture for a Todo App based on SharePoint Embedded. The information architecture includes the following components:
    - Creation of the container
    - Creation of the columns
    - Creation of the custom properties
    - Granting access to users
.PARAMETER ContainerTypeId
    The ContainerTypeId of the container to create.
.PARAMETER GroupName
    The name of the group to grant access to.
.PARAMETER UsersCollection
    The collection of users to grant access to.
    Email address must be provided for each user.
.EXAMPLE
    PS C:\> Create-SPETodoAppInformationArchitecture -ContainerTypeId <Your Container Type Id> -GroupName <Your Group Name> -UsersCollection @("<User1@company.com>", "<User2@company.com>")
    Creates the information architecture for the todo app using the specified container type, group name and users collection.
#>

param (
    [Parameter(Mandatory=$true)]
    [string] $ContainerTypeId,
    [Parameter(Mandatory=$true)]
    [string] $GroupName,
    [Parameter(Mandatory=$true)]
    [Array] $UsersCollection
)

# Container creation

# Create the container for the group provided. The container name starts with the group name provide plus the suffix "Todo App Container".
# The data returned by the command is stored in the $ContainerData variable as a JSON string.
Write-Host "Creating the container..." -ForegroundColor Cyan

$ContainerName = "$GroupName Todo App Container"
$ContainerDescription = "This is the $GroupName Todo App container"
$ContainerData = .\Add-SPEContainer -ContainerTypeId $ContainerTypeId -DisplayName $containerName -Description $ContainerDescription -ErrorAction Stop

# Get the container id from the response. The container id is used in the rest of the commands.
$ContainerId = $(ConvertFrom-Json $ContainerData).id

Write-Host "Container $ContainerName has been successfully created." -ForegroundColor Green


# Columns creation

Write-Host "Creating columns for $ContainerName container..." -ForegroundColor Cyan

# Create the task id column.
# The column is configured to disallow duplicate values. 
# The maximum value is 9999 so there will be no way to have more than 9999 tasks in the container for one user.
Write-Host "Creating Id column..." -ForegroundColor Cyan
.\beta\Add-SPEContainerNumberColumn -ContainerId $ContainerId -Name "Id" -Description "Task Id" -EnforceUniqueValues -Minimum 1 -Maximum 9999 -ErrorAction Stop

# # Create the task description column.
# # The maximum number of characters allowed is 255.
Write-Host "Creating Description column..." -ForegroundColor Cyan
.\beta\Add-SPEContainerPlainTextColumn -ContainerId $ContainerId -Name "Explanation" -Description "Task Explanation" -MaximumLength 255 -ErrorAction Stop

# Create the task status column.
# The column is configured as a choice column whose values are "Not Started", "In Progress" and "Completed".
Write-Host "Creating Status column..." -ForegroundColor Cyan
.\beta\Add-SPEContainerChoiceColumn -ContainerId $ContainerId -Name "Status" -Description "Task Status" -Choices @("Not Started", "In Progress", "Completed") -ErrorAction Stop

# Create the due date column.
Write-Host "Creating Due Date column..." -ForegroundColor Cyan
.\beta\Add-SPEContainerDateTimeColumn -ContainerId $ContainerId -Name "Due Date" -Description "Due Date" -ErrorAction Stop

# Create the task priority column.
# The column is configured as a choice column whose values are "High", "Medium" and "Low".
Write-Host "Creating Priority column..." -ForegroundColor Cyan
.\beta\Add-SPEContainerChoiceColumn -ContainerId $ContainerId -Name "Priority" -Description "Task Status" -Choices @("High", "Medium", "Low") -ErrorAction Stop

# Create the asignee column.
Write-Host "Creating Asignee column..." -ForegroundColor Cyan
.\beta\Add-SPEContainerPeopleAndGroupsColumn -ContainerId $ContainerId -Name "Asignee" -Description "Task Asignee" -ErrorAction Stop

Write-Host "Columns successfully created for $ContainerName container." -ForegroundColor Green


# Properties creation

Write-Host "Creating custom properties for $ContainerName container..." -ForegroundColor Gray


# Create the group name property.
# The column is configured to be searchable in the tenant.
Write-Host "Creating Group Name property..." -ForegroundColor Cyan
.\Set-SPEContainerProperty -ContainerId $ContainerId -PropertyName "Group Name" -PropertyValue $GroupName -Searchable -ErrorAction Stop

# Create the app name property to know what this container belongs to.
# The column is configured to be searchable in the tenant.
Write-Host "Creating Application Name property..." -ForegroundColor Cyan
.\Set-SPEContainerProperty -ContainerId $ContainerId -PropertyName "Application Name" -PropertyValue "Todo App" -Searchable -ErrorAction Stop


Write-Host "Custom properties successfully created for $ContainerName container." -ForegroundColor Green



# Permissions configuration

Write-Host "Granting permissions for $ContainerName container..." -ForegroundColor Gray

# Iterates each user provided to grant writer permissions
foreach($User in $UsersCollection) {
    # Add writer permission to each user provided
    Write-Host "Granting permission to $User..." -ForegroundColor Cyan
    .\Add-SPEContainerWriterPermission -ContainerId $ContainerId -Login $User
    Write-Host "Permissions successfully granted for $User to $ContainerName container." -ForegroundColor Gray -ErrorAction Stop
}

Write-Host "Permissions successfully granted to all users for $ContainerName container." -ForegroundColor Green
