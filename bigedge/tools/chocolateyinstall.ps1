$ErrorActionPreference = 'Stop'; # stop on all errors
 
 
$packageName= 'BigEdgeClient'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = ''
$url64      = ''
$fileLocation = Join-Path $toolsDir 'f5fpclients.msi'
 
 
$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'msi' #only one of these: exe, msi, msu
  url           = $url
  url64bit      = $url64
  file         = $fileLocation
 
  softwareName  = 'BigEdgeClient*'
 
  checksum      = ''
  checksumType  = 'md5'
  checksum64    = ''
  checksumType64= 'md5'
 
  #MSI
  silentArgs    = "/qn"
  validExitCodes= @(0, 3010, 1641)
}
 
Install-ChocolateyInstallPackage @packageArgs