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

	# Look for Slack huddle
	# tobiasdavis      83963   2.5  0.2 409023376  35584   ??  S    10:25AM   0:24.56 /Applications/Slack.app/Contents/Frameworks/Slack Helper (Plugin).app/Contents/MacOS/Slack Helper (Plugin) --type=utility --utility-sub-type=video_capture.mojom.VideoCaptureService --lang=en-US --service-sandbox-type=none --enable-logging --message-loop-type-ui --user-data-dir=/Users/tobiasdavis/Library/Application Support/Slack --standard-schemes=app,slack-webapp-dev --enable-sandbox --secure-schemes=app,slack-webapp-dev --bypasscsp-schemes=slack-webapp-dev --cors-schemes=slack-webapp-dev --fetch-schemes=slack-webapp-dev --service-worker-schemes=slack-webapp-dev --streaming-schemes --enable-logging --log-file=/Users/tobiasdavis/Library/Application Support/Slack/logs/default/electron_debug.log --shared-files --field-trial-handle=1718379636,r,18334022373887770749,14696868611440964740,131072 --disable-features=AllowAggressiveThrottlingWithWebSocket,CalculateNativeWinOcclusion,HardwareMediaKeyHandling,IntensiveWakeUpThrottling,LogJsConsoleMessages,RequestInitiatorSiteLockEnfocement,SpareRendererForSitePerProcess,WebRtcHideLocalIpsWithMdns,WinRetrieveSuggestionsOnlyOnDemand
	if ps aux | grep --quiet "[S]lack Helper.*VideoCaptureService"; then
		IN_MEETING=1
	fi

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
			SCENE_STATE="start"
		else
			MEETING_STATE="false"
			SCENE_STATE="stop"
		fi
		echo "updating meeting status to ${IN_MEETING}"
		# https://developers.home-assistant.io/docs/api/rest#actions
		curl \
			-H "Authorization: Bearer $HASS_TOKEN" \
			-H "Content-Type: application/json" \
			--request POST \
			--data "{\"state\":${MEETING_STATE}}" \
			"${HASS_URL}/api/states/input_boolean.tobias_in_meeting"
		curl \
			-H "Authorization: Bearer $HASS_TOKEN" \
			-H "Content-Type: application/json" \
			--request POST \
			--data "{\"entity_id\":\"scene.tobias_meeting_${SCENE_STATE}\"}" \
			"${HASS_URL}/api/services/scene/turn_on"
		printf '%s' "${IN_MEETING}" > $LOCAL_STATE_FILE
	fi
}

