#!/bin/bash

#get current dir through symlink
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#get current countly version
VERSION="$(grep -oP '"version":\s*"\K[0-9\.]*' $DIR/../../package.json)"

#stub commands to be overwritten
countly_start (){
    echo "start stub";
} 

countly_stop (){
    echo "stop stub";
} 

countly_restart (){
    echo "restart stub";
} 

#real commands, can also be overwritten
countly_upgrade (){ 
    (cd $DIR/../.. ;
    npm install ;
    grunt dist-all;
    countly restart;
    )
}

countly_version (){
     echo $VERSION;
}

#load real platform/init sys file to overwrite stubs
source $DIR/enabled/countly.sh

#process command
if [ "$1" = "start" ]; then
    countly_start;
elif [ "$1" = "stop" ]; then
    countly_stop;
elif [ "$1" = "restart" ]; then
    countly_restart;
elif [ "$1" = "upgrade" ]; then
    countly_upgrade
elif [ "$1" = "version" ]; then
    countly_version
else
    echo "";
    echo "usage:";
    echo "    countly start   # starts countly process";
    echo "    countly stop    # stops countly process";
    echo "    countly restart # restarts countly process";
    echo "    countly upgrade # standard upgrade process (install dependencies, minify files, restart countly)";
    echo "    countly version # outputs current countly version";
    echo "    countly usage   # prints this out, but so as basically everything else does";
    echo "";
fi