#!bin/bash
# FILE   :  getnfsversion.sh
# PURPOSE:  Get the nfs-server VERSION for ltp
# HISTORY:  15/06/04  

RHOST=${RHOST:=`hostname`}

mount -t nfs $RHOST:/tmp /mnt
result=`nfsstat -m`
umount /mnt
version=`echo $result|awk -F ',' '{print $3}'`
echo ${version##*=}
