# ME-SPE-POWERHELL-COMMANDS

This is a *PowerShell* script set of commands to manage *SharePoint Embedded* containers. It uses the *Microsoft Graph API* to interact with the *SharePoint Embedded* service. It extends the official *SharePoint Embedded PowerShell* commands by adding new commands. The new commands are designed to be more intuitive and easier to use. They also provide additional functionality and options.

## Prerequisites

Before using this module, you need to have the following:

- PowerShell 5.1 or later
- Microsoft Graph PowerShell Module

## Features

The module provides the following commands (Commands using the beta version of the Graph API are marked with (beta)):

- SharePoint Embedded containers management:
  - **Add-SPEContainer**: Create a new container. You can specify the ContainerTypeId, display name, description and OCR settings.
  - **Enable-SPEContainer**: Activate a container to make it available to use.
  - **Get-SPEContainer**: Retrieve a list of containers for the specified ContainerTypeId or retrieve a specific container for the specified ContainerId.
  - ***Lock-SPEContainer (beta)***: Lock a container for modifications.
  - **Remove-SPEContainer**: Delete a container.
  - **Set-SPEContainer**: Update the display name, description and OCR settings of a container. Or activate a container to make it available for use.
  - ***Unlock-SPEContainer (beta)***: Unlock a container for modifications.

- SharePoint Embedded container custom properties management:
  - **Get-SPEContainerCustomProperty**: Retrieve all custom properties of a container or a specific custom property of a container.
  - **Remove-SPEContainerCustomProperty**: Delete a custom property of a container.
  - **Set-SPEContainerCustomProperty**: Create or update a custom property of a container. You can make the property searchable.

- SharePoint Embedded container columns management:
  - ***Add-SPEContainerBooleanColumn (beta)***: Add a boolean column to a container. You can specify the name, description, and enforce unique values.
  - ***Add-SPEContainerChoiceColumn (beta)***: Add a choice column to a container. You can specify the name, description, enforce unique values, and the choices.
  - ***Add-SPEContainerNumberColumn (beta)***: Add a number column to a container. You can specify the name, description, enforce unique values, minimum and maximum values.
  - ***Add-SPEContainerPeopleAndGroupsColumn (beta)***: Add a people and groups column to a container. You can specify the name, description, enforce unique values, and multiple selection.
  - ***Add-SPEContainerPeopleColumn (beta)***: Add a people column to a container. You can specify the name, description, enforce unique values, and multiple selection.
  - ***Add-SPEContainerPictureColumn (beta)***: Add a picture column to a container. You can specify the name, description, enforce unique values.
  - ***Add-SPEContainerPlainTextColumn (beta)***: Add a plain text column to a container. You can specify the name, description, enforce unique values, maximum length and append changes.
  - ***Add-SPEContainerRichTextColumn (beta)***: Add a rich text column to a container. You can specify the name, description, enforce unique values, maximum length and append changes.
  - **Get-SPEContainerColumn**: Retrieve all columns of a container or a specific column of a container.
  - **Remove-SPEContainerColumn**: Delete a column of a container.

- SharePoint Embedded container permissions management:
  - **Add-SPEContainerPermission**: Add a permission to a container. You can specify the role and login.
  - **Add-SPEContainerManagerPermissions**: Add a manager permission to a container. You can specify the login.
  - **Add-SPEContainerOwnerPermissions**: Add an owner permission to a container. You can specify the login.
  - **Get-SPEContainerPermission**: Retrieve the permissions of a container.
  - **Add-SPEContainerReaderPermissions**: Add a reader permission to a container. You can specify the login.
  - **Add-SPEContainerWriterPermissions**: Add a writer permission to a container. You can specify the login.
  - **Remove-SPEContainerPermission**: Delete a permission from a container.
  - **Set-SPEContainerManagerPermission**: Set manager role for a permission of a container.
  - **Set-SPEContainerOwnerPermission**: Set owner role for a permission of a container.
  - **Set-SPEContainerPermission**: Update the role of a permission of a container. You can update the role of a permission for the specified role and login.
  - **Set-SPEContainerReaderPermission**: Set reader role for a permission of a container.
  - **Set-SPEContainerWriterPermission**: Set writer role for a permission of a container.

## Usage

To use the module, you need to connect to the *Microsoft Graph API* using the `Connect-MgGraph` command. You can find more information about the `Connect-MgGraph` command in the *Microsoft Graph PowerShell* module documentation.

Once you are connected, you can use the commands provided by the module to manage *SharePoint Embedded* containers.

Here is an example of how to use the module:

```powershell
# Create a credential object for the client id and the client secret of the application with permissions to manage SharePoint Embedded containers
$ClientId = "<Your Client Id>"
$SecretValue = "<Your Client Secret>"

$Password = ConvertTo-SecureString -String $SecretValue -AsPlainText -Force

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ClientId, $Password

# Connect to the Microsoft Graph API using the credential
Connect-MgGraph -TenantId <Your Tenant Id> -ClientSecretCredential $Credential

# Add a container with the specified ContainerTypeId, display name, description and OCR enabled
$ContainerJson = Add-SPEContainer -ContainerTypeId <Your ContainerTypeId> -DisplayName "MyContainer" -Description "This is my container" -OCR

# Get the container id from the response
$ContainerId = $(ConvertFrom-Json $ContainerJson).id

# Add a column to the container with the specified name, description and enforce unique values
Add-SPEContainerColumn -ContainerId $ContainerId -Name "MyColumn" -Description "This is my column" -EnforceUniqueValues

# Add a reader permission to the container with the specified login
Add-SPEContainerPermission -ContainerId $ContainerId -Role "reader" -Login <Email Account>
```

In this example, we connect to the *Microsoft Graph API* using the `Connect-MgGraph` command. We then add a container with the specified ContainerTypeId, display name, description and OCR enabled. We also add a column to the container with the specified name, description and enforce unique values. Finally, we add a reader permission to the container with the specified login.

## Contact

If you have any questions or feedback, please contact me at [jaime.lopez.lopez@live.com](mailto:jaime.lopez.lopez@live.com) or [LinkedIn](https://www.linkedin.com/in/jaimelopezlopez/). If you find this project useful, please consider giving it a star on GitHub. Thank you for your support!
