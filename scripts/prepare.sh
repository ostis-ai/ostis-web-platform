#!/bin/bash

red="\e[1;31m"  # Red B
blue="\e[1;34m" # Blue B
green="\e[0;32m"

bwhite="\e[47m" # white background

rst="\e[0m"     # Text reset

st=1

stage()
{
    echo -en "$green[$st] "$blue"$1...$rst\n"
    let "st += 1"
}

clone_project()
{
    if [ ! -d "../$2" ]; then
        echo -en $green"Clone $2$rst\n"
        git clone $1 ../$2
        cd ../$2
        git checkout $3
        cd -
    else
        echo -en "You can update "$green"$2"$rst" manualy$rst\n"
    fi
}

stage "Clone projects"

clone_project https://github.com/ShunkevichDV/sc-machine.git sc-machine 0.6.0
clone_project https://github.com/ostis-apps/sc-web.git sc-web 0.6.0
clone_project https://github.com/ShunkevichDV/ims.ostis.kb.git ims.ostis.kb 0.6.0

stage "Prepare projects"

prepare()
{
    echo -en $green$1$rst"\n"
}

prepare "sc-machine"

cd ../sc-machine/scripts
python3Version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
sed -i -e "s/python3.5-dev/python$python3Version-dev/" ./install_deps_ubuntu.sh
sed -i -e "s/python3.5-dev/python$python3Version/" ./install_deps_ubuntu.sh
./install_deps_ubuntu.sh

cd ..
pip3 install -r requirements.txt

cd scripts
./make_all.sh

cat ../bin/config.ini >> ../../config/sc-web.ini

prepare "sc-server web"
sudo apt-get install -y curl
sudo apt remove -y cmdtest
sudo apt remove -y yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install -y yarn
cd ../web/client
yarn && yarn run webpack-dev
cd ../..

prepare "sc-web"
sudo pip3 install --default-timeout=100 future
sudo apt-get install python-setuptools
cd ../sc-web/scripts

sudo apt-get install -y nodejs-dev node-gyp libssl1.0-dev libcurl4-openssl-dev
./install_deps_ubuntu.sh
./install_nodejs_dependence.sh

cd -
cd ../sc-web
npm install
grunt build
cd -
echo -en $green"Copy server.conf"$rst"\n"
cp -f ../config/server.conf ../sc-web/server/

stage "Build knowledge base"

cd ../scripts
./build_kb.sh
