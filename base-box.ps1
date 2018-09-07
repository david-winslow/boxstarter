$userSettingsApps = @(
    'taskbar-never-combine'
    ,'explorer-show-all-folders'
    ,'explorer-expand-to-current-folder'
)

$coreApps = @(
    'chocolatey'
    ,'vlc'
    ,'jre8'
    ,'adobereader'
    ,'googlechrome'
    ,'opera'
    ,'adblockpluschrome'
    ,'lastpass'
    ,'itunes'
    ,'dropbox'
    ,'youtube-dl'
    ,'googledrive'

)

$devApps = @(
        'fiddler'
        ,'docker'
        ,'wsl'
        ,'sysinternals'
        ,'microsoft-teams'
        ,'vim'
        ,'nmap'
        ,'nuget.commandline'
        ,'nugetpackageexplorer'
        ,'beyondcompare'
        ,'visualstudiocode'
        ,'nodejs.install'
        ,'ilspy'
        ,'7zip.install'
        ,'sql-server-management-studio'
        ,'beyondcompare'
        ,'postman'
        ,'github'
        ,'sourcetree'
        ,'sysinternals'
        
        # dotnet specific

        ,'dotnet3.5'
        ,'dotnet4.5'
        ,'dotnet4.6.2'
        ,'dotnet4.7.1'
        ,'dotnetcore-sdk'

        # visual studio
        ,'visualstudio2017professional'
        ,'visualstudio2017-workload-azure'
        ,'visualstudio2017-workload-netcoretools'
        ,'visualstudio2017-workload-webbuildtools'
        ,'visualstudio2017-workload-netweb'
        ,'visualstudio2017-workload-node'
        ,'visualstudio2017-workload-webcrossplat'
        ,'resharper'
        ,'visualstudio2017buildtools'

    )



$Boxstarter.RebootOk=$true
$Boxstarter.NoPassword=$false
$Boxstarter.AutoLogin=$true




function InstallChocoApps($packageArray){

    foreach ($package in $packageArray) {
        &choco install $package --limitoutput
    }

}

function SetRegionalSettings(){
    &"$env:windir\system32\tzutil.exe" /s "South Africa Standard Time"
    
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sShortDate     -Value dd-MMM-yy
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sCountry       -Value "South Africa"
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sShortTime     -Value HH:mm
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sTimeFormat    -Value HH:mm:ss
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sLanguage      -Value ENZA
}

function InstallWindowsUpdate()
{
    Enable-MicrosoftUpdate
    Install-WindowsUpdate -AcceptEula
    if (Test-PendingReboot) { Invoke-Reboot }
}


function InstallChocoDevApps
{
    
    
    InstallChocoApps $devApps

    choco install git -params '"/GitAndUnixToolsOnPath"'
    choco install sourcetree #do last since not silent
}

function InstallVisualStudio()
{
#    choco install visualstudio2015enterprise --source=https://www.myget.org/F/chocolatey-vs/api/v2 #kennethB is slow pushing to nuget
#    Install-ChocolateyVsixPackage 'PowerShell Tools for Visual Studio 2015' https://visualstudiogallery.msdn.microsoft.com/c9eb3ba8-0c59-4944-9a62-6eee37294597/file/199313/1/PowerShellTools.14.0.vsix
#    Install-ChocolateyVsixPackage 'Productivity Power Tools 2015' https://visualstudiogallery.msdn.microsoft.com/34ebc6a2-2777-421d-8914-e29c1dfa7f5d/file/169971/1/ProPowerTools.vsix
#    
#    Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"
#    Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe"

    choco install visualstudio2017professional --package-parameters "--allWorkloads --includeRecommended --passive --locale en-US"
}

function InstallInternetInformationServices()
{
    $windowsFeatures = @(
        'Windows-Identity-Foundation'
        ,'Microsoft-Windows-Subsystem-Linux'
        ,'IIS-WebServerRole'
        ,'IIS-WebServer'
        ,'IIS-CommonHttpFeatures'
        ,'IIS-HttpErrors'
        ,'IIS-HttpRedirect'
        ,'IIS-ApplicationDevelopment'
        ,'IIS-NetFxExtensibility45'
        ,'IIS-HealthAndDiagnostics'
        ,'IIS-HttpLogging'
        ,'IIS-LoggingLibraries'
        ,'IIS-RequestMonitor'
        ,'IIS-HttpTracing'
        ,'IIS-Security'
        ,'IIS-URLAuthorization'
        ,'IIS-RequestFiltering'
        ,'IIS-Performance'
        ,'IIS-HttpCompressionDynamic'
        ,'IIS-WebServerManagementTools'
        ,'IIS-ManagementScriptingTools'
        ,'IIS-HostableWebCore'
        ,'IIS-StaticContent'
        ,'IIS-DefaultDocument'
        ,'IIS-WebSockets'
        ,'IIS-ASPNET'
        ,'IIS-ServerSideIncludes'
        ,'IIS-CustomLogging'
        ,'IIS-BasicAuthentication'
        ,'IIS-HttpCompressionStatic'
        ,'IIS-ManagementConsole'
        ,'IIS-ManagementService'
        ,'IIS-WMICompatibility'
        ,'IIS-CertProvider'
        ,'IIS-WindowsAuthentication'
        ,'IIS-DigestAuthentication'
    )
    
    foreach ($package in $windowsFeatures) {
        &choco install $package --source windowsfeatures
    }
}



function CleanDesktopShortcuts()
{
    Write-Host "Cleaning desktop of shortcuts"
    $allUsersDesktop = "C:\Users\Public\Desktop"
    Get-ChildItem -Path $allUsersDesktop\*.lnk -Exclude *BoxStarter* | remove-item
}

function PinToTaskBar()
{
    # pin apps that update themselves
    choco pin add -n=googlechrome
    choco pin add -n=sourcetree
}


SetRegionalSettings

# SQL Server requires some KB patches before it will work, so windows update first
Write-BoxstarterMessage "Windows update..."
InstallWindowsUpdate

# disable chocolatey default confirmation behaviour (no need for --yes)
choco feature enable --name=allowGlobalConfirmation



Write-BoxstarterMessage "Starting chocolatey installs"

InstallChocoApps $userSettingsApps    

InstallChocoApps $coreApps

# Put last as the big SQL server / VS2017 tend to fail and kill Boxstarter it seems

    Write-BoxstarterMessage "Installing Dev Apps"
    InstallChocoDevApps
    InstallSqlServer
    InstallInternetInformationServices
    InstallVisualStudio

CleanDesktopShortcuts
PinToTaskBar

# Assume Windows 10
Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/neutmute/nm-boxstarter/master/win10-clean.ps1

Write-Host "Follow extra optional cleanup steps in win10-clean.ps1"
Start-Process win10-clean.ps1
