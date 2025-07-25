import XMonad
import Data.Monoid
-- import Data.Ratio -- %

import System.IO
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified XMonad.Actions.DynamicWorkspaceOrder as DO

import XMonad.Prelude
import XMonad.Core

import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad

import XMonad.Util.Run
import XMonad.Util.Font
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce
import XMonad.Util.ClickableWorkspaces
import XMonad.Util.ActionCycle
import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare

-- import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName

import XMonad.Actions.CycleWS
import XMonad.Actions.CopyWindow
import XMonad.Actions.FloatKeys
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.GridSelect
import XMonad.Actions.TagWindows

import XMonad.Layout.NoBorders
-- import XMonad.Layout.Fullscreen as FS
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
--import XMonad.Layout.Spiral

------------------------------------------------------------------------
----------------------------------------------------------------------------- o
myTerminal           = "st"
myFocusFollowsMouse  = True
myClickJustFocuses   = False
myBorderWidth        = 2
myModMask            = mod4Mask
-- myWorkspaces         = [ "<fc=#ff79c6>¹</fc>main"
--                         ,"<fc=#ff79c6>²</fc>dev"
--                         ,"<fc=#ff79c6>³</fc>dev"
--                         ,"<fc=#ff79c6>⁴</fc>dev"
--                         ,"<fc=#ff79c6>⁵</fc>net"
--                         ,"<fc=#ff79c6>⁶</fc>media"
--                         ,"<fc=#ff79c6>⁷</fc>edit"
--                         ,"<fc=#ff79c6>⁸</fc>virt"
--                         ,"<fc=#ff79c6>⁹</fc>misc" ]
myWorkspaces         = [ "<fc=#ff79c6>¹</fc>main"
                        ,"0x2"
                        ,"0x3"
                        ,"0x4"
                        ,"<fc=#ff79c6>⁵</fc>net"
                        ,"0x6"
                        ,"<fc=#ff79c6>⁷</fc>view"
                        ,"<fc=#ff79c6>⁸</fc>edit"
                        ,"0x9" ]
myNormalBorderColor  = "#444444"
myFocusedBorderColor = "#bd93f9" --"#f5f5dc" #df2c14 "#bd93f9" #f1fa8c
myFilter = filterOutWsPP [scratchpadWorkspaceTag]

growRight   = (withFocused (keysResizeWindow (10,0)  (0,0)) )
growLeft    = (withFocused (keysResizeWindow (10,0)  (1,1)) )
growUp      = (withFocused (keysResizeWindow (0,15)  (0,0)) )
growDown    = (withFocused (keysResizeWindow (0,15)  (1,1)) )
shrinkRight = (withFocused (keysResizeWindow (-10,0) (0,0)) )
shrinkLeft  = (withFocused (keysResizeWindow (-10,0) (1,1)) )
shrinkUp    = (withFocused (keysResizeWindow (0,-10) (0,0)) )
shrinkDown  = (withFocused (keysResizeWindow (0,-10) (1,1)) )

