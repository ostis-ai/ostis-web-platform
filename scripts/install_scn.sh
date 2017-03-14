#!/bin/bash
#rst="\e[0m"     # Text reset

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

clone_project https://bitbucket.org/iit-ims-team/web-scn-editor web-scn-editor

cd ../web-scn-editor
npm install
grunt build
grunt exec:renewComponentsHtml
