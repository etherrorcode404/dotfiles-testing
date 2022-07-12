------------------------------------------------------------------------
-- Base                                                              {{{
------------------------------------------------------------------------
import XMonad
import XMonad.Layout
import System.Directory
import System.IO 
import System.Exit 
import qualified XMonad.StackSet as W

---------------------------------------------------------------------}}}
-- Actions                                                           {{{
------------------------------------------------------------------------
import XMonad.Actions.CopyWindow
import XMonad.Actions.PerLayoutKeys
import XMonad.Actions.Navigation2D as Nav2d
import XMonad.Actions.CopyWindow 
import XMonad.Actions.CycleWS 
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves 
import XMonad.Actions.WindowGo 
import XMonad.Actions.WithAll 
import qualified XMonad.Actions.Search as S
--import XMonad.Actions.MessageFeedback

---------------------------------------------------------------------}}}
-- Data                                                              {{{
------------------------------------------------------------------------
import Data.Foldable
import Data.Char 
import Data.Maybe 
import Data.Monoid
import Control.Monad
import Data.Maybe 
import Data.Tree
import qualified Data.Map as M
--import Data.Ratio

---------------------------------------------------------------------}}}
-- Hooks                                                             {{{
------------------------------------------------------------------------
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

---------------------------------------------------------------------}}}
-- Layouts                                                           {{{
------------------------------------------------------------------------
import XMonad.Layout.SubLayouts
import XMonad.Layout.Fullscreen
import XMonad.Layout.Master
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

---------------------------------------------------------------------}}}
-- Layouts Modifier                                                  {{{
------------------------------------------------------------------------
import XMonad.Layout.MultiToggle as MT
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.ToggleLayouts as T
import XMonad.Layout.Gaps
import XMonad.Layout.Reflect
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows 
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger 
import XMonad.Layout.WindowNavigation

---------------------------------------------------------------------}}}
-- Utilities                                                         {{{
------------------------------------------------------------------------
import qualified XMonad.Util.Hacks as Hacks
import XMonad.Util.Loggers
import XMonad.Util.NamedWindows
import XMonad.Util.Run
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run 
import XMonad.Util.SpawnOnce

---------------------------------------------------------------------}}}
-- Prompt                                                            {{{
------------------------------------------------------------------------
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt

---------------------------------------------------------------------}}}
-- ColorScheme                                                       {{{
------------------------------------------------------------------------
import Colors.GruvboxDark

---------------------------------------------------------------------}}}
-- Theme                                                             {{{
------------------------------------------------------------------------
-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myTabFont
                 , activeColor         = "#f28534"
                 , inactiveColor       = color01
                 , activeBorderColor   = "#f28534"
                 , inactiveBorderColor = color01
                 , activeTextColor     = color01
                 , inactiveTextColor   = color16
                 , decoHeight          = 18
                 }

myTopBarTheme = def { fontName              = myFont
                    , inactiveBorderColor   = color01
                    , inactiveColor         = color01
                    , inactiveTextColor     = color01
                    , activeBorderColor     = "#f28534"
                    , activeColor           = "#f28534"
                    , activeTextColor       = "#f28534"
                    , urgentBorderColor     = color02
                    , urgentTextColor       = color02
                    , decoHeight            = 8
                    }

myPromptTheme = def { font                  = myFont
                    , bgColor               = color01
                    , fgColor               = color16
                    , fgHLight              = color16
                    , bgHLight              = color04
                    , borderColor           = color01
                    , promptBorderWidth     = myBorderWidth
                    , height                = myPromptWidth
                    , position              = myPromptPosition
                    }

warmPromptTheme = myPromptTheme { bgColor               = color03
                                , fgColor               = color16
                                , position              = myPromptPosition
                                }

hotPromptTheme = myPromptTheme  { bgColor               = color02
                                , fgColor               = color01
                                , position              = myPromptPosition
                                }

myFont = "xft:monospace:regular:size=10:antialias=true:hinting=true"
myTabFont = "xft:monospace:regular:size=8:antialias=true:hinting=true"
myBorderWidth = 2          -- Sets border width for windows
myPromptWidth = 20
myPromptPosition = Top
myNormColor  = color01    -- This variable is imported from Colors.THEME
myFocusColor = "#f28534"    -- This variable is imported from Colors.THEME

---------------------------------------------------------------------}}}
-- Applications                                                      {{{
------------------------------------------------------------------------
myTerminal = "alacritty"    -- Sets default terminal
myBrowser = "google-chrome-stable"  -- Sets qutebrowser as browser
myEmacs = "emacsclient -c -a 'emacs' "  -- Makes emacs keybindings easier to type
myModMask = mod4Mask        -- Sets modkey to super/windows key
myEditor = myTerminal ++ " -e nvim "    -- Sets nvim as editor

---------------------------------------------------------------------}}}
-- Startup                                                           {{{
------------------------------------------------------------------------

myStartupHook :: X ()
myStartupHook = do
    spawn "xsetroot -cursor_name left_ptr"
    spawn "killall trayer"
    spawn "sleep 2 && trayer --edge top --align right --widthtype request --SetDockType true --SetPartialStrut true --expand true  --transparent false  --tint 0x1d2021 --alpha 0 --height 21 --padding 3 --iconspacing 3"
    spawn "conky"
    spawn "picom"
    spawn "feh --bg-fill ~/Downloads/Gruv-street.jpeg"  
    spawnOnce "numlockx"
    spawnOnce "nm-applet"
    setWMName "LG3D"

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myAppGrid = [ ("Audacity", "audacity")
                 , ("Deadbeef", "deadbeef")
                 , ("Emacs", "emacsclient -c -a emacs")
                 , ("Firefox", "firefox")
                 , ("Geany", "geany")
                 , ("Geary", "geary")
                 , ("Gimp", "gimp")
                 , ("Kdenlive", "kdenlive")
                 , ("LibreOffice Impress", "loimpress")
                 , ("LibreOffice Writer", "lowriter")
                 , ("OBS", "obs")
                 , ("PCManFM", "pcmanfm")
                 ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                , NS "calculator" spawnCalc findCalc manageCalc
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -t mocp -e mocp"
    findMocp   = title =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.

myNav2DConf = def
    { defaultTiledNavigation    = sideNavigation
    , floatNavigation           = centerNavigation
    , screenNavigation          = lineNavigation
    , layoutNavigation          = [("Full", centerNavigation), ("ReflectX Full", centerNavigation)]
    , unmappedWindowRect        = [("Full", singleWindowRect), ("ReflectX Full", singleWindowRect)]
    }

---------------------------------------------------------------------}}}
-- Main                                                              {{{
------------------------------------------------------------------------
main :: IO ()
main = do
    xmonad
      $ Hacks.javaHack
      $ ewmh
      $ withUrgencyHook NoUrgencyHook
      $ docks
      $ withNavigation2DConfig myNav2DConf
      $ withSB (statusBarProp "xmobar ~/.config/xmobar/xmobar.hs" (copiesPP (xmobarColor colorFore color01 . wrap
               ("<box type=Bottom width=4 mb=2 color=" ++ colorFore ++ ">") "</box>") myXmobarPP))
      $ myConfig

myConfig = def
    { manageHook         = insertPosition Below Newer <+> myManageHook
    , handleEventHook    = myHandleEventHook
    , modMask            = myModMask
    , terminal           = myTerminal
    , focusFollowsMouse  = False
    , clickJustFocuses   = False
    , startupHook        = myStartupHook
    , layoutHook         = configurableNavigation noNavigateBorders $ withBorder myBorderWidth $ myLayoutHook
    , workspaces         = myWorkspaces
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormColor
    , focusedBorderColor = myFocusColor
    }
  `additionalKeysP`

---------------------------------------------------------------------}}}
-- Bindings                                                          {{{
------------------------------------------------------------------------
------------------------------------------------------------------------
-- Key Bindings
------------------------------------------------------------------------
    [ ("M-S-w", confirmPrompt hotPromptTheme "kill all windows in this workspace?" $ killAll)
    , ("M-S-r", spawn "xmonad --recompile && xmonad --restart") -- Restarts xmonad
    , ("M-S-e", confirmPrompt hotPromptTheme "Quit Xmonad?" $ io exitSuccess)  -- Quits xmonad
    , ("M-c", toggleCopyToAll)
    -- KB_GROUP Run Prompt
    , ("M-S-<Return>", spawn "dm-run") -- Dmenu

    -- KB_GROUP Useful programs to have a keybinding for launch
    , ("M-<Return>", spawn $ myTerminal)
    , ("M-b", spawn $ myBrowser)
    , ("M-d", spawn "dmenu_run")
    --, ("M-M1-h", spawn (myTerminal ++ " -e htop"))

  -- KB_GROUP Kill windows
    , ("M-q", (withFocused $ windows . W.sink) >> kill1)  -- Kill the currently focused client
    , ("M-S-q", killAll) -- Kill all windows of focused client on current ws

  -- KB_GROUP Workspaces
    , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
    , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

  -- KB_GROUP Floating windows
    --, ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
    , ("M-f", (sinkAll) >> sendMessage (T.Toggle "Full"))
    --, ("M-f", (withFocused $ windows . W.sink) >> sendMessage (XMonad.Layout.MultiToggle.Toggle FULL))
    --, ("M-t", sendMessage ToggleStruts)                       -- Push ALL floating windows to tile
    , ("M-v", sendMessage ToggleStruts)
    --, ("M-f", (sinkAll) >> sendMessage (XMonad.Layout.MultiToggle.Toggle FULL) >> sendMessage ToggleStruts)
    {-, ("M-f",     do withFocused (windows . W.sink)
                     sendMessage $ XMonad.Layout.MultiToggle.Toggle FULL
                     sendMessage $ ToggleStruts)-}
    , ("M-x", sendMessage $ MT.Toggle REFLECTX)
    , ("M-y", withFocused toggleFloat)
    , ("M-S-y", sinkAll)                       -- Push ALL floating windows to tile
    --, ("M-d", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full

  -- KB_GROUP Increase/decrease spacing (gaps)
    --, ("C-M1-j", decWindowSpacing 4)         -- Decrease window spacing
    --, ("C-M1-k", incWindowSpacing 4)         -- Increase window spacing
    --, ("C-M1-h", decScreenSpacing 4)         -- Decrease screen spacing
    --, ("C-M1-l", incScreenSpacing 4)         -- Increase screen spacing

  -- KB_GROUP Grid Select (CTR-g followed by a key)
    --, ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
    --, ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
    --, ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window

  -- KB_GROUP Windows navigation
    , ("M-m", windows W.focusDown)    -- Quick fix for monocle layout
    , ("M-S-m", windows W.focusUp)    -- Quick fix for monocle layout
   {-
    , ("M-j", windows W.focusDown)     -- Move focus to the below window
    , ("M-k", windows W.focusUp)     -- Move focus to the above window
    --, ("M-h", bindByLayout [("Full", windows W.focusDown), ("ReflectX Full", windows W.focusUp), ("", sendMessage $ Go L)])
    --, ("M-l", bindByLayout [("Full", windows W.focusUp), ("ReflectX Full", windows W.focusDown), ("", sendMessage $ Go R)])
    , ("M-h", sendMessage Expand)
    , ("M-l", sendMessage Shrink)
    , ("M-S-j", sendMessage $ Swap D) -- Swap focused window with below window
    , ("M-S-k", sendMessage $ Swap U) -- Swap focused window with above window
    , ("M-S-h", traverse_ sendMessage [Go R, Swap L, Go L]) -- Swap focused window with above window
    , ("M-S-l", traverse_ sendMessage [Go R, Swap L, Go R]) -- Swap focused window with above window
    --}
    --{
    , ("M-j",   Nav2d.windowGo D False)
    , ("M-k",   Nav2d.windowGo U False)
    , ("M-h",   Nav2d.windowGo L False)
    , ("M-l",   Nav2d.windowGo R False)
    , ("M-S-j",   Nav2d.windowSwap D False)
    , ("M-S-k",   Nav2d.windowSwap U False)
    , ("M-S-h",   Nav2d.windowSwap L False)
    , ("M-S-l",   Nav2d.windowSwap R False)
    ---}
    , ("M-<Backspace>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
    , ("M-S-<Backspace>", rotAllDown)       -- Rotate all the windows in the current stack

  -- KB_GROUP Layouts
    , ("M-<Space>", sendMessage NextLayout)           -- Switch to next layout
    , ("M1-<Space>", spawn "rofi -modi drun -show drun -config ~/.config/rofi/rofidmenu.rasi")           -- Switch to next layout
    --, ("M-d", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full

  -- KB_GROUP Increase/decrease windows in the master pane or the stack
    , ("M-S-<Up>", sendMessage $ IncMasterN 1)      -- Increase # of clients master pane
    , ("M-S-<Down>", sendMessage $ IncMasterN (-1)) -- Decrease # of clients master pane
    , ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
    , ("M-C-<Down>", decreaseLimit)                 -- Decrease # of windows

  -- KB_GROUP Sublayouts
  -- This is used to push windows to tabbed sublayouts, or pull them out of it.
    , ("M-C-h", sendMessage $ pullGroup L)
    , ("M-C-l", sendMessage $ pullGroup R)
    , ("M-C-k", sendMessage $ pullGroup U)
    , ("M-C-j", sendMessage $ pullGroup D)
    , ("M-C-m", withFocused (sendMessage . MergeAll))
    , ("M-C-u", withFocused (sendMessage . UnMerge))
    --, ("M-C-/", withFocused (sendMessage . UnMergeAll))
    , ("M-M1-l", bindByLayout [("Tabbed", windows W.focusDown), ("", onGroup W.focusUp')]) -- Switch focus to prev tab
    , ("M-M1-h", bindByLayout [("Tabbed", windows W.focusUp), ("", onGroup W.focusDown')])  -- Switch focus to next tab

  -- KB_GROUP Scratchpads
  -- Toggle show/hide these programs.  They run on a hidden workspace.
  -- When you toggle them to show, it brings them to your current workspace.
  -- Toggle them to hide and it sends them back to hidden workspace (NSP).
    , ("M-s t", namedScratchpadAction myScratchPads "terminal")
    , ("M-s m", namedScratchpadAction myScratchPads "mocp")
    , ("M-s c", namedScratchpadAction myScratchPads "calculator")

  -- KB_GROUP Controls for mocp music player (SUPER-u followed by a key)
    , ("M-u p", spawn "mocp --play")
    , ("M-u l", spawn "mocp --next")
    , ("M-u h", spawn "mocp --previous")
    , ("M-u <Space>", spawn "mocp --toggle-pause")

  -- KB_GROUP Emacs (SUPER-e followed by a key)
    {-
    , ("M-e e", spawn (myEmacs ++ ("--eval '(dashboard-refresh-buffer)'")))   -- emacs dashboard
    , ("M-e b", spawn (myEmacs ++ ("--eval '(ibuffer)'")))   -- list buffers
    , ("M-e d", spawn (myEmacs ++ ("--eval '(dired nil)'"))) -- dired
    , ("M-e i", spawn (myEmacs ++ ("--eval '(erc)'")))       -- erc irc client
    , ("M-e n", spawn (myEmacs ++ ("--eval '(elfeed)'")))    -- elfeed rss
    , ("M-e s", spawn (myEmacs ++ ("--eval '(eshell)'")))    -- eshell
    , ("M-e t", spawn (myEmacs ++ ("--eval '(mastodon)'")))  -- mastodon.el
    , ("M-e v", spawn (myEmacs ++ ("--eval '(+vterm/here nil)'"))) -- vterm if on Doom Emacs
    , ("M-e w", spawn (myEmacs ++ ("--eval '(doom/window-maximize-buffer(eww \"distro.tube\"))'"))) -- eww browser if on Doom Emacs
    , ("M-e a", spawn (myEmacs ++ ("--eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/\")'"))) 
    -}

  -- KB_GROUP Multimedia Keys
    , ("<XF86AudioPlay>", spawn "playerctl play-pause")
    , ("<XF86AudioPrev>", spawn "playerctl previous")
    , ("<XF86AudioNext>", spawn "playerctl next")
    , ("<XF86AudioMute>", spawn "amixer set Master toggle")
    , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
    , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
    , ("M1-m", spawn "amixer -q sset Capture toggle")
    , ("<XF86HomePage>", spawn "qutebrowser https://www.youtube.com/c/DistroTube")
    , ("<XF86Search>", spawn "dm-websearch")
    , ("<XF86Mail>", runOrRaise "thunderbird" (resource =? "thunderbird"))
    , ("<XF86Calculator>", runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk"))
    , ("<XF86Eject>", spawn "toggleeject")
    , ("<Print>", spawn "scrot")
    ]

------------------------------------------------------------------------
-- Mouse Bindings
------------------------------------------------------------------------
  `additionalMouseBindings`
    [ ((0, 8), (\_ -> spawn "amixer set Master 5%- unmute"))
    , ((0, 9), (\_ -> spawn "amixer set Master 5%+ unmute"))
    ]

  -- The following lines are needed for named scratchpads.
      where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
            nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

------------------------------------------------------------------------
-- Custom Bindings Helpers
------------------------------------------------------------------------
toggleFloat :: Window -> X ()
toggleFloat w =
  windows
    ( \s ->
        if M.member w (W.floating s)
          then W.sink w s
          else (W.float w (W.RationalRect (1 / 3) (1 / 4) (1 / 2) (1 / 2)) s)
    )

toggleCopyToAll = wsContainingCopies >>= \ws -> case ws of
                [] -> windows copyToAll
                _ -> killAllOtherCopies

---------------------------------------------------------------------}}}
-- workspaces                                                        {{{
------------------------------------------------------------------------
myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
--myWorkspaces = ["  01  ", "  02  ", "  03  ", "  04  ", "  05  ", "  06  ", "  07  ", "  08  ", "  09  "]
--myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

---------------------------------------------------------------------}}}
-- The Manage Hook                                                   {{{
------------------------------------------------------------------------
myManageHook :: ManageHook
myManageHook =
        manageDocks
    <+> fullscreenManageHook
    <+> composeAll
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces and the names would be very long if using clickable workspaces.
    [ checkDock                      --> doLower
    , className =? "confirm"         --> doFloat
    , className =? "confirm"         --> doFloat
    , className =? "file_progress"   --> doFloat
    , className =? "dialog"          --> doFloat
    , className =? "download"        --> doFloat
    , className =? "error"           --> doFloat
    , className =? "Gimp"            --> doFloat
    , className =? "notification"    --> doFloat
    , className =? "pinentry-gtk-2"  --> doFloat
    , className =? "splash"          --> doFloat
    , className =? "toolbar"         --> doFloat
    , className =? "Yad"             --> doCenterFloat
    , className =? "zoom"            --> doFullFloat
    , isFullscreen                   --> doFullFloat
    ] <+> namedScratchpadManageHook myScratchPads

---------------------------------------------------------------------------
-- X Event Actions
---------------------------------------------------------------------------
myHandleEventHook = XMonad.Layout.Fullscreen.fullscreenEventHook
                <+> Hacks.windowedFullscreenFixEventHook

eventLogHookForPolyBar :: X ()
eventLogHookForPolyBar = do
   winset <- gets windowset
   let layout = description . W.layout . W.workspace . W.current $ winset

   io $ appendFile "/tmp/.xmonad-layout-log" (layout ++ "\n")

---------------------------------------------------------------------------
-- Custom Hook Helpers
---------------------------------------------------------------------------
forceCenterFloat :: ManageHook
forceCenterFloat = doFloatDep move
  where
    move :: W.RationalRect -> W.RationalRect
    move _ = W.RationalRect x y w h

    w, h, x, y :: Rational
    w = 1/3
    h = 1/2
    x = (1-w)/2
    y = (1-h)/2

---------------------------------------------------------------------}}}
-- The Layout Hook                                                   {{{
------------------------------------------------------------------------
myLayoutHook =   avoidStruts
               $ T.toggleLayouts Full
               $ fullscreenFloat
               $ mouseResize
               $ mkToggle (single REFLECTX)
               -- $ mkToggle (single FULL) 
               $ myLayouts
             where
             myLayouts =       tall
                           ||| grid
                           ||| threeCol
                           ||| threeColMid
                           ||| Main.magnify
                           ||| tabs
                           ||| spirals
                           ||| threeRow
                           ||| tallAccordion
                           ||| wideAccordion

tall     = renamed [Replace "MasterStack"]
           -- $ reflectHoriz
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 5
           $ ResizableTall 1 (3/100) (1/2) []
grid     = renamed [Replace "Grid"]
           $ reflectHoriz
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 5
           $ Grid (16/10)
magnify  = renamed [Replace "Magnify"]
           $ reflectHoriz
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ limitWindows 12
           $ mySpacing 5
           $ ResizableTall 1 (3/100) (1/2) []
spirals  = renamed [Replace "Fibonacci"]
           $ reflectHoriz
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing 5
           $ spiral (6/7)
threeColMid = renamed [Replace "CenteredMaster"]
           $ reflectHoriz
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 5
           $ ThreeColMid 1 (3/100) (1/2)
threeCol = renamed [Replace "CenteredFloatingMaster"]
           $ reflectHoriz
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 5
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "ThreeRow"]
           $ reflectHoriz
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "Tabbed"]
           $ tabbed shrinkText myTabTheme
tallAccordion  = renamed [Replace "TallAccordion"]
           $ reflectHoriz
           $ Accordion
wideAccordion  = renamed [Replace "WideAccordion"]
           $ reflectHoriz
           $ Mirror Accordion

---------------------------------------------------------------------}}}
-- The XmobarPP                                                      {{{
------------------------------------------------------------------------
myXmobarPP :: PP
myXmobarPP = def
    { ppSep = xmobarColor color01 "" "  "
    , ppCurrent = xmobarColor color01 "#f28534" . wrap ("<box color=#f28534>") "</box>"
    , ppHidden = xmobarColor colorFore color01 
    , ppHiddenNoWindows = xmobarColor color17 color01
    , ppUrgent = xmobarColor color02 color01 . wrap ("<box type=Bottom width=4 mb=2 color=" ++ color02 ++ ">") "</box>"
    , ppLayout = xmobarColor colorFore color01 
    , ppTitle = xmobarColor colorFore "" . wrap 
    (xmobarColor colorFore "" "[") (xmobarColor colorFore "" "]") . xmobarColor "#f28534" "" . shorten 11 
    }

-- }}}
-- vim: ft=haskell:foldmethod=marker:expandtab:ts=4:shiftwidth=4
