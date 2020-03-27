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

clone_project https://github.com/MikhailSadovsky/sc-machine.git sc-machine release/0.6.0
clone_project https://github.com/Ivan-Zhukau/sc-web.git sc-web master
clone_project https://github.com/MikhailSadovsky/ims.ostis.kb.git ims.ostis.kb 0.6.0

stage "Prepare projects"

prepare()
{
    echo -en $green$1$rst"\n"
}

prepare "sc-machine"

cd ../sc-machine/scripts
./install_deps_ubuntu.sh

cd ..
pip3 install -r requirements.txt

cd scripts
./make_all.sh

cat ../bin/config.ini >> ../../config/sc-web.ini

prepare "sc-server web"
sudo apt remove cmdtest
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install yarn
cd ../web/client
yarn && yarn run webpack-dev
cd ../..

prepare "sc-web"
sudo pip3 install --default-timeout=100 future
sudo apt-get install python-setuptools
cd ../sc-web/scripts

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
