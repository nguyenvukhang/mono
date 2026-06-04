#!/bin/bash

PATH=$HOME/.cargo/bin:$PATH

SELECTION=$(awesome-pdf \
  /home/khang/uni \
  /home/khang/repos/pdfs \
  /home/khang/repos/tex \
  /home/khang/repos/hire \
  /home/khang/repos/Algebra.tex \
  /home/khang/Downloads \
  -- |
  fzf --delimiter=: --with-nth='{1}' --accept-nth='{2}')

if [ ! -z "$SELECTION" ]; then
  nohup zathura "$SELECTION" >/dev/null 2>&1 &
  sleep 0
fi
