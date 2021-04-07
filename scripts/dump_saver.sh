#!/bin/bash

echo "script for saving dumps starts..."
isEnd=false
isStart=false
if [ -z $1 ]; then
    file="../config/sc-web.ini"
else
    file=$1
fi
echo "initial file path: "$file
while IFS= read -r line
do
  if $isEnd; then
    if [[ $line == "DumpPath = "* ]];then
        dumpsPath=${line##* }
        isEnd=false
    else
        dumpsPath=$path"/dumps"
    fi
  fi
  if $isStart; then
    path=${line##* }
    isEnd=true
    isStart=false
  fi
  if [[ "$line" == "[Repo]" ]]
  then
    isStart=true
  fi
done < $file
echo "segments.scdb path: "$path
echo "dumps path: "$dumpsPath
currentName="segments.scdb"
LTIME=`stat -c %Z $path/$currentName`
echo "waiting for a new dump"
while true    
do
   ATIME=`stat -c %Z $path/$currentName`
   dumpdate=$(date +"%T-%m-%d-%y") 
   if [[ "$ATIME" != "$LTIME" ]]
   then    
        if [ -d $dumpsPath ]; then
            cp $path/$currentName $dumpsPath/$dumpdate.scdb
        else 
            mkdir $dumpsPath
            cp $path/$currentName $dumpsPath/$dumpdate.scdb
        fi
       LTIME=$ATIME
       echo "dump saved"
       echo "waiting for a new dump"
   fi
done
