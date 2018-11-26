. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex
get-boxstarter -Force

$secpasswd = ConvertTo-SecureString "q" -AsPlainText -Force
$op = Get-LocalUser | Where-Object {$_.Name -eq "admin"}
if ( -not $op)
{
New-LocalUser "admin" -Password $secpasswd -FullName "admin" -Description "admin generated"
Add-LocalGroupMember -Group "Administrators" -Member "admin"
$cred = New-Object System.Management.Automation.PSCredential ("admin", $secpasswd)
}
Install-BoxstarterPackage -PackageName "https://raw.githubusercontent.com/davidfromdenmark/boxstarter/master/base-box.ps1" -Credential $cred
