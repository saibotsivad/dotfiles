#!/bin/bash

# llama.cpp-monitor.sh — ping-like monitor for llama.cpp context usage per slot

HOST="${LLAMA_HOST:-http://localhost:1234}"
BAR_WIDTH=20
INTERVAL="${INTERVAL:-1}"

# color the bar by how full the context is (green < 60 < yellow < 85 < red)
color_for() {
  local pct=$1
  if   [ "$pct" -ge 85 ]; then printf '\033[31m'   # red
  elif [ "$pct" -ge 60 ]; then printf '\033[33m'   # yellow
  else                         printf '\033[32m'   # green
  fi
}

make_bar() {
  local pct=$1
  local filled=$(( pct * BAR_WIDTH / 100 ))
  (( filled > BAR_WIDTH )) && filled=$BAR_WIDTH      # clamp if ctx overflows
  local empty=$(( BAR_WIDTH - filled ))
  local bar="" i
  for ((i=0; i<filled; i++)); do bar+="█"; done
  for ((i=0; i<empty;  i++)); do bar+="░"; done
  printf '[%b%s\033[0m] %3d%%' "$(color_for "$pct")" "$bar" "$pct"
}

# id | tokens-in-context (prompt + decoded) | n_ctx | is_processing
JQ_FILTER='
  .[] | "\(.id)|\(.n_prompt_tokens + (.next_token[0].n_decoded // 0))|\(.n_ctx)|\(.is_processing)"
'

while true; do
  if ! SLOTS=$(curl -sf "$HOST/slots"); then
    echo "$(date '+%H:%M:%S')  server unreachable ($HOST)"
    sleep "$INTERVAL"
    continue
  fi

  OUTPUT="$(date '+%H:%M:%S')"

  while IFS='|' read -r id n_used n_ctx processing; do
    n_used=${n_used//[^0-9]/}
    n_ctx=${n_ctx//[^0-9]/}
    [ -z "$n_ctx" ] || [ "$n_ctx" -eq 0 ] && continue
    pct=$(( n_used * 100 / n_ctx ))
    if [ "$processing" = "true" ]; then status="BUSY"; else status="IDLE"; fi
    OUTPUT+="  slot${id} $(make_bar "$pct") ${status} (${n_used}/${n_ctx})"
  done < <(echo "$SLOTS" | jq -r "$JQ_FILTER")

  echo "$OUTPUT"
  sleep "$INTERVAL"
done

