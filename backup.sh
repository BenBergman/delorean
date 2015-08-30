#!/bin/sh

date=`date "+%Y-%m-%dT%H_%M_%S"`
HOME=/home/$USER/
backupserver="192.168.0.5"
Backups=/mnt/data/backups/macbookben_rsync

rsync -azP \
  --delete \
  --delete-excluded \
  --exclude-from=$HOME/.rsync/exclude \
  --link-dest=../current \
  $HOME $USER@$backupserver:$Backups/incomplete_back \
  && ssh $USER@$backupserver \
  "mv $Backups/incomplete_back $Backups/back-$date \
  && rm -f $Backups/current \
  && ln -s back-$date $Backups/current \
  && cd $Backups \
  && ./cleanup.sh"

