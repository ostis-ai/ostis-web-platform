#!/bin/bash
#rst="\e[0m"     # Text reset
sudo apt-get update
    sudo apt-get install nodejs
	sudo apt-get install npm
	sudo npm cache clean -f
	sudo npm install -g n
	sudo n stable
	echo "Installing grunt"
	sudo npm install -g grunt-cli
	cd ../
	if [ -d web-scn-editor/ ]; then
 	echo 'Web-scn-editor already cloned, i will delete it.'
 	rm -rf web-scn-editor/
fi
	git clone https://bitbucket.org/iit-ims-team/web-scn-editor
	cd scripts/
	cd ../

cd sc-web
echo "var scWebPath = '">../text1.txt
pwd>>../text1.txt
echo "/';">>../text1.txt
cat ../text1.txt | tr -d '\n'> ../out.txt
grep -v "var scWebPath = '" ../web-scn-editor/build_config.js > ../out.js
cat ../out.js > ../web-scn-editor/build_config.js
rm -rf ../out.js
cd ..
pwd
awk '{print} NR==3 {while (getline < "out.txt") print}'  web-scn-editor/build_config.js > out.js
cat out.js > web-scn-editor/build_config.js
rm -rf out.js
rm -rf text1.txt
rm -rf out.txt
cd web-scn-editor/
npm install
pwd
git update-index --assume-unchanged build_config.js
grunt build
grunt exec:renewComponentsHtml
