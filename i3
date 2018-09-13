# This file has been auto-generated by i3-config-wizard(1).
# It will not be overwritten, so edit it as you like.
#
# Should you change your keyboard layout some time, delete
# this file and re-run i3-config-wizard(1).
#

# exec --no-startup-id feh --bg-scale ~/.bg

# i3 config file (v4)
#
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

set $term urxvt
set $mod Mod4
exec --no-startup-id feh --bg-scale ~/.bg

exec --no-startup-id pulseaudio

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

# start a terminal
bindsym $mod+Return exec --no-startup-id $term

# kill focused window
bindsym $mod+Shift+q kill

# start dmenu (a program launcher)
#bindsym $mod+d exec --no-startup-id dmenu_run -fn "xft:droid sans:bold:pixelsize=11:antialias=true:hinting=slight" -nb "#0f0f0f" -nf "#a6a6a6" -sb "#0f0f0f" -sf "#8f8fed"
#bindsym 0xffe4 exec --no-startup-id dmenu_run
#bindsym 0xffe4 exec --no-startup-id my-dmenu-run
#bindsym $mod+0xffe4 exec --no-startup-id my-dmenu-run-history

# just like dmenu_run, except it also appends the result to ~/.bash_history"
bindsym $mod+0xffe4 exec --no-startup-id dmenu_path | awk '!a[$0]++' | dmenu "$@" | tee -a ~/.bash_history | ${SHELL:-"/bin/sh"} && bh-cleanup
# this one also grabs commands from ~/.bash_history, and appends the result ofc.
bindsym 0xffe4 exec --no-startup-id dmenu_path | tac ~/.bash_history - | awk '!a[$0]++' | dmenu "$@" -l 10 | tee -a ~/.bash_history | ${SHELL:-"/bin/sh"} && bh-cleanup


# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
# bindsym $mod+d exec --no-startup-id i3-dmenu-desktop


# window colours: border background text    indicator child_border
# client.focused        #4c7899 #285577 #ffffff #2e9ef4 #285577
# client.focused_inactive    #0F0F0F #7FB256 #E5E5E5
# client.unfocused    #0F0F0F #5697B2 #E5E5E5
# client.urgent #0F0F0F #BC9B54 #E5E5E5



# bindsym $mod+Shift+n workspace "i" output HDMI1



# change focus
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right
#bindsym $mod+j focus left
#bindsym $mod+k focus right
#bindsym $mod+l focus up
#bindsym $mod+semicolon focus down

# alternatively, you can use the cursor keys:
#bindsym $mod+Left focus left
#bindsym $mod+Down focus down
#bindsym $mod+Up focus up
#bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# alternatively, you can use the cursor keys:
#bindsym $mod+Shift+Left move left
#bindsym $mod+Shift+Down move down
#bindsym $mod+Shift+Up move up
#bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+n split h

# split in vertical orientation
#bindsym $mod+v split v
bindsym $mod+semicolon split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
# bindsym $mod+e layout toggle split
bindsym $mod+e layout default

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child
bindsym $mod+c focus child

# switch to workspace
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9
bindsym $mod+0 workspace 10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+8 move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9
bindsym $mod+Shift+0 move container to workspace 10


# TODO: make screen switching relative without wrapping.
# With wrapping would be "focus output right"
# y - left screen
bindsym $mod+y focus output DisplayPort-0
# Y - move container to left screen
bindsym $mod+Shift+y move container to output DisplayPort-0

# o - right screen
bindsym $mod+o focus output DVI-D-0
# O - move container to right screen
bindsym $mod+Shift+o move container to output DVI-D-0

# u - one workspace back
bindsym $mod+u exec --no-startup-id "i3-msg workspace $(($(i3-msg -t get_workspaces | jq '.[] | select(.focused == true).num') - $( if [ $(( $(i3-msg -t get_workspaces | jq '.[] | select(.focused == true).num') % 100)) -eq 1 ]; then echo 0; else echo 1; fi)))"
# U - move container one workspace back
bindsym $mod+Shift+u exec --no-startup-id "i3-msg move container to workspace $(($(i3-msg -t get_workspaces | jq '.[] | select(.focused == true).num') - $( if [ $(( $(i3-msg -t get_workspaces | jq '.[] | select(.focused == true).num') % 100)) -eq 1 ]; then echo 0; else echo 1; fi)))"

# i - one workspace forward
bindsym $mod+i exec --no-startup-id "i3-msg workspace $(($(i3-msg -t get_workspaces | jq '.[] | select(.focused == true).num') + 1))"
# I - move container one workspace forward
bindsym $mod+Shift+i exec --no-startup-id "i3-msg move container to workspace $(($(i3-msg -t get_workspaces | jq '.[] | select(.focused == true).num') + 1))"

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+grave exit 


