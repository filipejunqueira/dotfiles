#!/bin/bash
dbus-monitor --system "type='signal',interface='org.freedesktop.login1.Manager',member='PrepareForSleep'" 2>/dev/null | \
while read -r line; do
    if echo "$line" | grep -q "boolean true"; then
        # Going to sleep - play immediately
        paplay ~/.local/share/sounds/meme-sounds/lid-close.ogg
    elif echo "$line" | grep -q "boolean false"; then
        # Waking up - wait for audio to be ready
        sleep 2
        paplay ~/.local/share/sounds/meme-sounds/lid-open.ogg
    fi
done
