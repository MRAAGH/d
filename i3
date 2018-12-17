# vim: filetype=i3
# This file has been auto-generated by i3-config-wizard(1).
# It will not be overwritten, so edit it as you like.
#
# Should you change your keyboard layout some time, delete
# this file and re-run i3-config-wizard(1).
#

# i3 config file (v4)
#
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

set $term urxvt
# set $mod Mod4
set $mod Mod1
set $sup Control
set $focusedws $(i3-msg -t get_workspaces | jq '.[] | select(.focused == true).num')

# exec --no-startup-id feh --bg-scale ~/.bg
exec --no-startup-id ~/.fehbg &

exec --no-startup-id pulseaudio

exec_always --no-startup-id setxkbmap -device 11 us_alt
exec_always --no-startup-id setxkbmap -device 12 us_alt

exec_always --no-startup-id "killall compton; compton"

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:monospace 8
# font -*-gohufont-medium-r-normal-*-14-100-100-100-*-*-iso10646-1

# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
#font pango:DejaVu Sans Mono 8

# Before i3 v4.8, we used to recommend this one as the default:
# font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
# The font above is very space-efficient, that is, it looks good, sharp and
# clear in small sizes. However, its unicode glyph coverage is limited, the old
# X core fonts rendering does not support right-to-left and this being a bitmap
# font, it doesn’t scale on retina/hidpi displays.

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start dmenu (a program launcher)
#bindsym $mod+d exec --no-startup-id dmenu_run -fn "xft:droid sans:bold:pixelsize=11:antialias=true:hinting=slight" -nb "#0f0f0f" -nf "#a6a6a6" -sb "#0f0f0f" -sf "#8f8fed"
#bindsym 0xffe4 exec --no-startup-id dmenu_run
#bindsym 0xffe4 exec --no-startup-id my-dmenu-run
#bindsym $mod+0xffe4 exec --no-startup-id my-dmenu-run-history

# just like dmenu_run, except it also appends the result to ~/.bash_history"
# bindsym $mod+0xffe4 exec --no-startup-id dmenu_path | awk '!a[$0]++' | dmenu "$@" | tee -a ~/.bash_history | ${SHELL:-"/bin/sh"} && bh-cleanup
# this one also grabs commands from ~/.bash_history, and appends the result ofc.
# bindsym 0xffe4 exec --no-startup-id dmenu_path | tac ~/.bash_history - | awk '!a[$0]++' | dmenu "$@" -l 10 | tee -a ~/.bash_history | ${SHELL:-"/bin/sh"} && bh-cleanup


# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
# bindsym $mod+d exec --no-startup-id i3-dmenu-desktop


# window colours: border background text    indicator child_border
# client.focused        #4c7899 #285577 #ffffff #2e9ef4 #285577
# client.focused_inactive    #0F0F0F #7FB256 #E5E5E5
# client.unfocused    #0F0F0F #5697B2 #E5E5E5
# client.urgent #0F0F0F #BC9B54 #E5E5E5

# bindsym 0xffe3 exec --no-startup-id :





# UNUSED KEYS:
# bindsym $mod+1
# bindsym $mod+2
# bindsym $mod+6
# bindsym $mod+backspace
# bindsym $mod+bracketleft
# bindsym $mod+bracketright
# bindsym $mod+equal
# bindsym $mod+p
# bindsym $mod+$sup+0
# bindsym $mod+$sup+1
# bindsym $mod+$sup+2
# bindsym $mod+$sup+3
# bindsym $mod+$sup+4
# bindsym $mod+$sup+5
# bindsym $mod+$sup+6
# bindsym $mod+$sup+apostrophe
# bindsym $mod+$sup+b
# bindsym $mod+$sup+backslash
# bindsym $mod+$sup+backspace
# bindsym $mod+$sup+bracketright
# bindsym $mod+$sup+equal
# bindsym $mod+$sup+escape
# bindsym $mod+$sup+p
# bindsym $mod+$sup+q
# bindsym $mod+$sup+return
# bindsym $mod+$sup+semicolon
# bindsym $mod+$sup+tab
# bindsym $mod+$sup+v
# bindsym $mod+tab



# DANGER
bindsym $mod+q kill
bindsym $mod+Shift+1 exec --no-startup-id systemctl poweroff
bindsym $mod+Shift+2 exec --no-startup-id systemctl reboot
bindsym $mod+Shift+grave exit
bindsym $mod+Shift+Delete exec --no-startup-id mv ~/music/"$(mpc current -f %file% | cut -d / -f 2)" ~/musicgraveyard/ && mpc del 0