# resizing, mod4+shift+control
bindsym $mod+Shift+Control+h resize shrink width 10 px or 10 ppt
bindsym $mod+Shift+Control+j resize grow height 10 px or 10 ppt
bindsym $mod+Shift+Control+k resize shrink height 10 px or 10 ppt
bindsym $mod+Shift+Control+l resize grow width 10 px or 10 ppt


# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
	position bottom
        mode hide
        hidden_state hide
        modifier $mod
        status_command i3status
        tray_output primary
}


# music commands
bindsym $mod+Control+k exec --no-startup-id "mpc prev"
bindsym $mod+Control+j exec --no-startup-id "mpc next"
bindsym $mod+Control+h exec --no-startup-id "mpc seek -10%"
bindsym $mod+Control+l exec --no-startup-id "mpc seek +10%"
bindsym $mod+Control+u exec --no-startup-id "mpc seek -00:01:00"
bindsym $mod+Control+p exec --no-startup-id "mpc seek +00:01:00"
bindsym $mod+Control+i exec --no-startup-id "mpc seek -00:00:10"
bindsym $mod+Control+o exec --no-startup-id "mpc seek +00:00:10"
bindsym $mod+Control+comma exec --no-startup-id "mpc toggle"
bindsym $mod+Control+period exec --no-startup-id "mpc stop"
bindsym $mod+Control+Delete exec --no-startup-id "mpc del 0"
bindsym $mod+Control+slash exec --no-startup-id "mpc single off"
bindsym $mod+Control+m exec --no-startup-id "mpc single on"
#bindsym $mod+Control+equal exec --no-startup-id amixer -q set Master 4%+ unmute
bindsym $mod+Control+equal exec --no-startup-id amixer -q set Master 2dB+ unmute
bindsym $mod+Control+minus exec --no-startup-id amixer -q set Master 2dB- unmute

# open music player in terminal
#bindsym $mod+Control+apostrophe exec --no-startup-id $term -e ncmpc
#bindsym $mod+apostrophe exec --no-startup-id i3-msg 'workspace 10; exec --no-startup-id gnome-terminal -e mp'


# TODO: something else than mod5+backspace pls
# a different caps lock
bindsym Mod5+BackSpace exec --no-startup-id xdotool key Caps_Lock


# HALT ALL THE THINGS
bindsym $mod+Mod1+Control+Return exec --no-startup-id halt-scripts

# lock screen
# bindsym $mod+o exec --no-startup-id "i3lock -c 101820 -u"
bindsym $mod+x exec --no-startup-id "i3lock -i ~/.lockbg -t -f -e"


# scrot - root
#bindsym Print exec --no-startup-id scrot -e 'mv $f ~/pict/scr'
# scrot - select window or rectangle
#bindsym --release Shift+Print exec --no-startup-id scrot -s -e 'mv $f ~/pict/scr/'
# scrot & gimp - root
#bindsym Control+Print exec --no-startup-id scrot -e 'mv $f /tmp/ && gimp /tmp/$f'
# scrot & gimp - select window or rectangle
#bindsym --release Shift+Control+Print exec --no-startup-id scrot -s -e 'mv $f /tmp/ && gimp /tmp/$f'

bindsym Print exec --no-startup-id xfce4-screenshooter

# move workspaces between screens
bindsym $mod+Shift+Left move workspace to output left
bindsym $mod+Shift+Right move workspace to output right

# cut and uncut ethernet
bindsym Control+KP_Subtract exec --no-startup-id sudo /sbin/ifconfig enp4s0 down
bindsym Control+KP_Add exec --no-startup-id sudo /sbin/ifconfig enp4s0 up

# txt with key bindings
bindsym $mod+bracketright exec --no-startup-id ~/.bin/txth

# firefox with keybindings
bindsym $mod+backslash exec --no-startup-id /usr/bin/firefox

# ranger with keybindings
bindsym $mod+apostrophe exec --no-startup-id $term -e env EDITOR=vim /usr/bin/ranger


# riot with keybind
bindsym $mod+bracketleft exec --no-startup-id /usr/local/bin/riot-web

# SCRATCHPAD ^.^
# Make the currently focused window a scratchpad
bindsym $mod+Shift+minus move scratchpad
# Show the first scratchpad window
bindsym $mod+minus scratchpad show










# default_border pixel 0
# default_border none
hide_edge_borders both

bindsym $mod+Shift+Control+7 border pixel 3
bindsym $mod+Shift+Control+8 border normal
# new i3
# for_window [tiling] border pixel 3
# old i3
for_window [workspace=__focused__] border pixel 3

#focus_wrapping no


# network manager applet is nice I guess
exec --no-startup-id nm-applet

# start some stuff
for_window [instance="dropdown"] floating enable
for_window [instance="dropdown"] move scratchpad 
#for_window [instance="dropdown"] resize set 960 700
#for_window [instance="dropdown"] move position center 
exec --no-startup-id $term -name dropdown -e ncmpc


# set up starting workspaces
workspace 101 output DVI-D-0
