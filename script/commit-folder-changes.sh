#!/bin/bash

#
# This command is used by a cronjob to commit any changes that might
# happen in a named folder. You would use it like this:
#
#   ./commit_folder_changes $FOLDER_PATH
#
# It requires that you already have git installed and configured, of
# course.
#
# You can add it to cronjob so that it runs every few minutes. First
# open the crontab to edit:
#
#   crontab -e
#
# And then add a line something like this:
#
#   * * * * * source ~/.profile && commit_folder_changes FOLDER >"$DOTFILE_LOGS/NAME.log 2>$DOTFILE_LOGS/NAME-err.log
#
# For example, if you have a git folder in Documents named Knowledge:
#
#   * * * * * source ~/.profile && commit_folder_changes ~/Documents/Knowledge >"$DOTFILE_LOGS/autocommit-knowledge.log 2>$DOTFILE_LOGS/autocommit-knowledge-err.log
#
# This will:
# - run the command every minute
# - log output to the named .log file
# - log error output to the named -err.log file
#

commit_folder_changes () {
	CHANGE_FOLDER=${1}
	DATE=`date "+%Y-%m-%d %H:%M:%S"`
	cd $CHANGE_FOLDER
	if [ `git ls-files -m -o | wc -l` -ne 0 ]; then
		echo "[$DATE] changes detected by ${DOTFILE_FLAVOR} in ${CHANGE_FOLDER}"
		git ls-files -m -o
		git add -A
		git commit -am "cronjob update by ${DOTFILE_FLAVOR}"
		git push -u origin main
	fi
}