# SPECIAL
bindsym $mod+Shift+c reload



bindsym $mod+h focus left
bindsym $mod+$sup+h move left
bindsym $mod+l focus right
bindsym $mod+$sup+l move right

bindsym $mod+u exec --no-startup-id "ws=$focusedws; i3-msg workspace $(($ws - $( if [ $(($ws % 100)) -gt 1 ]; then echo 1; else echo 0; fi)))"
bindsym $mod+$sup+u exec --no-startup-id "ws=$focusedws; i3-msg move container to workspace $(($ws - $( if [ $(($ws % 100)) -gt 1 ]; then echo 1; else echo 0; fi)))"
bindsym $mod+i exec --no-startup-id "ws=$focusedws; i3-msg workspace $(($ws + 1))"
bindsym $mod+$sup+i exec --no-startup-id "ws=$focusedws; i3-msg move container to workspace $(($ws + 1))"

bindsym $mod+j focus down
bindsym $mod+$sup+j move down
bindsym $mod+k focus up
bindsym $mod+$sup+k move up

bindsym $mod+f exec --no-startup-id "mpc next"
bindsym $mod+d exec --no-startup-id "mpc prev"
bindsym $mod+c exec --no-startup-id "mpc toggle"

#############KEY TO SWAP WORKSPACE WITH NEXT bracketleft
#############KEY TO SWAP WORKSPACE WITH PREV bracketright
#############KEY TO INSERT WORKSPACE p for page new

#############KEY TO TURN ON UNCLUTTER
#############KEY TO TURN OFF UNCLUTTER

bindsym $mod+semicolon exec --no-startup-id "$term -e bash -c \\"source ~/.bashrc; env EDITOR=vim /usr/bin/ranger\\""

bindsym $mod+Return exec --no-startup-id $term

bindsym $mod+apostrophe exec /usr/bin/firefox

bindsym $mod+Escape [instance="dropdown"] scratchpad show; [instance="dropdown"] move position center

bindsym $mod+a exec --no-startup-id amixer -q set Master 2dB+ unmute
bindsym $mod+z exec --no-startup-id amixer -q set Master 2dB- unmute

bindsym $mod+x exec --no-startup-id "i3lock -i ~/.lockbg -t -f -e"

bindsym $mod+e exec --no-startup-id "mpc seek -00:00:10"
bindsym $mod+r exec --no-startup-id "mpc seek +00:00:10"
bindsym $mod+w exec --no-startup-id "mpc seek -00:01:00"
bindsym $mod+t exec --no-startup-id "mpc seek +00:01:00"
bindsym $mod+s exec --no-startup-id "mpc seek -10%"
bindsym $mod+g exec --no-startup-id "mpc seek +10%"

bindsym $mod+$sup+bracketleft exec --no-startup-id /usr/local/bin/riot-web

bindsym $mod+$sup+d exec --no-startup-id dmenu_path | awk '!a[$0]++' | dmenu "$@" -l 10 | tee -a ~/.dmenu_history | ${SHELL:-"/bin/sh"}

bindsym $mod+$sup+t exec --no-startup-id thunderbird

bindsym $mod+backslash exec --no-startup-id ~/.bin/txth

bindsym $mod+7 exec --no-startup-id "amixer -q set PCM 0db+,0.6db-"
bindsym $mod+8 exec --no-startup-id "amixer -q set PCM 100%"
bindsym $mod+9 exec --no-startup-id "amixer -q set PCM 0.6db-,0db+"

bindsym $mod+n resize grow left 10 px or 10 ppt
bindsym $mod+$sup+n resize shrink right 10 px or 10 ppt
bindsym $mod+m resize grow down 10 px or 10 ppt
bindsym $mod+$sup+m resize shrink up 10 px or 10 ppt
bindsym $mod+comma resize grow up 10 px or 10 ppt
bindsym $mod+$sup+comma resize shrink down 10 px or 10 ppt
bindsym $mod+period resize grow right 10 px or 10 ppt
bindsym $mod+$sup+period resize shrink left 10 px or 10 ppt

bindsym $mod+0 exec --no-startup-id $term -cd ~/cd/d

