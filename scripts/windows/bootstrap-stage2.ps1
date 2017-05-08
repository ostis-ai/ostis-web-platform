param([ValidateSet('VS12', 'VS14', 'BT14')]$Toolchain, [string]$Qtdir)

. .\utils.ps1

# change to working directory
pushd ..\..

# clone latest sources from github
if(!(Test-Path .\sc-machine)){
	git clone -b scp_stable https://github.com/shunkevichdv/sc-machine
}

if(!(Test-Path .\sc-web)){
	git clone https://github.com/Ivan-Zhukau/sc-web
}

if(!(Test-Path .\ims.ostis.kb)){
	git clone -b dev https://github.com/shunkevichdv/ims.ostis.kb
}

if(!(Test-Path .\kb.bin)){
	mkdir kb.bin | out-null
}

# pull a minimum required subset of ims.ostis KB {

# recreate a target location anew
del -Recurse -Force -ErrorAction SilentlyContinue ims.ostis.kb_copy
mkdir ims.ostis.kb_copy | out-null

copy -Recurse ims.ostis.kb\ims\ostis_tech\semantic_network_represent\ ims.ostis.kb_copy\
copy -Recurse ims.ostis.kb\ims\ostis_tech\unificated_models\ ims.ostis.kb_copy\
copy -Recurse ims.ostis.kb\ims\ostis_tech\semantic_networks_processing\ ims.ostis.kb_copy\
copy -Recurse ims.ostis.kb\ims\ostis_tech\lib_ostis\sectn_lib_of_reusable_comp_ui\ui_menu\ ims.ostis.kb_copy\
copy -Recurse ims.ostis.kb\ims\ostis_tech\lib_ostis\sectn_lib_reusable_comp_kpm\reusable_sc_agents\lib_c_agents\ ims.ostis.kb_copy\
copy -Recurse ims.ostis.kb\ims\ostis_tech\lib_ostis\sectn_lib_reusable_comp_kpm\reusable_sc_agents\lib_scp_agents\ ims.ostis.kb_copy\
copy -Recurse ims.ostis.kb\ims\ostis_tech\lib_ostis\sectn_lib_reusable_comp_kpm\programs_for_sc_text_processing\scp_program\ ims.ostis.kb_copy\
copy -Recurse ims.ostis.kb\to_check\ ims.ostis.kb_copy\
copy -Recurse ims.ostis.kb\ui\ ims.ostis.kb_copy\
del -Recurse ims.ostis.kb_copy\ui\menu
# }

# prepare GUI
pushd sc-web\scripts
.\client.bat
npm install -g grunt-cli
popd

pushd sc-web
npm install
grunt build
popd

copy config\server.conf sc-web\server

pushd sc-machine

switch($Toolchain){
	"VS12" {
	    $env:CMAKE_PREFIX_PATH = @(dir -Recurse -Path $Qtdir -Filter msvc2013_64 | ?{ $_.PSIsContainer })[0].FullName
		# pull in environment for vs2013
		pushd $env:VS120COMNTOOLS\..\..\VC
		Invoke-CmdScript vcvarsall.bat amd64
		popd
		# generate makefiles for x64 vs2013
		& "${env:ProgramFiles}\CMake\bin\cmake" -G 'Visual Studio 12 2013 Win64' .
	}
	"VS14" {
		$env:CMAKE_PREFIX_PATH = @(dir -Recurse -Path $Qtdir -Filter msvc2015_64 | ?{ $_.PSIsContainer })[0].FullName
		# pull in environment for VS2015
		pushd $env:VS140COMNTOOLS\..\..\VC
		Invoke-CmdScript vcvarsall.bat amd64 
		popd
		# generate makefiles for x64 vs2015
		& "${env:ProgramFiles}\CMake\bin\cmake" -G 'Visual Studio 14 2015 Win64' .
	}
	"BT14"{
		$env:CMAKE_PREFIX_PATH = @(dir -Recurse -Path $Qtdir -Filter msvc2015_64 | ?{ $_.PSIsContainer })[0].FullName
		# pull in environment for vc++ 2015 build tools
		pushd "${env:ProgramFiles(x86)}\Microsoft Visual C++ Build Tools"
		Invoke-CmdScript vcbuildtools.bat amd64 
		popd
		# generate makefiles for x64 vs2015
		& "${env:ProgramFiles}\CMake\bin\cmake" -G 'Visual Studio 14 2015 Win64' .
	}
}

# build generated solution
msbuild /m sc-machine.sln /property:Configuration=Release

# copy required qt5 runtime libs
copy $env:CMAKE_PREFIX_PATH\bin\Qt5Core.dll bin\
copy $env:CMAKE_PREFIX_PATH\bin\Qt5Network.dll bin\
popd

write-host
write-host -nonewline -foregroundcolor green "Base system installation is now complete. Press Enter to leave the installer. "
read-host
