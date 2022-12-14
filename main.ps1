#Adding variables
. .\param.ps1

#Creating directories and files
$check = Test-Path -Path $tempPath
if ( "$check" -eq "False" ) {
	new-item "$tempPath" -itemtype directory
	cp .\* $tempPath -r

	$scriptPath = "$tempPath" + "\main.ps1"
	$tempPathMod = "$tempPath" + "\"
	$restartBatPath = "$tempPath" + "\restart.bat"
	New-Item "$tempPathMod" -Name "restart.bat"
	$command = Get-Content ./param.ps1
	$command += "cd $tempPath"
	$command += "Powershell -Command  $tempPath\main.ps1 2> log.txt"
	echo $command | out-file -encoding ASCII $restartBatPath
	Copy-Item -Path "$restartBatPath" -Destination "$userAutorun"	

	Set-Location "$tempPath"
	Powershell -Command "$tempPath\preparation.ps1"
}

Set-Location "$tempPath"

$check = Test-Path -Path "$tempPath\installExtra"
if ( "$check" -eq "False" ) {
	Powershell -Command "$tempPath\installExtra.ps1"
}

$check = Test-Path -Path "$tempPath\sqlInstall"
if ( "$check" -eq "False" ) {
	Powershell -Command "$tempPath\sqlInstall.ps1"
	break
}

$check = Test-Path -Path "$tempPath\1cInstall"
if ( "$check" -eq "False" ) {
	Powershell -Command "$tempPath\1cInstall.ps1"
	break
}

$check = Test-Path -Path "$tempPath\done"
if ( "$check" -eq "True" ) {
	Powershell -Command "$tempPath\conclusion"
}
