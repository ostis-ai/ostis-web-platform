# a PATH variable is changed during the next command, so we need to preserve it
$oldpath = $env:Path

# download chocolatey package manager
iex ((New-Object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# install prerequisite software (except VS and Qt)
choco install git -version 2.6.2 -yr
choco install cmake python2 redis-64 -yr
choco install jdk7 -y

# reinstall and restart redis service
redis-server --service-stop
redis-server --service-uninstall 
redis-server --service-install --maxheap 100m
redis-server --service-start

# update path variable so we can see a newly installed python interpreter
# we also need to preserve VS environment vars (oldpath variable)
$p = $oldpath + ';' + [System.Environment]::GetEnvironmentVariable("Path","Machine") + ';' + [System.Environment]::GetEnvironmentVariable("Path","User")
$env:Path = ($p -Split ';' | select -Unique) -join ";"

# install python modules for web interface
python -m pip install tornado sqlalchemy redis==2.9

# install custom-built numpy module
python -m pip install .\3rd-party\numpy-1.9.3+vanilla-cp27-none-win_amd64.whl

# software installation finished, we can drop admin privileges now
# remember to preserve the PATH, thus /env switch for 'runas'
$user = & whoami
runas /env /user:$user "powershell .\bootstrap-ostis-stage2.ps1"

exit