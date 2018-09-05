#!/bin/bash
# NO VERSION SET!!! VERS=$(ls $ROOTPATCH/zookeeper/build/zookeeper-*-bin.jar|cut -d'-' -f2)
#VERS=3.6.0
BPATH=$(pwd)
ROOTPATCH="/tmp/zookeeperbuild"
rm -fR $ROOTPATCH
mkdir -p $ROOTPATCH

cd $ROOTPATCH
yum install -y git ant make rpm-build rpmdevtools mock yum autoconf automake cppunit-devel cppunit libtool

git clone https://github.com/apache/zookeeper.git

cd $ROOTPATCH/zookeeper

ant tar
echo "erase Snapshot in name"
find  $ROOTPATCH/zookeeper/build/*  -name "*-SNAPSHOT*" -type d|while read FILENAME; do NFILENAME=`echo $FILENAME|sed 's/-SNAPSHOT//g'`; mv "$FILENAME" "$NFILENAME" ;done
find  $ROOTPATCH/zookeeper/build/*  -name "*-SNAPSHOT*" -type f|while read FILENAME; do NFILENAME=`echo $FILENAME|sed 's/-SNAPSHOT//g'`; mv "$FILENAME" "$NFILENAME" ;done

find  $ROOTPATCH/zookeeper/build/*  -name "*-beta*" -type d|while read FILENAME; do NFILENAME=`echo $FILENAME|sed 's/-beta//g'`; mv "$FILENAME" "$NFILENAME" ;done
find  $ROOTPATCH/zookeeper/build/*  -name "*-beta*" -type f|while read FILENAME; do NFILENAME=`echo $FILENAME|sed 's/-beta//g'`; mv "$FILENAME" "$NFILENAME" ;done

cd $ROOTPATCH/zookeeper/build/

VERS=$(ls $ROOTPATCH/zookeeper/build/zookeeper-*-bin.jar|cut -d'-' -f2)
echo "Rename"
mkdir rename
mv zookeeper-$VERS.tar.gz rename/.
cd rename
tar -xzf zookeeper-$VERS.tar.gz 

find  ./  -name "*-beta*" -type d|while read FILENAME; do NFILENAME=`echo $FILENAME|sed 's/-beta//g'`; mv "$FILENAME" "$NFILENAME" ;done
find  ./  -name "*-beta*" -type f|while read FILENAME; do NFILENAME=`echo $FILENAME|sed 's/-beta//g'`; mv "$FILENAME" "$NFILENAME" ;done

find  ./  -name "*-SNAPSHOT*" -type d|while read FILENAME; do NFILENAME=`echo $FILENAME|sed 's/-SNAPSHOT//g'`; mv "$FILENAME" "$NFILENAME" ;done
find  ./  -name "*-SNAPSHOT*" -type f|while read FILENAME; do NFILENAME=`echo $FILENAME|sed 's/-SNAPSHOT//g'`; mv "$FILENAME" "$NFILENAME" ;done

echo "create new tar"
tar -czf zookeeper-$VERS.tar.gz zookeeper-$VERS
cd ..
mv rename/zookeeper-$VERS.tar.gz .
rm -fR rename
 
cd $BPATH
echo "get build spec"
#git clone https://github.com/antonprk/zookeeper-rpms
#cd zookeeper-snapshot-rpms
cp -a $ROOTPATCH/zookeeper/build/zookeeper-$VERS.tar.gz .

sed -i 's/define rel_ver.*/define rel_ver '$VERS'/' zookeeper.spec 
sed -i 's/Source0:.*/Source0: zookeeper-'$VERS'\.tar\.gz/' zookeeper.spec 

rm -fR /var/lib/mock/*
sudo mock  --init
rpmdev-setuptree
spectool -g zookeeper.spec
rpmbuild -bs --nodeps --define "_sourcedir $(pwd)" --define "_srcrpmdir $(pwd)" zookeeper.spec
sudo mock "$(pwd)/$(ls zookeeper-*-1.src.rpm)"

cd $BPATH
mkdir -p RPMS
rm -fR RPMS/*
cp -a /var/lib/mock/epel-7-x86_64/root/builddir/build/RPMS/* RPMS/.
echo "BUILD COMPLETE!"
cd RPMS
pwd
ls -l /$BPATH/RPMS
echo "done.."
