#***************************************************************************************
#
# Using other scripts, this script will initiaite the starting of DSC and build out of SharePoint farm with
# following configuration:
#
#      - 3-servers environment: 1 Web Front-End, 1 Application server and 1 Search server
#
# for deployment of this environment in Azure subscription, please use the following ARM templates: SharePoint Blank Templates.
#
# https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FNikCharlebois%2FSharePointFarms%2FBlankSPVMs%2Fsharepoint-2016-non-ha%2Fazuredeploy.json
#
#
# -Run this script as a local server Administrator
# -Run this script from elevated prompt
#
# Don't forget to: Set-ExecutionPolicy RemoteSigned
#
# .\Build_SP2019_Farm.ps1 -ConfigDataFile DSCConfigData_SP2019.psd1 -ConfigFile DSCConfig_SP2019Farm.ps1
#
# Author: Krum Haesli
# Created: 22.08.2016
# Modified:
# Comment:
#
#
#****************************************************************************************

param(
        [string][Parameter(Mandatory=$true)] $ConfigDataFile,
        [string][Parameter(Mandatory=$true)] $ConfigFile
)

New-Item "..\Logs" -ItemType directory -ErrorAction SilentlyContinue

Start-Transcript -Path "..\logs\DSC_SharePoint2019_Transaction.log" -Append -IncludeInvocationHeader

Get-Date

$ConfigData = "$PSScriptRoot\$ConfigDataFile"
. "$PSScriptRoot\$ConfigFile"
Starter3Servers -ConfigurationData $ConfigData

$MOFFolder ="$PSScriptRoot\$Starter3Servers"
Start-DscConfiguration $MOFFolder


Write-Host "Sit back, drink your coffee and watch the SharePoint farm get built." -ForegroundColor Green

Get-Date

Stop-Transcript
