#!/bin/sh
mongo_backup_folder=/data/mongodb_backup
Keep_days=7

#find ${mongo_backup_folder}/* -maxdepth 1 -mtime +${Keep_days} -delete
find ${mongo_backup_folder}/*.aes -maxdepth 1 -mtime +${Keep_days} -exec rm -rf {} \;
