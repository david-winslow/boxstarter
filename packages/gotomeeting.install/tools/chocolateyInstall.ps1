$packageName = 'gotomeeting'
$installerType = 'MSI'
$url = 'https://github.com/davidfromdenmark/boxstarter/blob/master/packages/gotomeeting.install/gotomeeting.msi'
$silentArgs = '/q ALLUSERS=1'
$validExitCodes = @(0)

try
{
  $tempDir = Join-Path $(Join-Path $env:TEMP "chocolatey") "$packageName"
  $msiFile = "gotomeeting.msi"
  $zipFile = "G2MSetup7.17.4911_IT.zip"
  if (! [System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) }
  Get-ChocolateyWebFile "$packageName" "$(Join-Path $tempDir msiFile)" $url
  Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$(Join-Path $tempDir $msiFile)" -validExitCodes $validExitCodes
}
catch
{
  throw $_
}
