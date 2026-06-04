#!/bin/sh

SG_DATE=$(date "+%a %b %d, %H:%M")
LN_DATE=$(TZ=Europe/London date "+%H:%M")

DISPLAY=:0 xsetroot -name "($LN_DATE)  $SG_DATE"
