#!/bin/bash

# fsdaemon a besoin de zeroMq et de fam (remplacer par gamin)
#==============================================================
if [ "$runAptitude" = "ON" ]
 then
   sudo aptitude install libzmq-dev libgamin-dev libjsoncpp-dev libarchive-dev uuid-dev libcurl4-gnutls-dev libsqlite3-dev sqlite3
fi

# On cree les répertoires nécessaires à wittyshare :
#===================================================
[ ! -d "/var/www/users" ] && $CMDROOT mkdir /var/www/users

[ "$cleanUpGit" = ON ] && [ -d "$APPNAME" ] && rm -Rf $APPNAME/

if [ ! -d "$APPNAME" ] 
 then
   git clone https://github.com/Wittyshare/$APPNAME.git
   res1=$?
   [ "$res1" != "0" ] && exit 1;
fi
cd $APPNAME/

git pull origin master
res1=$?
[ "$res1" != "0" ] && exit 1;

# le Nom du repertoire de build
#==============================
DIRBUILD=`pwd`/"build-"`uname -m`"-"`uname -s`

[ "$cleanUpBuild" = "ON" ] && [ -d "$DIRBUILD" ] && $CMDROOT rm -Rf $DIRBUILD
[ ! -d "$DIRBUILD" ] && mkdir $DIRBUILD
cd $DIRBUILD

varCmake="-D APPNAME=$APPNAME -D WS_PREFIX=/usr/local/wittyshare -D CMAKE_INSTALL_PREFIX=$IPREFIX/$APPNAME -D HARU_PREFIX=/usr/local/libharu  -D GDCORE_PREFIX=/usr/local/gdcore -DWSCORE_PREFIX=/usr/local/wscore ../../"

if [ "$buildDebug" = "ON" ]
 then
   [ ! -d "Debug" ] && mkdir Debug
   cd Debug
   cmake -D CMAKE_BUILD_TYPE=Debug $varCmake
   res1=$?
   [ "$res1" != "0" ] && exit 1;
   make
   res1=$?
   [ "$res1" != "0" ] && exit 1;
   $CMDROOT make install
   res1=$?
   [ "$res1" != "0" ] && exit 1;
   
   cd ../
fi

if [ "$buildRelease" = "ON" ]
 then
   [ ! -d "Release" ] && mkdir Release
   cd Release
   cmake -D CMAKE_BUILD_TYPE=Release $varCmake
   res1=$?
   [ "$res1" != "0" ] && exit 1;
   make
   res1=$?
   [ "$res1" != "0" ] && exit 1;
   $CMDROOT make install
   res1=$?
   [ "$res1" != "0" ] && exit 1;
   
   cd ../
fi

echo "$IPREFIX/$APPNAME"/lib | $CMDROOT tee /etc/ld.so.conf.d/$APPNAME.conf
$CMDROOT ldconfig

exit 0

