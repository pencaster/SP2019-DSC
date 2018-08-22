#***************************************************************************************
#
# This script creates config and runs Set-DscLocalConfigurationManager on all nodes from $ConfigDataFile, as well if using Self signed cert it will deploy Root Chain to all nodes as well
#
# -Run this script as a local server Administrator
# -Run this script from elevated prompt
#
# Don't forget to: Set-ExecutionPolicy RemoteSigned
#
# Author: Krum Haesli
# Created: 21.08.2016
# Modified:
# Comment:
#
#****************************************************************************************

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName        = "SPWFE.contoso.com"
            RunCentralAdmin = $false
            ServerRole      = "WebFrontEnd"
        },
        @{
            NodeName        = "SPApp.contoso.com"
            RunCentralAdmin = $true
            ServerRole      = "Application"
        },
        @{
            NodeName        = "SPSearch.contoso.com"
            RunCentralAdmin = $false
            ServerRole      = "Search"
        },
        @{
            NodeName                    = "*"
            PSDSCAllowPlainTextPassword = $true
            PSDSCAllowDomainUser        = $true
        }
    )
    SharePoint = @{
        Settings = @{
            DatabaseServer = "SPSQL"
            BinaryPath     = "C:\SP2019\"
            ProductKey     = "M692G-8N2JP-GG8B2-2W2P7-YY7J6"
        }
    }
}
