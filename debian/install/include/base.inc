export buildRelease=ON
export buildDebug=ON
export runAptitude=OFF
export cleanUpGit=OFF
export cleanUpBuild=OFF
export cleanUpInstall=OFF

export IPREFIX=/usr/local
export ROOTDEV=

if [ "$UID" != "0" ]
 then
   CMDROOT=`which sudo`
   if [ "$CMDROOT" = "" ]
    then
     CMDROOT="su -c"
   fi
   export CMDROOT
fi

if [ ! -d "$ROOTDEV" ]
 then
 ROOTDEV=$PWD
 #echo "Please create or modify the ROOT DEV Directory in $PWD/install/include/base.inc"
 #exit 1
fi

cd $ROOTDEV

