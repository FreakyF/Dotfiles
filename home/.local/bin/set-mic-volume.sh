#!/bin/sh
# Wait for the default audio source to be ready, then set its initial volume

TARGET='@DEFAULT_AUDIO_SOURCE@' # PipeWire default audio source
VOL='0.20'                      # target volume level (0.0–1.0)

# Poll until the target source becomes available
while ! wpctl get-volume "$TARGET" >/dev/null 2>&1; do
    sleep 0.1
done

# Apply the desired volume once the source is ready
wpctl set-volume "$TARGET" "$VOL"

