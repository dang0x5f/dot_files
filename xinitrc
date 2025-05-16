#xrandr --output LVDS-1 --mode 1366x768
#xrandr --newmode "1600x1200_75.00" 204.75 1600 1720 1888 2176 1200 1203 1207 1255 -hsync +vsync
#xrandr --addmode VGA-1 1600x1200_75.00
#xrandr --output VGA-1 --primary --mode 1600x1200_75.00
xbanish &
xsetroot -cursor_name left_ptr
# picom &
nitrogen --restore &
xrdb ~/.Xresources
setxkbmap -option ctrl:nocaps 
#exec /usr/local/bin/xmonad
exec $HOME/.xmonad/xmonad-x86_64-freebsd