------------------------------------------------------------------------
----------------------------------------------------------------------------- o
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)  -- launch a terminal
    , ((modm .|. shiftMask, xK_c     ), kill1)                         -- close focus

    -- , ((modm,               xK_n     ), refresh)
    -- , ((modm,               xK_y     ), windows copyToAll)   -- win tag, copyToAllWs
    -- , ((modm .|. shiftMask, xK_y     ), killAllOtherCopies)  -- kill tagged copies

    , ((modm,               xK_t     ), withFocused (addTag "stalk"))  -- win tag, copyToAllWs
    , ((modm .|. shiftMask, xK_t     ), withFocused (delTag "stalk"))  -- kill tagged copies

    , ((modm,               xK_Tab   ), windows W.focusDown )  -- rotate focus
    , ((modm,               xK_Return), windows W.swapMaster)  -- rotate focus to main

    , ((modm,               xK_f     ), withFocused toggleFloat)                     -- toggles float
    , ((modm     .|. shiftMask, xK_equal ), sequence_ [ growRight   , growLeft   ])  -- grows   float R/L
    , ((mod1Mask .|. shiftMask, xK_equal ), sequence_ [ growUp      , growDown   ])  -- grows   float U/D
    , ((modm     .|. shiftMask, xK_minus ), sequence_ [ shrinkRight , shrinkLeft ])  -- shrinks float R/L
    , ((mod1Mask .|. shiftMask, xK_minus ), sequence_ [ shrinkUp    , shrinkDown ])  -- shrinks float U/D
    , ((modm .|. shiftMask, xK_l     ), withFocused (keysMoveWindow ( 25  ,   0)))   -- moves   float R
    , ((modm .|. shiftMask, xK_h     ), withFocused (keysMoveWindow (-25  ,   0)))   -- moves   float L
    , ((modm .|. shiftMask, xK_k     ), withFocused (keysMoveWindow (  0  , -25)))   -- moves   float U
    , ((modm .|. shiftMask, xK_j     ), withFocused (keysMoveWindow (  0  ,  25)))   -- moves   float D

    , ((modm,               xK_k     ), windows W.swapUp)    -- swap focused with prev win
    , ((modm,               xK_j     ), windows W.swapDown)  -- swap focused with next win
    , ((modm,               xK_h     ), sendMessage Shrink)  -- shrink main win
    , ((modm,               xK_l     ), sendMessage Expand)  -- expand main win

    , ((modm,               xK_x     ), sequence_ [ (DO.moveTo Next hiddenWS), stalkerTagAlong ])  -- move ws right
    , ((modm,               xK_z     ), sequence_ [ (DO.moveTo Prev hiddenWS), stalkerTagAlong ])  -- move ws left
    , ((modm,               xK_period), sequence_ [ (DO.moveTo Next hiddenWS), stalkerTagAlong ])  -- move ws right
    , ((modm,               xK_comma ), sequence_ [ (DO.moveTo Prev hiddenWS), stalkerTagAlong ])  -- move ws left

    , ((modm .|. shiftMask, xK_n     ), namedScratchpadAction scratchpads "news")       -- scratchpad
    , ((modm .|. shiftMask, xK_v     ), namedScratchpadAction scratchpads "vidplayer")  -- scratchpad
    , ((modm .|. shiftMask, xK_m     ), namedScratchpadAction scratchpads "mocp")       -- scratchpad
    , ((modm .|. shiftMask, xK_s     ), namedScratchpadAction scratchpads "terminal")   -- scratchpad

    , ((mod1Mask,           xK_Tab   ), goToSelected def)  -- Alt-Tab window switch

    -- , ((modm,               xK_F1    ), )   -- F1  : undefined
    -- , ((modm,               xK_F2    ), )   -- F2  : undefined
    , ((modm,               xK_F3    ), sendMessage NextLayout)                   -- F3  : rotate layouts
    -- , ((modm,               xK_F4    ), )   -- F4  : undefined
    -- , ((modm,               xK_F5    ), )   -- F5  : undefined
    , ((modm,               xK_F6    ), spawn "exec.sh msg touchpad_toggle")  -- F6  : toggle touchpad
    , ((modm,               xK_F7    ), spawn "mocp -r")                      -- F7  : prev
    , ((modm,               xK_F8    ), spawn "mocp -G")                      -- F8  : toggle
    , ((modm,               xK_F9    ), spawn "mocp -f")                      -- F9  : next
    -- , ((modm,               xK_F10   ), spawn "exec.sh util volume_mute")     -- F10 : mute
    -- , ((modm,               xK_F11   ), spawn "exec.sh util volume_down")     -- F11 : vol-
    -- , ((modm,               xK_F12   ), spawn "exec.sh util volume_up")       -- F12 : vol+
    , ((modm,               xK_F10   ), spawn "osd -v !")                       -- F10 : mute
    , ((modm,               xK_F11   ), spawn "osd -v -")                       -- F11 : vol-
    , ((modm,               xK_F12   ), spawn "osd -v +")                       -- F12 : vol+

    , ((modm,               xK_Up    ), spawn "backlight incr 5")  -- brightness+
    , ((modm,               xK_Down  ), spawn "backlight decr 5")  -- brightness-

    , ((modm .|. shiftMask,   xK_b   ), spawn "firefox")        -- browser1
    , ((modm .|. controlMask, xK_b   ), spawn "qutebrowser")    -- browser2

    , ((modm .|. shiftMask, xK_d     ), parentPrompt myXPromptConfig)  -- menu prompt 
    , ((modm .|. shiftMask, xK_x     ), sysPrompt    myXPromptConfig)  -- system power options prompt
    
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))                     -- quit xmonad & xorg session
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")  -- restart , recompile
    ]
    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --[((m .|. modm, k), windows $ onCurrentScreen f i)
    --    | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
    --    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- [((m .|. modm, k), sequence_ [ (windows $ f i) , (withTaggedGlobalP "stalk" (W.shiftWin i)) ])
    [((m .|. modm, k), sequence_ [ (windows $ f i) , stalkerTagAlong ])
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask), (copy, shiftMask .|. controlMask)]]
    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    where
        toggleFloat w = windows (\s -> if M.member w (W.floating s)
                        then W.sink w s
                        else (W.float w (W.RationalRect (1/4) (1/4) (0.5) (0.5)) s))
                        -- else (W.float w (W.RationalRect (1/4) (0.025) (0.5) (0.5)) s))
                        -- else (W.float w (W.RationalRect (0) (0.025) (0.35) (0.5)) s))   
        stalkerTagAlong = (withTaggedGlobalP "stalk" (shiftHere) )
