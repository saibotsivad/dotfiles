#!/bin/bash

#
# This command is used by a cronjob to commit any changes
# that might have synced to Inkdrop's backup. It requires
# the environment variable $INKDROP_BACKUP_FOLDER to be set,
# and the `inkdrop-to-binder` npm library to be installed
# globally.
#
# Add it to your Mac cronjob via:
#
# crontab -e
#
# And then add the line:
#
# * * * * * source ~/.profile && commit_inkdrop_changes >/tmp/inkdrop-sync.log 2>/tmp/inkdrop-sync-err.log
#
# Which will run this command every minute, and log to the listed error file.
#

commit_inkdrop_changes () {
	DATE=`date "+%Y-%m-%d %H:%M:%S"`
	cd $INKDROP_BACKUP_FOLDER
	if [ `git ls-files -m -o | wc -l` -ne 0 ]; then
		echo "[$DATE] there are changes"
		rm -rf $INKDROP_BACKUP_FOLDER/inkdrop-binder
		inkdrop-to-binder \
		  --input=$INKDROP_BACKUP_FOLDER/raw-inkdrop-data \
		  --output=$INKDROP_BACKUP_FOLDER/inkdrop-binder
		git add -A
		git commit -am "cronjob update"
		git push -u origin master
	else
		echo "[$DATE] there are not changes"
	fi
}
