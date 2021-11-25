xmodmap -e "keycode 107 = Menu"
xmodmap -e "clear lock"
xmodmap -e "clear control"
xmodmap -e "keycode 66 = Control_L"
xmodmap -e "add control = Control_L Control_R"

redshift -l 45.74846:4.84671&

wal -R #base16-gruvbox-hard.json
feh --no-fehbg --bg-scale ~/.i3/wallpaper.png
xset dpms 200

while true; do
  i3 -c ~/.i3/i3.cfg > /tmp/.i3.log 2>&1
done
