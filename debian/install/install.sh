#!/bin/bash

set -x
source ./install/include/base.inc

# Dans quelques cas j'ai eu un problème avec la date de validité du depot Wheezy/release, j'ai du :
# echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/80mintupdate-debian
# Pour revenir en arrière, supprimer ce fichier

# Pour realiser ce mount : aptitude purge apparmor
# mount -t 9p -o trans=virtio hostshare /home/guy/Docs -o version=9p2000.L,posixacl,cache=loose

if [ "$runAptitude" = "ON" ]
 then
   $CMDROOT aptitude update
   $CMDROOT aptitude dist-upgrade
   $CMDROOT aptitude install gpm vim debian-archive-keyring openssh-server rsync parted less bc gcc g++ libboost-all-dev sudo git-core cmake make libvmime-dev libpango1.0-dev
   $CMDROOT aptitude install libgraphicsmagick1-dev libgraphicsmagick++1-dev graphicsmagick unzip
   $CMDROOT aptitude install apache2 libfcgi-dev

   # ATTENTION : ce module est non-free il faut adapter le source list, migrer vers nginx ?
   #=======================================================================================
   $CMDROOT aptitude install libapache2-mod-fastcgi
fi

# Configuration d'apache2
#========================
# Pour eviter l'erreur apache2 : Could not reliably determine the server's fully qualified domain name, using 127.0.1.1 for ServerName
# Ajouter celle ligne dans /etc/apache2/apache2.conf :
# ServerName localhost

# Modifier le fichier /etc/sudoers afin d'autoriser les cmake install ect..
#==========================================================================
# old lines :
# User privilege specification
#root    ALL=(ALL:ALL) ALL

# new lines :
# User privilege specification
#root    ALL=(ALL:ALL) ALL
#guy     ALL=(root)NOPASSWD:ALL





# On installe koen-haru, nécessaire pour Wt.
#===========================================
echo
echo "Start koen-haru build"
echo
sleep 1
[ ! -d "$ROOTDEV/koen-haru" ] && mkdir $ROOTDEV/koen-haru
cd $ROOTDEV/koen-haru
export APPNAME=libharu
$ROOTDEV/install/scripts/build-koen-haru.sh

# On installe wt
#===============
echo
echo "Start witty build"
echo
sleep 1
cd $ROOTDEV/
export APPNAME=wt
$ROOTDEV/install/scripts/build-wt.sh

# On installe tiny_mce
#=====================
$ROOTDEV/install/scripts/build-tinymce.sh

# On installe gdcore, gdwtcore, wittyShare :
#===========================================
for project in gdcore gdwtcore wittyshare
 do
   echo
   echo "Start $project build"
   echo
   sleep 1
   cd $ROOTDEV/
   export APPNAME=$project
   $ROOTDEV/install/scripts/build-$project.sh
   res1=$?
   [ "$res1" != "0" ] && exit 1;
   echo "End $project build"
   echo
 done


exit 0
