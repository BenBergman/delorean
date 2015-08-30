DeLorean
========

A home made Time Machine

Usage
-----

1. Copy `backup.sh` onto the computer you want to have backed up.
2. Edit it to update any include/exclude directories.
3. Copy `cleanup.sh` onto the backup server in your backup directory.
4. Add a line like the following to your crontab:

```
@hourly         ID=backup      $HOME/bin/backup.sh
```
