-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- TODO soru what is gears is a library 
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
      text = tostring(err) })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init("~/.config/awesome/themes/default/theme.lua")
for s = 1, screen.count() do
  gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  -- awful.layout.suit.floating,
  awful.layout.suit.tile,
  -- awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
      { "open terminal", terminal }
    }
  })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
  menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
  )



local function nextoccupied(direction)
  local screen = awful.screen.focused()
  local tag
  local tagname = screen.selected_tag.name
  repeat
    tagname = tostring(tonumber(tagname)+direction)
    tag = awful.tag.find_by_name(screen, tagname)
    if not tag then
      -- there's nothing left, so I guess not. lel
      break
    end
  until #(tag:clients()) > 0
  return tag
end

local function makeclear(tagname, direction)
  local screen = awful.screen.focused()
  local tag = awful.tag.find_by_name(screen, tagname)
  if not tag then
    tag = awful.tag.add(tagname, {
        layout = awful.layout.suit.tile,
      })
  else
    if #(tag:clients()) > 0 then
      -- need to clear out these clients
      -- make the next tag clear
      local nexttagname = tostring(tonumber(tagname)+direction)
      local nexttag = makeclear(nexttagname, direction)
      -- alright now that the next tag is clear,
      -- just swap the names of the two tags, lol
      -- (yes this actually works)
      nexttag.name = "TEMP"
      tag.name = nexttagname
      nexttag.name = tagname
      tag = nexttag
    end
  end
  return tag
end

local function insert(direction)
  local screen = awful.screen.focused()
  local tagname = screen.selected_tag.name
  local tag = awful.tag.find_by_name(screen, tagname)
  if #(tag:clients()) == 0 then
    return tag
  end
  local nexttagname = tostring(tonumber(tagname)+direction)
  local nexttag = makeclear(nexttagname, direction)
  return nexttag
end



