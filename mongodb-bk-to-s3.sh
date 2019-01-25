#!/bin/sh
#
# History:
# 2019/01/18    phina

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

MONGODUMP_PATH="/data/mongodb_backup"
HOSTNAME="localhost"
MONGO_PORT="27017"
MONGO_USER=""
MONGO_PASSWORD=""
MONGO_DATABASE=""
ENV=""

TIMESTAMP=`date +%F-%H%M`
S3_BUCKET_NAME=""
#S3_BUCKET_PATH="mongodb-backups"
ENCRYPTION=""

function pre_check()
{
    if [ ! -d "$MONGODUMP_PATH" ]; then
      mkdir -p $MONGODUMP_PATH
    fi
}

pre_check

# Create backup
echo "CREATE BACKUP -- START"
mongodump -h $MONGO_HOST:$MONGO_PORT -d $MONGO_DATABASE -u $MONGO_USER -p $MONGO_PASSWORD -o $MONGODUMP_PATH/$MONGO_DATABASE

# Add timestamp to backup
echo "ADD TIMESTAMP TO BACKUP -- START"
mv $MONGODUMP_PATH/$MONGO_DATABASE $MONGODUMP_PATH/mongodb-$ENV-$TIMESTAMP
cd $MONGODUMP_PATH
tar cf - mongodb-$ENV-$TIMESTAMP | openssl aes-256-cbc -e -out mongodb-$ENV-$TIMESTAMP.aes -k $ENCRYPTION

# Upload to S3
echo "UPLOAD TO S3"
/root/.local/bin/aws s3 cp  $MONGODUMP_PATH/mongodb-$ENV-$TIMESTAMP.aes s3://$S3_BUCKET_NAME  > /tmp/s3cmd.log
echo "$MONGODUMP_PATH/mongodb-$ENV-$TIMESTAMP.aes s3://$S3_BUCKET_NAME  > /tmp/s3cmd.log"

rm -rf $MONGODUMP_PATH/mongodb-$ENV-$TIMESTAMP $MONGODUMP_PATH/mongodb-$ENV-$TIMESTAMP.tar
echo "SUCCESSFUL"
