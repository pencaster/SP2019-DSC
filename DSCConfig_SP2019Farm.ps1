configuration Starter3Servers
{
    $credsLocalAdmin  = Get-AutomationPSCredential -Name "LocalAdmin"
    $credsDomainAdmin = Get-AutomationPSCredential -Name "DomainAdmin"
    $credsSPFarm      = Get-AutomationPSCredential -Name "FarmAccount"
    $credsSPSetup     = Get-AutomationPSCredential -Name "SetupAccount"
    $credsSPServices  = Get-AutomationPSCredential -Name "SPServices"
    $credsSPSearch    = Get-AutomationPSCredential -Name "SPSearch"
    $credsSPAdmin     = Get-AutomationPSCredential -Name "SharePointAdmin"

    Import-DscResource -ModuleName "SharePointDSC"  -Moduleversion "3.0.0.0"
    Import-DscResource -ModuleName "xDownloadFile"  -ModuleVersion "1.0"
    Import-DscResource -ModuleName "xDownloadISO"   -ModuleVersion "1.0"
    Import-DscResource -ModuleName "xPendingReboot" -ModuleVersion "0.4.0.0"

    Node $AllNodes.NodeName
    {
        xDownloadISO DownloadBits
        {
            SourcePath               = "https://download.microsoft.com/download/8/1/4/8144DA0D-FB9A-48B8-B56E-2C12E0C30079/en-us/16.0.10711.37301_OfficeServer_none_ship_x64_en-us_dvd/officeserver_en-us.img"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        xDownloadISO FrenchLPISO
        {
            SourcePath               = "https://spdsctap.blob.core.windows.net/spdsc/LP-French.iso"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath + "LP\French\"
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        xDownloadISO DutchLPISO
        {
            SourcePath               = "https://spdsctap.blob.core.windows.net/spdsc/LP-Deutch.iso"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath + "LP\Dutch"
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        xDownloadFile AppFabricKBDL
        {
            SourcePath               = "https://download.microsoft.com/download/F/1/0/F1093AF6-E797-4CA8-A9F6-FC50024B385C/AppFabric-KB3092423-x64-ENU.exe"
            FileName                 = "AppFabric-KB3092423-x64-ENU.exe"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles"
            PsDscRunAsCredential     = $credsLocalAdmin
            DependsOn                = "[xDownloadISO]DownloadBits"
        }

        xDownloadFile MicrosoftIdentityExtensionsDL
        {
            SourcePath               = "http://download.microsoft.com/download/0/1/D/01D06854-CA0C-46F1-ADBA-EBF86010DCC6/rtm/MicrosoftIdentityExtensions-64.msi"
            FileName                 = "MicrosoftIdentityExtensions-64.msi"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles"
            DependsOn                = "[xDownloadFile]AppFabricKBDL"
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        xDownloadFile MSIPCDL
        {
            SourcePath               = "https://download.microsoft.com/download/3/C/F/3CF781F5-7D29-4035-9265-C34FF2369FA2/setup_msipc_x64.exe"
            FileName                 = "setup_msipc_x64.msi"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles"
            DependsOn                = "[xDownloadFile]MicrosoftIdentityExtensionsDL"
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        xDownloadFile SQLNCLIDL
        {
            SourcePath               = "https://download.microsoft.com/download/B/E/D/BED73AAC-3C8A-43F5-AF4F-EB4FEA6C8F3A/ENU/x64/sqlncli.msi"
            FileName                 = "sqlncli.msi"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles"
            DependsOn                = "[xDownloadFile]MSIPCDL"
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        xDownloadFile WcfDataServices56DL
        {
            SourcePath               = "http://download.microsoft.com/download/1/C/A/1CAA41C7-88B9-42D6-9E11-3C655656DAB1/WcfDataServices.exe"
            FileName                 = "WcfDataServices56.exe"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles"
            DependsOn                = "[xDownloadFile]SQLNCLIDL"
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        xDownloadFile AppFabricDL
        {
            SourcePath               = "http://download.microsoft.com/download/A/6/7/A678AB47-496B-4907-B3D4-0A2D280A13C0/WindowsServerAppFabricSetup_x64.exe"
            FileName                 = "WindowsServerAppFabricSetup_x64.exe"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles"
            DependsOn                = "[xDownloadFile]WcfDataServices56DL"
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        xDownloadFile DotNet472
        {
            SourcePath               = "https://go.microsoft.com/fwlink/?linkid=863265"
            FileName                 = "NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles"
            DependsOn                = "[xDownloadFile]AppFabricDL"
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        xDownloadFile SynchronizationDL
        {
            SourcePath               = "http://download.microsoft.com/download/E/0/0/E0060D8F-2354-4871-9596-DC78538799CC/Synchronization.msi"
            FileName                 = "Synchronization.msi"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles"
            DependsOn                = "[xDownloadFile]DotNet472"
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        xDownloadFile MSVCRT141
        {
            SourcePath               = "https://aka.ms/vs/15/release/vc_redist.x64.exe"
            FileName                 = "vc_redist.x64.exe"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath +  "prerequisiteinstallerfiles"
            DependsOn                = "[xDownloadFile]SynchronizationDL"
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        xDownloadFile MSVCRT11
        {
            SourcePath               = "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe"
            FileName                 = "vcredist_x64.exe"
            DestinationDirectoryPath = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles"
            DependsOn                = "[xDownloadFile]MSVCRT141"
            PsDscRunAsCredential     = $credsLocalAdmin
        }

        Group GrantSetupAccountLocalAdmin
        {
            GroupName            = "Administrators"
            Ensure               = "Present"
            MembersToInclude     = $credsSPSetup.UserName
            PsDscRunAsCredential = $credsLocalAdmin
            DependsOn            = "[xDownloadFile]MSVCRT11"
        }

        SPInstallPrereqs SharePointPrereqInstall
        {
            IsSingleInstance     = "Yes"
            InstallerPath        = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstaller.exe"
            OnlineMode           = $false
            SQLNCli              = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles\sqlncli.msi"
            Sync                 = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles\Synchronization.msi"
            AppFabric            = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles\WindowsServerAppFabricSetup_x64.exe"
            IDFX11               = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles\MicrosoftIdentityExtensions-64.msi"
            MSIPCClient          = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles\setup_msipc_x64.msi"
            WCFDataServices56    = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles\WcfDataServices56.exe"
            MSVCRT11             = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles\vcredist_x64.exe"
            MSVCRT141            = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles\vc_redist.x64.exe"
            KB3092423            = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles\AppFabric-KB3092423-x64-ENU.exe"
            DotNet472            = $ConfigurationData.SharePoint.Settings.BinaryPath + "prerequisiteinstallerfiles\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
            Ensure               = "Present"
            DependsOn            = "[Group]GrantSetupAccountLocalAdmin"
            # For On-prem - SXSPath = "D:\sources\sxs"
            PsDscRunAsCredential = $credsSPSetup
        }

        xPendingReboot AfterPrereqInstall
        {
            Name                 = "AfterPrereqInstall"
            DependsOn            = "[SPInstallPrereqs]SharePointPrereqInstall"
            PsDscRunAsCredential = $credsDomainAdmin
        }

        SPInstall SharePointInstall
        {
            IsSingleInstance     = "Yes"
            BinaryDir            = $ConfigurationData.SharePoint.Settings.BinaryPath
            ProductKey           = $ConfigurationData.SharePoint.Settings.ProductKey
            Ensure               = "Present"
            DependsOn            = "[xPendingReboot]AfterPrereqInstall"
            PsDscRunAsCredential = $credsSPSetup
        }

        SPInstallLanguagePack DutchLanguagePack
        {
            BinaryDir            = $ConfigurationData.SharePoint.Settings.BinaryPath + "LP\Dutch"
            DependsOn            = "[SPInstall]SharePointInstall"
            PsDscRunAsCredential = $credsSPSetup
        }

        SPInstallLanguagePack FrenchLanguagePack
        {
            BinaryDir            = $ConfigurationData.SharePoint.Settings.BinaryPath + "LP\French"
            DependsOn            = "[SPInstall]SharePointInstall"
            PsDscRunAsCredential = $credsSPSetup
        }

        xPendingReboot AfterSPInstall
        {
            Name                 = "AfterSPInstall"
            DependsOn            = "[SPInstall]SharePointInstall"
            PsDscRunAsCredential = $credsDomainAdmin
        }

        SPFarm SharePointFarm
        {
            IsSingleInstance          = "Yes"
            Ensure                    = "Present"
            FarmConfigDatabaseName    = "SP_Config"
            DatabaseServer            = $ConfigurationData.SharePoint.Settings.DatabaseServer
            FarmAccount               = $credsSPFarm
            Passphrase                = $credsSPFarm
            AdminContentDatabaseName  = "SP_Admin"
            RunCentralAdmin           = $Node.RunCentralAdmin
            CentralAdministrationPort = "7777"
            ServerRole                = "Application"
            PSDSCRunAsCredential      = $credsSPSetup
        }

        if ($node.RunCentralAdmin -eq $true)
        {
            SPManagedAccount SPFarmAccount
            {
                AccountName            = $credsSPFarm.UserName
                Account                = $credsSPFarm
                PSDSCRunAsCredential   = $credsSPSetup
                DependsOn              = "[SPFarm]SharePointFarm"
            }

            SPManagedAccount SPServices
            {
                AccountName            = $credsSPServices.UserName
                Account                = $credsSPServices
                PSDSCRunAsCredential   = $credsSPSetup
                DependsOn              = "[SPFarm]SharePointFarm"
            }

            SPManagedAccount SPSearch
            {
                AccountName            = $credsSPSearch.UserName
                Account                = $credsSPSearch
                PSDSCRunAsCredential   = $credsSPSetup
                DependsOn              = "[SPFarm]SharePointFarm"
            }

            SPManagedAccount SPAdmin
            {
                AccountName            = $credsSPAdmin.UserName
                Account                = $credsSPAdmin
                PSDSCRunAsCredential   = $credsSPSetup
                DependsOn              = "[SPFarm]SharePointFarm"
            }

            SPWebApplication Root
            {
                Ensure                 = "Present"
                Name                   = "Root"
                ApplicationPool        = "SharePoint - 80"
                ApplicationPoolAccount = $credsSPFarm.UserName
                WebAppUrl              = "http://root.contoso.com"
                DatabaseServer         = $ConfigurationData.SharePoint.Settings.DatabaseServer
                DatabaseName           = "Root_Content_DB"
                HostHeader             = "root.contoso.com"
                AllowAnonymous         = $false
                PSDSCRunAsCredential   = $credsSPSetup
                DependsOn              = "[SPManagedAccount]SPFarmAccount"
            }

            SPSite RootSite
            {
                Name                     = "Root Site Collection"
                Url                      = "http://root.contoso.com"
                OwnerAlias               = "contoso\lcladmin"
                ContentDatabase          = "Root_Content_DB"
                Description              = "Root Site Collection"
                Template                 = "STS#0"
                PSDSCRunAsCredential     = $credsSPSetup
                DependsOn                = "[SPWebApplication]Root"
            }

            SPWeb SubWeb1
            {
                Name                  = "Subweb1"
                Url                   = "http://root.contoso.com/subweb1"
                AddToQuickLaunch      = $true
                AddToTopNav           = $true
                Description           = "This is a subsite"
                UseParentTopNav       = $true
                UniquePermissions     = $true
                Template              = "STS#0"
                PSDSCRunAsCredential  = $credsSPSetup
                DependsOn             = "[SPSite]RootSite"
            }
        }
    }
}
