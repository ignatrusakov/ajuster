#Adding variables
. .\param.ps1

#Removing temp files and directories
function Conclusion {
	net use * /del /y
	Set-Location -Path "C:\"
	Remove-Item "$tempPath"
	Remove-Item "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\restart.bat"
}

Conclusion