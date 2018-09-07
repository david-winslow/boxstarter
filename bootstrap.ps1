Invoke-Expression ((new-object net.webclient).DownloadString('https://github.com/davidfromdenmark/boxstarter/blob/master/bootstrap.ps1'))
Get-Boxstarter -Force

$secpasswd = ConvertTo-SecureString "q" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("admin", $secpasswd)


.\base-box.ps1
Install-BoxstarterPackage -PackageName $PSScriptRoot\base-box.ps1` -Credential $cred 