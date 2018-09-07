#--- Rename the Computer ---
$computername = "david-dev"
if ($env:computername -ne $computername) {
	Rename-Computer -NewName $computername
}

#--- Enable developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1
