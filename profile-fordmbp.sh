#!/bin/bash

# load the main profile settings
export DEVELOPMENT=~/Development
export SCRIPTS=$DEVELOPMENT/dotfiles

# setup the flavor
export DOTFILE_FLAVOR=fordmbp

# bring on the profile
source $SCRIPTS/profile.sh

# ========== per-computer customization after here, but NOT SECRETS! those go in ./secrets.sh ==========

obsave () {
	commit_folder_changes ~/Documents/Knowledge
}

# for macOS only!
# Immediately lock the screen, then do some wrapup tidying stuff.
lock () {
	# This only sets the display to sleep, to make it also lock the screen
	# you need to update "System Settings > Lock Screen > Require password after screen saver..."
	# set this to "Immediately".
	pmset displaysleepnow
	# Make sure knowledge store is backed up.
	obsave
	# Kick off the appropriate HASS scene.
	curl \
		-H "Authorization: Bearer $HASS_TOKEN" \
		-H "Content-Type: application/json" \
		--request POST \
		--data '{"entity_id":"scene.leave_office"}' \
		"${HASS_URL}/api/services/scene/turn_on"
}
