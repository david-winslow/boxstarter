. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex
get-boxstarter -Force

$secpasswd = ConvertTo-SecureString "q" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("admin", $secpasswd)
Install-BoxstarterPackage -PackageName "https://raw.githubusercontent.com/davidfromdenmark/boxstarter/master/base-box.ps1" -Credential $cred 