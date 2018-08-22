$ConfigFile = "DSCConfig_SP2019PreRequisites.ps1"
. "$PSScriptRoot\$ConfigFile"
SharePoint2019Prereqs
Start-DscConfiguration .\SharePoint2019Prereqs