------------------------------------------------------------------------
----------------------------------------------------------------------------- o
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w         -- (left): float focus & move by dragging
                                       >> windows W.shiftMaster))   
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))   -- (middle): raise win to top of stack
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w       -- (right): float focus & resize by dragging
                                       >> windows W.shiftMaster))
    -- undefined: scroll wheel & any extra buttons (e.g., button4, button5, ...)
    ]

------------------------------------------------------------------------
----------------------------------------------------------------------------- o
myLayout = renamed [CutWordsLeft 1]
         . spacingWithEdge 1
         $ avoidStruts (tiled ||| mirr ||| full)
  where
     tiled   = Tall nmaster delta ratio
     mirr    = Mirror tiled
     full    = noBorders Full

     nmaster = 1      -- num windows in master pane
     ratio   = 1/2    -- master pane size
     delta   = 3/100  -- increment % when resizng panes

------------------------------------------------------------------------
----------------------------------------------------------------------------- o
myManageHook = composeAll
    [ className =? "Pcmanfm"      --> doShift ( myWorkspaces !! 0 )
    , className =? "Gtkpod"       --> doShift ( myWorkspaces !! 0 )
    , className =? "FileZilla"    --> doShift ( myWorkspaces !! 0 )
    , className =? "lffm"         --> doShift ( myWorkspaces !! 0 )
    , className =? "Lxappearance" --> doShift ( myWorkspaces !! 0 )
    , className =? "firefox"      --> doShift ( myWorkspaces !! 4 )
    , className =? "firefox-esr"  --> doShift ( myWorkspaces !! 4 )
    , className =? "qutebrowser"  --> doShift ( myWorkspaces !! 4 )
    , className =? "Zathura"      --> doShift ( myWorkspaces !! 6 )
    , className =? "Abiword"      --> doShift ( myWorkspaces !! 7 )
    , className =? "Gimp"         --> doShift ( myWorkspaces !! 7 )
    , className =? "Vncviewer"    --> doShift ( myWorkspaces !! 8 ) 
    , className =? "wow.exe"      --> doShift ( myWorkspaces !! 8 )

    , className =? "firefox" <&&> resource =? "Toolkit" --> doRectFloat (W.RationalRect (0.75) (0.03) (0.25) (0.25))
    , className =? "firefox-esr" <&&> resource =? "Toolkit" --> doRectFloat (W.RationalRect (0.75) (0.03) (0.25) (0.25))

    , className =? "Main"  --> doFloat -- java
    , className =? "processing-app-Base"  --> doFloat
    , className =? "Gtkpod"               --> doFloat
    , className =? "SimpleScreenRecorder" --> doFloat
    , className =? "confirm"              --> doFloat
    , className =? "dialog"               --> doFloat
    , className =? "download"             --> doFloat
    , className =? "error"                --> doFloat
    , className =? "file_progress"        --> doFloat
    , className =? "notification"         --> doFloat

    , isFullscreen --> doFullFloat
    , isDialog     --> doFloat
    ]
    <+> namedScratchpadManageHook scratchpads

scratchpads = 
    [ NS "mocp" "st -e mocp" 
     (title =? "mocp")           
     (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)) 

     , NS "terminal" "st -c scratchpad" 
     (className =? "scratchpad") 
     (customFloating $ W.RationalRect (1/6) (1/8) (2/3) (3/4))

     , NS "vidplayer" "mpv" 
     (className =? "mpv")        
     (customFloating $ W.RationalRect (0.75) (0.03) (0.25) (0.25))

     , NS "news" "st -e newsboat"
     (title =? "newsboat")       
     (customFloating $ W.RationalRect (0.25) (1/4) (0.45) (2/5))

     , NS "library" "st -c liberry -e lf -single /mnt/biblioteca"
     (className =? "liberry")    
     (customFloating $ W.RationalRect (0.25) (1/4) (0.45) (2/5))

     , NS "calendar" "st -c cal -e calcurse"
     (className =? "cal")    
     (customFloating $ W.RationalRect (0.25) (1/4) (0.45) (2/5))
    ]

