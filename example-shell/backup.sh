#!/bin/bash

BACKUPS_DESTINATION="/data-hdd/backups/arch-beast"

# format
# rsync -a --delete --quiet /path/to/backup /location/of/backup

# stop the script if an error occurs
set -e

rsync -a --delete --quiet --exclude="{"/home/*/.cache/*"}" /home/[user] $BACKUPS_DESTINATION/home
rsync -a --delete --quiet /etc $BACKUPS_DESTINATION

echo "Made backups on: $(date)" >> /var/log/backup.log
