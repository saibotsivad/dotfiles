#!/bin/bash

#
# This is the script which will check if an active meeting is in progress or
# not, and will update the state of the entity in HASS.
#
# You will want to add it to cronjob so that it runs as often as possible. First
# open the crontab to edit:
#
#   crontab -e
#
# And then add a line something like this:
#
#   * * * * * source ~/.profile && hass_active_meeting_update >"$DOTFILE_LOGS/hass_active_meeting_update.log" 2>"$DOTFILE_LOGS/hass_active_meeting_update-err.log"
#
# This will:
# - run the command every minute
# - log output to the named .log file
# - log error output to the named -err.log file
#

# We store the current state locally, so we don't need to constantly push
# updates. If it exists, it can be "1" or "0".
LOCAL_STATE_FILE=/tmp/dotfiles-script-hass-active-meeting

hass_active_meeting_update () {
	IN_MEETING=0

	# Look for active Webex meeting.
	if ps aux | grep --quiet "[w]ebexmta.app"; then
		IN_MEETING=1
	fi

	# TODO: look for Slack huddle

	# TODO: look for active Zoom meeting

	NEEDS_PUSHED=0
	if [ -f "$LOCAL_STATE_FILE" ]; then
		if grep -q "1" "$LOCAL_STATE_FILE"; then
			if [[ $IN_MEETING -eq 0 ]]; then
				NEEDS_PUSHED=1
			fi
		fi
		if grep -q "0" "$LOCAL_STATE_FILE"; then
			if [[ $IN_MEETING -eq 1 ]]; then
				NEEDS_PUSHED=1
			fi
		fi
	else
		NEEDS_PUSHED=1
	fi

	if [[ $NEEDS_PUSHED -eq 1 ]]; then
		if [[ $IN_MEETING -eq 1 ]]; then
			MEETING_STATE="true"
		else
			MEETING_STATE="false"
		fi
		echo "updating meeting status to ${IN_MEETING}"
		# https://developers.home-assistant.io/docs/api/rest#actions
		curl \
			-H "Authorization: Bearer $HASS_TOKEN" \
			-H "Content-Type: application/json" \
			--request POST \
			--data "{\"state\":${MEETING_STATE}}" \
			"${HASS_URL}/api/states/input_boolean.tobias_in_meeting"
		printf '%s' "${IN_MEETING}" > $LOCAL_STATE_FILE
	fi
}