bindsym $mod+2 exec --no-startup-id $term -e bash -c "source ~/.bashrc && vim ~/.bashrc"
bindsym $mod+3 exec --no-startup-id $term -e bash -c "source ~/.bashrc && vim ~/.config/i3/config"
bindsym $mod+4 exec --no-startup-id $term -e bash -c "source ~/.bashrc && vim ~/.vimrc"
bindsym $mod+5 exec --no-startup-id $term -e bash -c "source ~/.bashrc && vim ~/.config/ranger/rc.conf"

bindsym $mod+v split v
bindsym $mod+b split h

bindsym $mod+y focus output left
bindsym $mod+$sup+y move container to output left
bindsym $mod+o focus output right
bindsym $mod+$sup+o move container to output right

bindsym $mod+$sup+e exec audacity ~/music/"$(mpc | head -1 | cut -d / -f 2)"
###########################AUDACITY KEY

bindsym $mod+$sup+f fullscreen toggle

bindsym $mod+space focus mode_toggle
bindsym $mod+$sup+space floating toggle

bindsym $mod+$sup+g exec --no-startup-id gimp

bindsym $mod+$sup+x exec --no-startup-id "pulseaudio -k; sleep 0.1; pulseaudio"

bindsym $mod+$sup+slash layout toggle split
bindsym $mod+$sup+9 exec --no-startup-id "urxvt -hold -e cal -y"
bindsym $mod+$sup+r restart
bindsym $mod+$sup+a focus parent
bindsym $mod+$sup+c focus child
bindsym $mod+slash layout default
bindsym $mod+$sup+w layout tabbed
bindsym $mod+$sup+s layout stacking
bindsym $mod+$sup+7 border pixel 0
bindsym $mod+$sup+8 border normal
bindsym $mod+minus scratchpad show
bindsym $mod+$sup+minus move scratchpad
bindsym $mod+$sup+z exec --no-startup-id kazam




# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
	position bottom
        mode hide
        hidden_state hide
        # modifier Mod5
        modifier Mod4
        status_command i3status
        tray_output primary
}

# warning
bindsym Mod4+Return exec --no-startup-id $term -hold -e figlet GO AWAY


# a different caps lock
bindsym Mod4+BackSpace exec --no-startup-id xdotool key Caps_Lock


# HALT ALL THE THINGS
bindsym Mod4+Mod1+Control+Return exec --no-startup-id halt-scripts

# scrot - root
#bindsym Print exec --no-startup-id scrot -e 'mv $f ~/pict/scr'
# scrot - select window or rectangle
#bindsym --release Shift+Print exec --no-startup-id scrot -s -e 'mv $f ~/pict/scr/'
# scrot & gimp - root
#bindsym Control+Print exec --no-startup-id scrot -e 'mv $f /tmp/ && gimp /tmp/$f'
# scrot & gimp - select window or rectangle
#bindsym --release Shift+Control+Print exec --no-startup-id scrot -s -e 'mv $f /tmp/ && gimp /tmp/$f'

bindsym Print exec --no-startup-id xfce4-screenshooter

# # move workspaces between screens
# NOPE
# bindsym $mod+Shift+Left move workspace to output left
# bindsym $mod+Shift+Right move workspace to output right

# cut and uncut ethernet
bindsym $mod+KP_Subtract exec --no-startup-id sudo /sbin/ifconfig enp4s0 down
bindsym $mod+KP_Add exec --no-startup-id sudo /sbin/ifconfig enp4s0 up







# default_border pixel 0
# default_border none
hide_edge_borders both

# new i3
# for_window [tiling] border pixel 3
# old i3
for_window [workspace=__focused__] border pixel 0

#focus_wrapping no


# network manager applet is nice I guess
exec --no-startup-id nm-applet

# start some stuff
for_window [instance="dropdown"] floating enable
for_window [instance="dropdown"] move scratchpad 
#for_window [instance="dropdown"] resize set 960 700
#for_window [instance="dropdown"] move position center 
exec --no-startup-id $term -name dropdown -e bash -c "source ~/.bashrc && ncmpc"

# gimp
# for_window [window_role="gimp-toolbox"] floating disable; layout stacking; move right; resize shrink width -31px or -31 ppt
for_window [window_role="gimp-toolbox"] floating disable
for_window [window_role="gimp-dock"] floating disable; move left

# set up starting workspaces
workspace 101 output HDMI-A-0
workspace 201 output DVI-D-0
