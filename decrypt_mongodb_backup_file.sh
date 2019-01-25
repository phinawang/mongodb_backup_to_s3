#!/bin/bash
#
# History:
# 2019/01/18    phina


PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

PASSWORD=$1
BACKUPFILE=$2

echo "START TO DECRYPT $1 ----------------"
openssl aes-256-cbc -d -in $BACKUPFILE -k $PASSWORD | tar xvf -
echo "FINISH------------------------------"
