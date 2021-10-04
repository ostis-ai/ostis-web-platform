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
    if [[ $line == "SavePeriod = "* ]];then
        savePeriod=${line##* }
        isEnd=false
    else
        savePeriod=3600
    fi
  fi
  if [[ $line == "DumpPath = "* ]];then
      dumpsPath=${line##* }
  else
      dumpsPath=$path"/dumps"
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
echo "save period: $savePeriod miliseconds"
currentName="segments.scdb"
LTIME=$(date +%s)
echo "waiting for a new dump"
while true    
do
   ATIME=$(date +%s)
   dumpdate=$(date +"%T-%m-%d-%y") 
   runtime=$((($ATIME-$LTIME)*60))
   if [[ "$runtime" == "$savePeriod" ]]
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
