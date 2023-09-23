#!/usr/bin/env bash

clone_update_submodule()
{
  UPDATE=false
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --repo)
        shift 1
        REPO="$1"
        ;;
      --path)
        shift 1
        SUBMODULE_PATH="$1"
        ;;
      --branch)
        shift 1
        BRANCH="$1"
        ;;
      --update)
        shift 1
        UPDATE=true
        ;;
      --commit)
        shift 1
        COMMIT="$1"
        ;;
    esac
    shift 1
  done

  if [ -z "$SUBMODULE_PATH" ];
  then
    printf "Empty paths are dangerous in use. Use another path instead for submodules installation or update.\n"
    exit 1
  fi
  if [[ ! -d "$SUBMODULE_PATH" || "$UPDATE" ]]; then
    if "$UPDATE";
    then
      printf "Remove submodule %s (%s) %s \n" "$REPO" "$BRANCH" "$SUBMODULE_PATH"
      rm -rf "$SUBMODULE_PATH"
      git pull
    fi

    printf "Clone submodule %s (%s) into %s\n" "$REPO" "$BRANCH" "$SUBMODULE_PATH"
    git clone "$REPO" --branch "$BRANCH" --single-branch "$SUBMODULE_PATH" --recursive
    if [ -n "$COMMIT" ];
      then
        cd "$SUBMODULE_PATH" && git checkout "$COMMIT"
    fi
  else
    printf "You can update %s manually. Use this script with \"update\" parameter.\n" "$SUBMODULE_PATH"
  fi
}
