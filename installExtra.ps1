#Adding variables
. .\param.ps1

#Instalation of extra programms
function Install {
	new-item "$tempPath\installExtra" -itemtype directory
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco install -y apache-httpd --params $apacheDir
	choco install -y mysql-odbc
	choco install -y googlechrome
}

Install