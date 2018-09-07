#$WinlogonPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
#Remove-ItemProperty -Path $WinlogonPath -Name AutoAdminLogon
#Remove-ItemProperty -Path $WinlogonPath -Name DefaultUserName

iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/mwrock/boxstarter/master/BuildScripts/bootstrapper.ps1'))
Get-Boxstarter -Force

$secpasswd = ConvertTo-SecureString "q" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("admin", $secpasswd)


.\base-box.ps1
Install-BoxstarterPackage -PackageName $PSScriptRoot\base-box.ps1