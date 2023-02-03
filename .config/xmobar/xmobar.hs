Config {
   -- Appearance
   font = "xft:FiraCode Nerd Font:size=10:antialias=true:autohinting=true:Regular"
   , bgColor =      "#282828"
   , fgColor =      "#e2cca9"
   --, borderColor =  "#282828"
   , position       = TopSize L 100 24
   --, position =     TopP 0 100,
   -- , additionalFonts = ["xft::size=10"]
   -- , alpha = 175
   -- , border =       BottomB

   -- Layout
   , sepChar =  "%"   -- Delineator between plugin names and straight text
   , alignSep = "}{"  -- Separator between left-right alignment
   , template = "%UnsafeXMonadLog% }{%volume%  <action=`pavucontrol -t 4`>%microphone%</action> %battery%  %date% %trayerpad% "

   -- General behavior
   , allDesktops = True         -- Show on all desktops
   , persistent = True          -- Enable/disable hiding (True = disabled)
   , hideOnStart = False        -- Start with window unmapped (hidden)
   , overrideRedirect = True    -- Set the Override Redirect flag (Xlib)
   , lowerOnStart = True        -- Send to bottom of window stack on start
   , commands =
        [
               -- Cpu activity monitor
          Run Cpu            [ "--template" , "<fc=#f2594b> </fc> Cpu <total>% "
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             ] 50
               -- Memory usage monitor
        , Run Memory         [ "--template" ,"<fc=#d3869b> </fc> Mem <usedratio>% "
                             , "--Low"      , "1000"        -- units: M
                             , "--High"     , "6000"        -- units: M

                             ] 50
               -- CapsLock Script
        --, Run Com "bash" ["-c", "~/.config/xmobar/capslock.sh"] "capslock" 1
               -- Volume Script
        , Run Com "bash" ["-c", "~/.config/xmobar/volume.sh"] "volume" 5
               -- Microphone Script
        , Run Com "bash" ["-c", "~/.config/xmobar/microphone.sh"] "microphone" 5
        , Run Com "bash" ["-c", "~/.config/xmobar/battery.sh"] "battery" 5
               -- date indicator
        , Run Com "bash" ["-c", "~/.config/xmobar/date.sh"] "date" 60
        , Run Com ".config/xmobar/trayer-padding-icon.sh" [] "trayerpad" 20
        , Run UnsafeXMonadLog
        ]
   -- , pickBroadest = False    -- Choose widest display (multi-monitor)
   }

-- vim: ft=haskell:foldmethod=marker:expandtab:ts=4:shiftwidth=4
