#!/bin/bash

standart_path="ostis-standard/translated_scs"

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

clone_project git@github.com:ostis-ai/ostis-standard.git ostis-standart master
	if ! grep -q $standard_path ../repo.path ; then
                echo "#standard" >> ../repo.path 
                echo $standard_path >> ../repo.path
        fi
