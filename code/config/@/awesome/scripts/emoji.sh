#!/bin/sh

PATH=$HOME/.cargo/bin:$PATH

SELECTION=$(awesome-emoji | fzf --delimiter='<:>' --with-nth='{1}' --accept-nth='{2}')

if [ ! -z $SELECTION ]; then
  echo "$SELECTION"
  which xclip
  printf "$SELECTION" | xclip -selection clipboard
  sleep 2.1
fi
