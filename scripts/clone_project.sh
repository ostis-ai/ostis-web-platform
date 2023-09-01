#!/usr/bin/env bash

clone_project()
{
  if [ -z "$2" ];
  then
    printf "Empty paths are dangerous in use. Use another path instead for submodules installation or update.\n"
    exit 1
  fi
  if [[ ! -d "$2" || "$1" == "--update" ]]; then
    if [ "$1" == "--update" ];
    then
      printf "Remove submodule %s (%s) %s \n" "$1" "$3" "$2"
      rm -rf "$2"
      git pull
    fi

    printf "Clone submodule %s (%s) into %s\n" "$1" "$3" "$2"
    git clone "$1" --branch "$3" --single-branch "$2" --recursive
  else
    printf "You can update %s manually. Use this script with \"update\" parameter.\n" "$2"
  fi
}
