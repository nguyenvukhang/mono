xset r rate 200 40

# exec /usr/bin/awesome

picom --frame-opacity=1.0 --backend xrender &
feh --bg-scale ~/.local/share/wall.jpg &
# exec /usr/local/bin/kopiwm
exec /usr/local/bin/dwm
