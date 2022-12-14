#Adding variables
. .\param.ps1

function Auth {
	new-item "$tempPath\sqlInstall" -itemtype directory
	$disk = ""
	while ( "$isAuth" -eq "False" ) {
		$login = Read-Host "Enter your login"
		$password = Read-Host "Enter your password" -AsSecureString
	
		$password = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
		$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($password)
	
		$disk = Read-Host "Enter free name for mounting disk (letter from A to Z)"
		$disk = $disk + ':'
	    
		net use "$disk" $sqlNetDir /user:"$login" $password

		$check = Test-Path -Path "$disk"
		if ( "$check" -eq "True" ) {
			$isAuth = "True"
			1cInstall
		}
		else {
			$retry = Read-Host 'Please try again or enter "quit" for exit'
			if ( "$retry" -eq "quit" ) {
				$isAuth = "Quit"
			}
		}
	}
	$loopParam = "True"
	while ( "$loopParam" -eq "True" ) {
		$rebootParam = Read-Host 'When the installation is done, enter "reboot" to restart your computer'
		if ( "$rebootParam" -eq "reboot" ) {
			$loopParam = ""
		}
	}
	shutdown /r /t 0
}


#Installing 1c
function 1cInstall {
	new-item "$tempPath\1cInstall" -itemtype directory
	Set-Location $1cDir
	Start-Process -FilePath "setup.exe"
	$loopParam = "True"
	while ( "$loopParam" -eq "True" ) {
		$nextParam = Read-Host 'When the installation is done, enter "next" to complete the activation'
		if ( "$nextParam" -eq "next" ) {
			$loopParam = ""
		}
	}

	cp $1cActiv\* $tempPath\1cInstall -r
	netsh interface set interface "Ethernet0" disable
	Set-Location "$tempPath\1cInstall\1. Dumps"
	Start-Process -FilePath "1C_v8_MultiKey_Server_x64.reg"
	Start-Process -FilePath "1C_v8_MultiKey_500_user.reg"
	
	Set-Location "$tempPath\1cInstall\0. Installers"
	Start-Process -FilePath "mkinstall_x64.exe"
	netsh interface set interface "Ethernet0" enable

	$loopParam = "True"
	while ( "$loopParam" -eq "True" ) {
		$rebootParam = Read-Host 'When the installation is done, enter "reboot" to restart your computer'
		if ( "$rebootParam" -eq "reboot" ) {
			$loopParam = ""
		}
	}
	new-item "$tempPath\done" -itemtype directory
	net use * /del /y
	shutdown /r /t 0
}

Auth