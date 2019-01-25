# mongodb_backup_to_s3
mongodb backup by mongodump

# Overview
1. You can backup your MongoDB by using normal mongodump
2. Encrypt the backup folder using open ssl AES256
3. Upload to S3 using AWS cli
4. Set up a daily backup via `crontab -e`:
5. Keep local backup file for 7 days
6. Decrypt backup file
7. Restore database

# Make sure your AWS cli is installed and set up
https://docs.aws.amazon.com/en_us/cli/latest/userguide/cli-chap-install.html

# How to Use
1. Set parameter of mongodb-bk-to-s3.sh via `vim mongodb-bk-to-s3.sh`
2. run mongodb-bk-to-s3.sh
3. check your upload file of AWS s3 bucket
4. add crontab

# Usages
Backup & upload to S3
```
/bin/bash mongodb-bk-to-s3.sh
```
Clean 7 days ago file
```
/bin/bash clean_mongodb_bk.sh
```
Decrpt mongoDB backup file(AES256)
```
/bin/bash decrypt_mongodb_backup_file.sh $ENCRYPT_PASSWORD $BACKUP_FILNAME
```

# Add Crontab
```
* */12 * * * /bin/bash /data/mongodb_backup/mongodb-bk-to-s3.sh > /var/log/mongodb/mongodb-backup.log 2>&1
0 1 * * * /bin/bash /data/mongodb_backup/clean_mongodb_bk.sh
```

# Restore MongoDB
```
mongorestore --host $HOSTNAME --db $DATABASE_NAME $BACKUP_FILE/
```