------------------------------------------------------------------------
----------------------------------------------------------------------------- o
myEventHook =  serverModeEventHook 
           <> serverModeEventHookCmd 
           -- <> swallowEventHook (className =? "st-256color" <||> className =? "Xterm") (return True)
           -- <> FS.fullscreenEventHook --mempty

myLogHook = return ()

-- myStartupHook = return ()
myStartupHook = setWMName "LG3D"

------------------------------------------------------------------------
----------------------------------------------------------------------------- o
main = xmonad
     . ewmhFullscreen 
     . workspaceNamesEwmh
     . ewmh
     . docks
     . withEasySB mySB defToggleStrutsKey $ myConfig

myConfig = def 
    { terminal           = myTerminal,
      focusFollowsMouse  = myFocusFollowsMouse,
      clickJustFocuses   = myClickJustFocuses,
      borderWidth        = myBorderWidth,
      modMask            = myModMask,
      workspaces         = myWorkspaces,
      normalBorderColor  = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor,

      keys               = myKeys,
      mouseBindings      = myMouseBindings,

      manageHook         = myManageHook,
      handleEventHook    = myEventHook ,
      layoutHook         = myLayout,

      logHook            = myLogHook,
      startupHook        = myStartupHook
    }

mySB       = (statusBarProp "xmobar $HOME/.xmobarrc" (clickablePP $ myFilter myXmobarPP))
myXmobarPP = def
      { ppSep              = magenta "  <fn=3>\xf142</fn>  "
      , ppWsSep            = "  "
      , ppTitleSanitize    = xmobarStrip
      , ppCurrent          = yellow . wrap "" "" . xmobarBorder "Top" "#8be9fd" 2
      , ppHidden           = white . wrap "" ""
      , ppHiddenNoWindows  = lowWhite . wrap "" ""
      , ppUrgent           = red . wrap (yellow "!") (yellow "!")
      , ppOrder            = \[ws, l, _] -> [ws, l]
      -- , ppOrder            = \[ws, l, _, wins] -> [ws, l]
      -- , ppOrder            = \[ws, l, _, wins] -> [ws, l, wins]
      -- , ppOrder            = \[ws, l, _, wins, mocp] -> [ws, l, mocp]
      -- , ppExtras           = [logTitles formatFocused formatUnfocused]
      -- , ppExtras           = [xmobarColorL "#000000" "#ffffff" logClassname]
      -- , ppExtras           = [logClassnames formatFocused formatUnfocused, mocpSong]
      }
    where
      -- formatFocused        = wrap (cyan     "[") (cyan     "]") . magenta . ppWindow
      -- formatUnfocused      = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

      -- ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 15
      -- mocpSong = xmobarColorL "#8be9fd" "#666666" $ wrapL " " " " $ shortenL 30 $ logCmd "xmobar-mocp.sh" 

      magenta  = xmobarColor "#ff79c6" ""
      blue     = xmobarColor "#bd93f9" ""
      cyan     = xmobarColor "#8be9fd" ""
      --white    = xmobarColor "#f8f8f2" ""
      white    = xmobarColor "#fffdd0" ""
      yellow   = xmobarColor "#f1fa8c" ""
      red      = xmobarColor "#ff5555" ""
      lowWhite = xmobarColor "#666666" ""

myXPromptConfig = def
      { font              = "xft:IBM Plex Mono-10"
      , bgColor           = "#444444"
      , fgColor           = "#fffdd0"
      -- , bgHLight          = "#8be9fd"
      -- , fgHLight          = "#ff79c6"
      , borderColor       = "#ff79c6"
      , promptBorderWidth = 2
      -- , position          = Top
      -- , position          = CenteredAt 0.25 0.25
      , position           = CenteredAt 0.5 0.1
      , maxComplColumns    = Just 1
      , promptKeymap       = vimLikeXPKeymap
      }

-- //*********************************************************************************
-- //           * * * * * * * Parent Menu Prompt * * * * * * * 
-- //*********************************************************************************
newtype ParentPromptStr = ParentPromptStr String
instance XPrompt ParentPromptStr
    where
      showXPrompt (ParentPromptStr str) = str <> " "

myParentPrompt :: [(String, X())]
myParentPrompt =
    [
      ( "exit"       , spawn "xdotool key Escape" )
    , ( "f_manager"  , fmPrompt       myXPromptConfig)
    , ( "biblioteca" , namedScratchpadAction scratchpads "library")
    , ( "launcher"   , shellPrompt    myXPromptConfig { position = Top , maxComplColumns = Nothing })
    , ( "manual"     , manPrompt      myXPromptConfig { position = Top , maxComplColumns = Nothing })
    , ( "settings"   , settingsPrompt myXPromptConfig { position = CenteredAt 0.5 0.15 })
    , ( "sys_pwr"    , sysPrompt      myXPromptConfig)
    ]