local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        {raise = true}
        )
    end
  end),
  awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
  end))

  local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
      -- If wallpaper is a function, call it with the screen
      if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
      end
      gears.wallpaper.maximized(wallpaper, s, true)
    end
  end

  -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
  screen.connect_signal("property::geometry", set_wallpaper)

  awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
      awful.button({ }, 5, function () awful.layout.inc(-1) end)))
      -- Create a taglist widget
      s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
      }

      -- Create a tasklist widget
      s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
      }

      -- Create the wibox
      s.mywibox = awful.wibar({ position = "top", screen = s })
      s.mywibox.visible = false

      -- Add widgets to the wibox
      s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
          layout = wibox.layout.fixed.horizontal,
          mylauncher,
          s.mytaglist,
          s.mypromptbox,
        },
        -- nil,
        s.mytasklist, -- Middle widget
        { -- Right widgets
          layout = wibox.layout.fixed.horizontal,
          -- mykeyboardlayout,
          wibox.widget.systray(),
          mytextclock,
          s.mylayoutbox,
        },
      }
    end)
    -- }}}

    -- {{{ Mouse bindings
    root.buttons(gears.table.join(
        awful.button({ }, 3, function () mymainmenu:toggle() end),
        awful.button({ }, 4, awful.tag.viewnext),
        awful.button({ }, 5, awful.tag.viewprev)
      ))
    -- }}}

    -- {{{ Key bindings
    globalkeys = gears.table.join(

      -- DANGER

      awful.key({ modkey, "Shift" }, "1",
        function () awful.spawn("systemctl poweroff", false) end),

      awful.key({ modkey, "Shift" }, "2",
        function () awful.spawn("systemctl reboot", false) end),

      awful.key({ modkey, "Shift" }, "3", function ()
        awful.spawn.with_shell("i3lock -i ~/.lockbg.png -t -f -e && systemctl suspend", false)
      end),

      awful.key({ modkey, "Control" }, "s",      hotkeys_popup.show_help,
        {description="show help", group="awesome"}),

      awful.key({ modkey }, "i", function()
        local nexttag = nextoccupied(1)
        if nexttag then
          awful.tag.viewmore({nexttag})
        end
      end,
      {description = "focus next occupied tag", group = "tag"}),

      awful.key({ modkey }, "u", function()
        local nexttag = nextoccupied(-1)
        if nexttag then
          awful.tag.viewmore({nexttag})
        end
      end,
      {description = "focus prev occupied tag", group = "tag"}),

      awful.key({ modkey }, "o", function()
        local nexttag = insert(1)
        awful.tag.viewmore({nexttag})
      end,
      {description = "focus next empty tag", group = "tag"}),

      awful.key({ modkey }, "y", function()
        local nexttag = insert(-1)
        awful.tag.viewmore({nexttag})
      end,
      {description = "focus prev empty tag", group = "tag"}),

      awful.key({ modkey, }, "l",      function () awful.screen.focus(awful.screen.focused().index+1) end,
        {description = "move to screen", group = "client"}),

      awful.key({ modkey, }, "h",      function ()
        if awful.screen.focused().index > 1 then
          awful.screen.focus(awful.screen.focused().index-1)
        end
      end,
        {description = "move to screen", group = "client"}),

      -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
      --   {description = "go back", group = "tag"}),

      awful.key({ modkey,           }, "j",
        function ()
          awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
        ),
      awful.key({ modkey,           }, "k",
        function ()
          awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
        ),

      awful.key({ modkey, }, "f",
        function () awful.spawn("mpc next", false) end),
      awful.key({ modkey, }, "d",
        function () awful.spawn("mpc prev", false) end),
      awful.key({ modkey, }, "s",
        function () awful.spawn("mpc toggle", false) end),

        -- TODO key to turn on unclutter
        -- TODO key to turn off unclutter

      awful.key({ modkey, }, "semicolon",
        function () awful.spawn(terminal.." -e bash -c \"source ~/.bashrc; env EDITOR=vim /usr/bin/ranger\"", false) end),

      awful.key({ modkey, }, "apostrophe",
        function () awful.spawn("waterfox") end),

      awful.key({ modkey, "Control" }, "w",
        function () awful.spawn(terminal.." -e bash -c \"source ~/.bashrc; env EDITOR=vim nmtui-connect\"", false) end),

      awful.key({ modkey, }, "r",
        function () awful.spawn("amixer -c 0 -q set Master 2dB+ unmute", false) end),
      awful.key({ modkey, }, "e",
        function () awful.spawn("amixer -c 0 -q set Master 2dB- unmute", false) end),

      awful.key({ modkey, }, "p",
        function () awful.spawn("passmenu -l 15 -i -fn 'monospace:size=16'", false) end),

      awful.key({ modkey, "Control" }, "x",
        function () awful.spawn.with_shell("i3lock -i ~/.lockbg.png -t -f -e", false) end),

      awful.key({ modkey, }, "Escape",
        function () awful.spawn("mpc seek -10", false) end),
      awful.key({ modkey, }, "z",
        function () awful.spawn("mpc seek +10", false) end),
      awful.key({ modkey, "Control" }, "Escape",
        function () awful.spawn("mpc seek -60", false) end),
      awful.key({ modkey, "Control" }, "z",
        function () awful.spawn("mpc seek +60", false) end),
      awful.key({ modkey, "Control", "Shift" }, "Escape",
        function () awful.spawn("mpc seek -10%", false) end),
      awful.key({ modkey, "Control", "Shift" }, "z",
        function () awful.spawn("mpc seek +10%", false) end),

      awful.key({ modkey, "Control" }, "bracketleft",
        function () awful.spawn("riot-desktop") end),

      awful.key({ modkey, "Control" }, "t",
        function () awful.spawn("thunderbird") end),

      awful.key({ modkey, }, "backslash",
        function () awful.spawn("txth", false) end),

      awful.key({ modkey, }, "7",
        function () awful.spawn("amixer -c 0 -q set PCM 0db+,0.6db-", false) end),
      awful.key({ modkey, }, "8",
        function () awful.spawn("amixer -c 0 -q set PCM 100%", false) end),
      awful.key({ modkey, }, "9",
        function () awful.spawn("amixer -c 0 -q set PCM 0.6db-,0db+", false) end),

      awful.key({ modkey, "Control" }, "0",
        function () awful.spawn("mpc seek 0", false) end),
      awful.key({ modkey, "Control" }, "9",
        function () awful.spawn("bash -c \"mpc seek $(shuf -i 0-99 -n 1).$(shuf -i 0-99 -n 1)%\"", false) end),

      awful.key({ modkey,  }, "c",
        function () awful.spawn("cura") end),

      awful.key({ modkey,  }, "0",
        -- TODO use ~
        function () awful.spawn(terminal.." -cd /home/maze/cd/d", false) end),

      awful.key({ modkey,  }, "1",
        function () awful.spawn(terminal.." -cd /usr/share/X11/xkb/symbols", false) end),

      awful.key({ modkey,  }, "2",
        function () awful.spawn(terminal.." -e bash -c \"source ~/.bashrc && vim ~/.config/awesome/rc.lua\"", false) end), 
      awful.key({ modkey,  }, "3",
        function () awful.spawn(terminal.." -e bash -c \"source ~/.bashrc && vim ~/.config/i3/config\"", false) end), 
      awful.key({ modkey,  }, "4",
        function () awful.spawn(terminal.." -e bash -c \"source ~/.bashrc && vim ~/.vimrc\"", false) end), 
      awful.key({ modkey,  }, "5",
        function () awful.spawn(terminal.." -e bash -c \"source ~/.bashrc && vim ~/.config/ranger/rc.conf\"", false) end), 

      awful.key({ modkey, "Control" }, "g",
        function () awful.spawn("gimp") end),






































































































































































































































































































































































































































        -- this was the meh menu that spawns on the mouse, eww
      -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
      --   {description = "show main menu", group = "awesome"}),

      -- Layout manipulation
      -- TODO ctrl instead of shift
      awful.key({ modkey, "Control"   }, "j", function () awful.client.swap.byidx(  1)    end,
        {description = "swap with next client by index", group = "client"}),
      awful.key({ modkey, "Control"   }, "k", function () awful.client.swap.byidx( -1)    end,
        {description = "swap with previous client by index", group = "client"}),
      -- TODO change screen switching to something else as ctrl will be taken
      -- TODO ok I changed shift to ctrl above, but here it needs to be shift then
      -- TODO but if screen switch is on j and k, how do you send windows to other screen? doesn't fit! It has to be something else and without modifier, so that sending windows can be with ctrl and that.
      -- TODO same as previous comment applies to switching workspaces. Which definitely shouldn't be on arrows btw.
      -- TODO o is for moving window to screen in 1 direction, need another key for other direction
      awful.key({ modkey, "Shift" }, "j", function () awful.screen.focus_relative( 1) end,
        {description = "focus the next screen", group = "screen"}),
      awful.key({ modkey, "Shift" }, "k", function () awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}),
      -- TODO maybe remove this to free up U for workspace switching
      -- awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
      -- {description = "jump to urgent client", group = "client"}),
      awful.key({ modkey,           }, "Tab",
        function ()
          awful.client.focus.history.previous()
          if client.focus then
            client.focus:raise()
          end
        end,
        {description = "go back", group = "client"}),

      -- Standard program
      awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
        {description = "open a terminal", group = "launcher"}),
      -- TODO don't change restart button because this is important. same for quit
      awful.key({ modkey, "Control" }, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}),
      awful.key({ modkey, "Shift"   }, "q", awesome.quit,
        {description = "quit awesome", group = "awesome"}),

      -- -- TODO resize is perhaps not important enough to be on h and l
      -- awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
      --   {description = "increase master width factor", group = "layout"}),
      -- awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
      --   {description = "decrease master width factor", group = "layout"}),
      -- -- TODO I guess this is important enough so maybe keep defaults? idk
      -- -- TODO soru doesn't use
      -- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
      --   {description = "increase the number of master clients", group = "layout"}),
      -- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
      --   {description = "decrease the number of master clients", group = "layout"}),
      -- -- TODO alright so with shift it's changing master count, with ctrl it's changing column count. really. omg. this is so confusing. why. gah guess I'll keep it for now
      -- -- TODO soru doesn't use
      -- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
      --   {description = "increase the number of columns", group = "layout"}),
      -- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
      --   {description = "decrease the number of columns", group = "layout"}),
      -- -- TODO as there's a fixed number of possible layouts, absolute navigation would maybe be better in this case. Not sure though. Anyway space is a strange key to bind this to.
      awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
        {description = "select next", group = "layout"}),
      awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
        {description = "select previous", group = "layout"}),

      -- TODO why is there minimizing in a tiled wm, what an abomination. Consider removing this functionality
      awful.key({ modkey, "Control" }, "n",
        function ()
          local c = awful.client.restore()
          -- Focus restored client
          if c then
            c:emit_signal(
              "request::activate", "key.unminimize", {raise = true}
              )
          end
        end,
        {description = "restore minimized", group = "client"}),

      -- Prompt
      -- TODO if I want to keep my volume keys, this has to go. To mod ctrl D probably.
      awful.key({ modkey, "Control" },            "d",     function () awful.screen.focused().mypromptbox:run() end,
        {description = "run prompt", group = "launcher"}),

      -- TODO my lock screen was here. although gotta admit this is not the best spot for lock screen because it can be hit accidentally. soru doesn't use
      awful.key({ modkey }, "x",
        function ()
          awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
          }
        end,
        {description = "lua execute prompt", group = "awesome"}),
      -- Menubar
      -- soru doesn't use this menu. I won't use it either
      -- awful.key({ modkey }, "p", function() menubar.show() end,
      --   {description = "show the menubar", group = "launcher"}),

      awful.key({ }, "Print",
        function () awful.spawn("dmenu-scrot ~/pict/scr/", false) end,
        {description = "dmenu-scrot", group = "launcher"})

      )

    -- TODO soru why are two separate lists of keys and which one should I add to??
    -- this list is for modifying clients. The previous one is for awesome itself.
    clientkeys = gears.table.join(
      -- TODO has to become mod ctrl f if I wanna put music keys here
      awful.key({ modkey, "Control" }, "f",
        function (c)
          c.fullscreen = not c.fullscreen
          c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

      -- awful.key({ modkey, "Control" }, "i", function (c)
      --   local s = awful.screen.focused()
      --   local tagname = c.first_tag.name
      --   local nexttagname = tostring(tonumber(tagname)+1)
      --   local nexttag = awful.tag.find_by_name(s, nexttagname)
      --   if not nexttag then
      --     nexttag = awful.tag.add(nexttagname)
      --   end
      --   c:move_to_tag(nexttag)
      -- end,
      -- {description = "move to next", group = "tag"}),

      awful.key({ modkey, "Control" }, "i", function(c)
        local nexttag = nextoccupied(1)
        if nexttag then
          c:move_to_tag(nexttag)
        end
      end,
      {description = "move to next occupied tag", group = "tag"}),

      awful.key({ modkey, "Control" }, "u", function(c)
        local nexttag = nextoccupied(-1)
        if nexttag then
          c:move_to_tag(nexttag)
        end
      end,
      {description = "move to prev occupied tag", group = "tag"}),

      awful.key({ modkey, "Control" }, "o", function(c)
        local nexttag = insert(1)
        c:move_to_tag(nexttag)
      end,
      {description = "move to next empty tag", group = "tag"}),

    awful.key({ modkey, "Control" }, "y", function(c)
      local nexttag = insert(-1)
      c:move_to_tag(nexttag)
    end,
    {description = "move to prev empty tag", group = "tag"}),

    awful.key({ modkey, "Control" }, "l",      function (c) c:move_to_screen(c.screen.index+1)               end,
      {description = "move to screen", group = "client"}),

    awful.key({ modkey, "Control" }, "h",      function (c) c:move_to_screen(c.screen.index-1)               end,
      {description = "move to screen", group = "client"}),

    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
      {description = "close", group = "client"}),
    -- TODO I guess you might want this sometimes??? is same as on i3 so yay?
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
      {description = "toggle floating", group = "client"}),
    -- TODO what a strange functionality, and what a strange key for it soru doesn't use
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
      {description = "move to master", group = "client"}),
    -- TODO ask soru what this does move to next screen
    -- awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    --   {description = "move to screen", group = "client"}),
    -- TODO ask soru what this does display on top of floating windows
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
      {description = "toggle keep on top", group = "client"}),
    -- TODO still can't think of why I'd minimize windows
    awful.key({ modkey,           }, "n",
      function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
      end ,
      {description = "minimize", group = "client"}),
    -- TODO why would I ever maximize instead of fullscreen, what is difference if you are not using the statusbar, windowbar and borders? look at statusbar and see what all it adds
    awful.key({ modkey,           }, "m",
      function (c)
        c.maximized = not c.maximized
        c:raise()
      end ,
      {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
      function (c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
      end ,
      {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
      function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
      end ,
      {description = "(un)maximize horizontally", group = "client"})    )

  -- -- Bind all key numbers to tags.
  -- -- Be careful: we use keycodes to make it work on any keyboard layout.
  -- -- This should map on the top row of your keyboard, usually 1 to 9.
  -- for i = 1, 9 do
  --   globalkeys = gears.table.join(globalkeys,
  --     -- View tag only.
  --     awful.key({ modkey }, "#" .. i + 9,
  --       function ()
  --         local screen = awful.screen.focused()
  --         local tag = screen.tags[i]
  --         if tag then
  --           tag:view_only()
  --         end
  --       end,
  --       {description = "view tag #"..i, group = "tag"}),
  --     -- Toggle tag display.
  --     awful.key({ modkey, "Control" }, "#" .. i + 9,
  --       function ()
  --         local screen = awful.screen.focused()
  --         local tag = screen.tags[i]
  --         if tag then
  --           awful.tag.viewtoggle(tag)
  --         end
  --       end,
  --       {description = "toggle tag #" .. i, group = "tag"}),
  --     -- Move client to tag.
  --     awful.key({ modkey, "Shift" }, "#" .. i + 9,
  --       function ()
  --         if client.focus then
  --           local tag = client.focus.screen.tags[i]
  --           if tag then
  --             client.focus:move_to_tag(tag)
  --           end
  --         end
  --       end,
  --       {description = "move focused client to tag #"..i, group = "tag"}),
  --     -- Toggle tag on focused client.
  --     awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
  --       function ()
  --         if client.focus then
  --           local tag = client.focus.screen.tags[i]
  --           if tag then
  --             client.focus:toggle_tag(tag)
  --           end
  --         end
  --       end,
  --       {description = "toggle focused client on tag #" .. i, group = "tag"})
  --     )
  -- end

  clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.resize(c)
    end)
    )

  -- Set keys
  root.keys(globalkeys)
  -- }}}

  -- {{{ Rules
  -- Rules to apply to new clients (through the "manage" signal).
  awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        -- do not match to perfect character size:
        size_hints_honor = false
      }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
        "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
        -- I changed this to false
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
  }
  -- }}}

  -- {{{ Signals
  -- Signal function to execute when a new client appears.
  client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end
  end)

  -- Add a titlebar if titlebars_enabled is set to true in the rules.
  client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
      awful.button({ }, 1, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.move(c)
      end),
      awful.button({ }, 3, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.resize(c)
      end)
      )

    awful.titlebar(c) : setup {
      { -- Left
        awful.titlebar.widget.iconwidget(c),
        buttons = buttons,
        layout  = wibox.layout.fixed.horizontal
      },
      { -- Middle
        { -- Title
          align  = "center",
          widget = awful.titlebar.widget.titlewidget(c)
        },
        buttons = buttons,
        layout  = wibox.layout.flex.horizontal
      },
      { -- Right
        awful.titlebar.widget.floatingbutton (c),
        awful.titlebar.widget.maximizedbutton(c),
        awful.titlebar.widget.stickybutton   (c),
        awful.titlebar.widget.ontopbutton    (c),
        awful.titlebar.widget.closebutton    (c),
        layout = wibox.layout.fixed.horizontal()
      },
      layout = wibox.layout.align.horizontal
    }
  end)

  -- Enable sloppy focus, so that focus follows mouse.
  -- client.connect_signal("mouse::enter", function(c)
  --     c:emit_signal("request::activate", "mouse_enter", {raise = false})
  -- end)

  client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
  client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
  -- }}}
