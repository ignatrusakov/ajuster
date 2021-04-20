#Adding variables
. .\param.ps1

#Authorization func
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
			sqlInstall -disk $disk
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
	net use * /del /y
	shutdown /r /t 0
}



#Installing SQL
function sqlInstall ( $disk ) {
	$array = @()
    $counter = 0
    Set-Location "$disk"
    cmd.exe /c "dir /a /b /-p /o:gen > $tempPath\iso.txt"
	ForEach ($line in Get-Content $tempPath\iso.txt) {
        $array = ,"$line" + $array
        $counter += 1
    }
    
    For ( $i = 0; $i -lt $counter; $i++ ) {
        write-host $i")" $array["$i"]
    }
    $num = read-host "Choose the iso file (Enter the number)"
       
	$way = $disk + "\" + $array["$num"]
    Mount-DiskImage -ImagePath "$way"
	Start-Process -FilePath "E:\setup.exe"
}

Auth
