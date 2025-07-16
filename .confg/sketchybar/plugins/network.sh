#!/bin/bash

interface="en0"  # change to your active interface (e.g. `en0`, `en1`, `eth0`, etc.)
prev_file="/tmp/sketchybar_net_prev"

get_bytes() {
  netstat -ib | grep "$interface" | awk '{print $7, $10}' | head -n 1
}

# Load previous values
if [ -f "$prev_file" ]; then
  read -r old_in old_out < "$prev_file"
else
  read -r old_in old_out <<< "$(get_bytes)"
  echo "$old_in $old_out" > "$prev_file"
  echo "⚡0K ⬆0K" && exit 0
fi

sleep 1

# Get new values
read -r new_in new_out <<< "$(get_bytes)"

# Calculate speeds
delta_in=$((new_in - old_in))
delta_out=$((new_out - old_out))

# Save new values
echo "$new_in $new_out" > "$prev_file"

# Format as KB/s or MB/s
format_speed() {
  local speed=$1
  if [ "$speed" -gt 1048576 ]; then
    awk "BEGIN {printf \"%.1fM\", $speed / 1048576}"
  elif [ "$speed" -gt 1024 ]; then
    awk "BEGIN {printf \"%.1fK\", $speed / 1024}"
  else
    echo "${speed}B"
  fi
}

in_speed=$(format_speed "$delta_in")
out_speed=$(format_speed "$delta_out")


sketchybar --set $NAME label="⬇ $in_speed ⬆ $out_speed"