parentPrompt :: XPConfig -> X()
parentPrompt c = do
    parentPromptWrap ">" myParentPrompt c

parentPromptWrap :: String -> [(String,X())] -> XPConfig -> X()
parentPromptWrap title coms conf = 
    mkXPrompt (ParentPromptStr title) conf (mkComplFunFromList' conf (map fst coms)) $
        fromMaybe (return()) . (`lookup` coms)

-- //*********************************************************************************
-- //           * * * * * * * System Session & Power Prompt * * * * * * * 
-- //*********************************************************************************
newtype SysPromptStr = SysPromptStr String
instance XPrompt SysPromptStr 
    where
      showXPrompt (SysPromptStr str) = str <> " "

myCustomSysCommandList :: [(String, X())]
myCustomSysCommandList = 
    [
      ( "back"     , parentPrompt myXPromptConfig )
    , ( "exit"     , spawn "xdotool key Escape" )
    , ( "restart"  , spawn "shutdown -r now" )
    , ( "poweroff" , spawn "shutdown -p now" )
    ]

sysPrompt :: XPConfig -> X()
sysPrompt c = do
    sysXPromptWrap ">" myCustomSysCommandList c

sysXPromptWrap :: String -> [(String,X())] -> XPConfig -> X()
sysXPromptWrap p cmds config = 
    mkXPrompt (SysPromptStr p) config (mkComplFunFromList' config (map fst cmds)) $
        fromMaybe (return ()) . (`lookup` cmds)

-- //*********************************************************************************
-- //           * * * * * * File Manage Prompt * * * * * * * 
-- //*********************************************************************************
newtype FMPromptStr = FMPromptStr String
instance XPrompt FMPromptStr 
    where
      showXPrompt (FMPromptStr str) = str <> " "

myFMList :: [(String, X())]
myFMList = 
    [
      ( "back"         , parentPrompt myXPromptConfig )
    , ( "pcmanfm"      , spawn "pcmanfm" )
    , ( "lf"           , spawn "st -c lffm -e lf -single" )
    , ( "filezilla"    , spawn "filezilla" )
    , ( "lxappearance" , spawn "lxappearance" )
    ]

fmPrompt :: XPConfig -> X()
fmPrompt c = do
    fmPromptWrap ">" myFMList c

fmPromptWrap :: String -> [(String,X())] -> XPConfig -> X()
fmPromptWrap p cmds config = 
    mkXPrompt (FMPromptStr p) config (mkComplFunFromList' config (map fst cmds)) $
        fromMaybe (return ()) . (`lookup` cmds)


-- //*********************************************************************************
-- //           * * * * * * Settings Management Prompt * * * * * * * 
-- //*********************************************************************************
newtype SettingsPromptStr = SettingsPromptStr String
instance XPrompt SettingsPromptStr
    where
      showXPrompt (SettingsPromptStr str) = str <> " "

mySettingsList :: [(String, X())]
mySettingsList =
    [
      ( "back",             parentPrompt myXPromptConfig )
    , ( ".ssh/config",      spawn "st -e vim $HOME/.ssh/config")
    , ( ".moc/config",      spawn "st -e vim $HOME/.moc/config")
    , ( ".moc/Keymap",      spawn "st -e vim $HOME/.moc/Keymap")
    , ( ".newsboat/config", spawn "st -e vim $HOME/.newsboat/config")
    , ( ".newsboat/urls",   spawn "st -e vim $HOME/.newsboat/urls")
    , ( ".shrc",            spawn "st -e vim $HOME/.shrc")
    , ( ".vimrc",           spawn "st -e vim $HOME/.vimrc")
    , ( ".xinitrc",         spawn "st -e vim $HOME/.xinitrc")
    , ( ".Xresources",      spawn "st -e vim $HOME/.Xresources")
    , ( "/usr/local/etc/xdg/picom.conf", spawn "st -e vim /usr/local/etc/xdg/picom.conf")
    ]

settingsPrompt :: XPConfig -> X()
settingsPrompt c = do
    settingsPromptWrap ">" mySettingsList c

settingsPromptWrap :: String -> [(String, X())] -> XPConfig -> X()
settingsPromptWrap p cmds config =
    mkXPrompt (SettingsPromptStr p) config (mkComplFunFromList' config (map fst cmds)) $
        fromMaybe (return ()) . (`lookup` cmds)
