#Adding variables
. .\param.ps1

#Installing important components
function Preparation {
	#Creating directories and files
	Set-Location -Path "$tempPath"
	new-item "preparation" -itemtype directory
	Set-Location -Path "$tempPath\preparation"

	# NET Frameork 4.8
	$client = new-object System.Net.WebClient    
	$client.DownloadFile("https://go.microsoft.com/fwlink/?linkid=2088631", "$tempPath\preparation" + "\NETFramework.exe")
	./NETFramework.exe

	# Windows Management Framework 5.1
	$client.DownloadFile("https://go.microsoft.com/fwlink/?linkid=839516", "$tempPath\preparation" + "\WFS.msu")
	./WFS.msu

	$loopParam = "True"
	while ( "$loopParam" -eq "True" ) {
		$rebootParam = Read-Host 'When the installation is done, enter "reboot" to restart your computer'
		if ( "$rebootParam" -eq "reboot" ) {
			$loopParam = ""
		}
	}
	shutdown /r /t 0
}

Preparation