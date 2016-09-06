. .\utils.ps1

# a PATH variable is changed during package installation, so we need to preserve it
$oldpath = $env:Path

# is restart needed before advancing to a second stage
$restart = $false

Try{
	# see if there is chocolatey installed on the machine
	choco
}
Catch{
	# download chocolatey package manager
	iex ((New-Object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

# install prerequisite software (except VS and Qt)
cinst packages.config -yr --allowemptychecksum

# Detect available toolchains
$ms = "HKLM:\SOFTWARE\Wow6432Node\Microsoft"
if (Test-RegValue $ms\VisualStudio\12.0 InstallDir){
	$Toolchain = "VS12"
	$qt_compiler = "msvc2013"
}
elseif (Test-RegValue $ms\VisualStudio\14.0 InstallDir){
	$Toolchain = "VS14" # Full Visual Studio 2015
	$qt_compiler = "msvc2015"
}
elseif (Test-RegValue $ms\VisualCppBuildTools\14.0 Installed){
	$Toolchain = "BT14" # Visual C++ 2015 Build Tools
	$qt_compiler = "msvc2015"
}
else {
	Write-Host "No suitable toolchain found"
	Write-Host "The script will automatically install .NET 4.5.2 and Visual C++ 2015 Build Tools"
	Read-Host "Press Enter to continue, Ctrl-C to abort"

	cinst dotnet4.5.2 -yr --allowemptychecksum
	
	(New-Object net.webclient).DownloadFile("http://go.microsoft.com/fwlink/?LinkId=691126", "vcpp15bt.exe")
	Start-Process .\vcpp15bt.exe /Passive -Wait
	Start-Sleep -Milliseconds 500
    del vcpp15bt.exe
	$Toolchain = "BT14"
	$qt_compiler = "msvc2015"
	$restart = $true # both pieces of software require system reboot
}

# Qt5 installation
while ($q = Read-Host -Prompt "Do you have Qt5 installed? [y/n]") {
	if ($q -eq 'y'){
		$qtdir = Read-Host -Prompt "Qt5 install directory" 
		break
	}
	elseif ($q -eq 'n'){
		Write-Host "The script will automatically install Qt5 in C:\Qt"
		(New-Object net.webclient).DownloadFile("http://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe", "qt-online.exe")
		Start-Process ".\qt-online.exe" "--script", "qt5-unattend.qs", "Compiler=$qt_compiler" -Wait
		Start-Sleep -Milliseconds 500
        del qt-online.exe
		$qtdir = "C:\Qt"
		break
	}
	else{
		Write-Host "Please type y or n"
	}
}

# reinstall and restart redis service

if ((Get-Service | %{$_.Name}) -contains "Redis") {
	redis-server --service-stop
	redis-server --service-uninstall
}
redis-server --service-install --maxheap 100m --dir $pwd
redis-server --service-start

# update path variable so we can see a newly installed python interpreter
$p = $oldpath + ';' + [System.Environment]::GetEnvironmentVariable("Path","Machine") + ';' + [System.Environment]::GetEnvironmentVariable("Path","User")
$env:Path = ($p -Split ';' | select -Unique) -join ";"

# install python modules for web interface
python -m pip install tornado sqlalchemy redis==2.9

# install custom-built numpy module
python -m pip install .\3rd-party\numpy-1.9.3+vanilla-cp27-none-win_amd64.whl

Write-Host "Setting up firewall rules"
# firewall rules for ports 8000 (web ui) and 55770 (sc-storage server)
if (!(Test-FirewallRule -Name "scweb")){
    Add-FirewallPortRule -Name "scweb" -Port 8000
}

if (!(Test-FirewallRule -Name "sctp")){
    Add-FirewallPortRule -Name "sctp" -Port 55770
}

if ($restart){
	write-host "Your computer needs to be restarted to finish installing prerequisite software"
	write-host "Installation will continue after a reboot"
	read-host "Save your work and press Enter to reboot"
	
	# schedule the second stage to run after reboot and initiate reboot
	if (!(Test-Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce)){
        New-Item HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce
    }
    New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce -Name OstisBootstrap -PropertyType String -Value `
    "cmd /c ""cd /d $pwd & powershell -ExecutionPolicy Bypass .\bootstrap-stage2.ps1 -Toolchain $Toolchain -Qtdir $qtdir""" | out-null
	restart-computer -force
}
else{
	# software installation finished, we can drop admin privileges now
	# /env switch for 'runas' preserves the PATH environment variable
	$user = & whoami
	runas /env /user:$user "powershell .\bootstrap-stage2.ps1 -Toolchain $Toolchain -Qtdir $qtdir"
}
