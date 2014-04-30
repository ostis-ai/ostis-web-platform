echo -en '\E[47;31m'"\033[1mScript to prepare ostis tools started\033[0m\n"



clone_project()
{
	echo -en '\E[0;32m'"\033[1mClone $2\033[0m\n"

	if [ ! -d "../$2" ]; then
		git clone $1 ../$2
	fi
	cd ../$2
	git checkout $3
	cd -
}

clone_project https://github.com/deniskoronchik/sc-machine.git sc-machine v0.1.0
clone_project https://github.com/deniskoronchik/ims.ostis.kb.git kb.sources v0.1.0
clone_project https://github.com/deniskoronchik/sc-web.git sc_web v0.1.0

echo -en '\E[0;32m'"\033[1mInstall dependencies for sc-machine\033[0m\n"
sudo ../sc-machine/scripts/install_deps_ubuntu.sh
choice=""

while [ "$choice" != "1" -a "$choice" != "2" ]
do
        echo
        echo "Do you want to setup redis >= 2.8 ?"
        echo "1) yes"
        echo "2) no"
        echo

        read choice

        case $choice in
            '1') ../sc-machine/scripts/install_redis_ubuntu.sh;;
            '2') echo "Skip redis install";;
            *)   echo "try again!";;
        esac
done

echo -en '\E[0;32m'"\033[1mBuild sc-machine\033[0m\n"
cd ../sc-machine/scripts
./make_all.sh
cd -

echo -en '\E[0;32m'"\033[1mInstall dependencies for sc-web\033[0m\n"
cd ../sc_web/scripts
./install_deps_ubuntu.sh
cd -
cp ../config/settings_local.py ../sc_web/sc_web/sc_web/
cd ../sc_web/scripts
./prepare.sh
cd -


