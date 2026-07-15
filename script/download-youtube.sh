#!/bin/bash

# Must have the following Docker image ready:
#
# FROM alpine:latest
# RUN apk -U upgrade && \
#     apk add --no-cache \
#         yt-dlp \
#         ffmpeg \
#         ca-certificates && \
#     update-ca-certificates && \
#     rm -rf /var/cache/apk/*
# RUN adduser -D appuser
# USER appuser
# WORKDIR /downloads
# ENTRYPOINT ["yt-dlp"]
#
# Build to local image `youtube-audio`

youtube_rebuild_docker_image() {
	docker rmi -f youtube-audio
	docker build -t youtube-audio - <<EOF
FROM alpine:latest
RUN apk -U upgrade && \
    apk add --no-cache \
        yt-dlp \
        ffmpeg \
        ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*
RUN adduser -D appuser
USER appuser
WORKDIR /downloads
ENTRYPOINT ["yt-dlp"]
EOF
}

youtube_download_audio() {
	VIDEO_ID=$1
	if [ -z "$VIDEO_ID" ]; then
		echo "Usage: youtube_download_audio <ID>"
		return 1
	fi
	docker run --rm \
		-v "${YOUTUBE_MUSIC_FOLDER}:/downloads" youtube-audio \
		-x \
		--audio-format mp3 \
		--embed-metadata \
		--write-thumbnail \
		--convert-thumbnails png \
		--write-info-json \
		-o "/downloads/%(id)s.%(ext)s" \
		https://www.youtube.com/watch?v=$VIDEO_ID
	TMPFILE=$(mktemp)
	jq . "${YOUTUBE_MUSIC_FOLDER}/${VIDEO_ID}.info.json" > "${TMPFILE}"
	mv "${TMPFILE}" "${YOUTUBE_MUSIC_FOLDER}/${VIDEO_ID}.info.json"
}

youtube_download_video() {
	VIDEO_ID=$1
	if [ -z "$VIDEO_ID" ]; then
		echo "Usage: youtube_download_video <ID>"
		return 1
	fi
	docker run --rm \
		-v "${YOUTUBE_VIDEO_FOLDER}:/downloads" youtube-audio \
		--write-info-json \
		--write-thumbnail \
		--convert-thumbnails png \
		-o "/downloads/%(id)s.%(ext)s" \
		https://www.youtube.com/watch?v=$VIDEO_ID
	TMPFILE=$(mktemp)
	jq . "${YOUTUBE_VIDEO_FOLDER}/${VIDEO_ID}.info.json" > "${TMPFILE}"
	mv "${TMPFILE}" "${YOUTUBE_VIDEO_FOLDER}/${VIDEO_ID}.info.json"
}

youtube_reencode_to_mp4() {
	INPUT_FILE=$1
	if [ -z "$INPUT_FILE" ]; then
		echo "Usage: reencode_to_mp4 <input_file.ext>"
		return 1
	fi
	
	if [ ! -f "$INPUT_FILE" ]; then
		echo "Error: File not found: $INPUT_FILE"
		return 1
	fi
	
	OUTPUT_FILE="${INPUT_FILE%.mkv}.mp4"
	
	docker run --rm \
		-v "$(dirname "$INPUT_FILE"):/downloads" \
		--entrypoint ffmpeg \
		youtube-audio \
		-i "/downloads/$(basename "$INPUT_FILE")" \
		-c:v libx264 \
		-c:a aac \
		-movflags +faststart \
		"/downloads/$(basename "$OUTPUT_FILE")"
	
	echo "Re-encoded to: $OUTPUT_FILE"
}

