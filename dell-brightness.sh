#!/bin/sh

# Where the backlight brightness is stored
BR_DIR="/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/"

test -d "$BR_DIR" || exit 0

MIN=0
MAX=$(cat "$BR_DIR/max_brightness")
VAL=$(cat "$BR_DIR/brightness")

if [ "$1" = down ]; then
    VAL=$((VAL-6000))
else
    VAL=$((VAL+6000))
fi

if [ "$VAL" -lt $MIN ]; then
    VAL=$MIN
elif [ "$VAL" -gt $MAX ]; then
    VAL=$MAX
fi

PERCENT=`echo "$VAL / $MAX" | bc -l`
export XAUTHORITY=/home/user/.Xauthority  # CHANGE "user" TO YOUR USER
export DISPLAY=:0.0
export DISPLAYNAME=$(xrandr --listmonitors | awk '$1 == "0:" {print $4}')

echo "xrandr --output ${DISPLAYNAME} --brightness $PERCENT" > /tmp/xps-brightness.log
xrandr --output ${DISPLAYNAME} --brightness $PERCENT
echo $VAL > "$BR_DIR/brightness"
