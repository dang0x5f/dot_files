import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified XMonad.Actions.DynamicWorkspaceOrder as DO

import System.IO

import XMonad.Util.Run
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce
import XMonad.Util.ClickableWorkspaces
import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare

import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops

import XMonad.Actions.CycleWS
import XMonad.Actions.CopyWindow
import XMonad.Actions.FloatKeys
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.GridSelect

import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
--import XMonad.Layout.Spiral
--myLayout = renamed [CutWordsLeft 1]
--         . spacingWithEdge 1 
--         -- $ avoidStruts (tiled ||| Mirror tiled ||| Full ||| spiral (6/7))
------------------------------------------------------------------------
------------------------------------------------------------------------
myTerminal      = "st"
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
myClickJustFocuses :: Bool
myClickJustFocuses = False
myBorderWidth   = 2
myModMask       = mod4Mask
myWorkspaces    = ["1-\xf015","2-\xf390","3-\xf390","4-\xf390","5-\xf269","6-\xf87c","7-\xf15c","8-\xe4e5","9-\xf26c"]
--myWorkspaces    = ["main","dev0x1","dev0x2","dev0x3","web","media","edit","bhyve","game"]
myNormalBorderColor  = "#000000"--"#bbbbbb"
-- myFocusedBorderColor = "#bd93f9"--"#f5f5dc"
myFocusedBorderColor = "#f5f5dc"
myFilter = filterOutWsPP [scratchpadWorkspaceTag]
------------------------------------------------------------------------
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- system options
    , ((modm .|. shiftMask, xK_x     ), spawn "$HOME/.local/bin/sysmenu.sh")
    -- window tagging, copy to all workspaces & killing
    , ((modm,               xK_y     ), windows copyToAll)
    , ((modm .|. shiftMask, xK_y     ), killAllOtherCopies)
    -- cycle next and previous workspace
    --, ((modm,               xK_period), nextWS)
    --, ((modm,               xK_comma ), prevWS)
    --, ((modm,               xK_x     ), nextWS)
    --, ((modm,               xK_z     ), prevWS)
    -- skips over taken WS, above swaps WS's
    , ((modm,               xK_x     ), DO.moveTo Next hiddenWS)
    , ((modm,               xK_z     ), DO.moveTo Prev hiddenWS)
    , ((modm,               xK_period), DO.moveTo Next hiddenWS)
    , ((modm,               xK_comma ), DO.moveTo Prev hiddenWS)
    -- scratchpads
    , ((modm .|. shiftMask, xK_n     ), namedScratchpadAction scratchpads "news")
    , ((modm .|. shiftMask, xK_v     ), namedScratchpadAction scratchpads "vidplayer")
    , ((modm .|. shiftMask, xK_m     ), namedScratchpadAction scratchpads "mocp")
    , ((modm .|. shiftMask, xK_s     ), namedScratchpadAction scratchpads "terminal")
    -- Rotate through the available layouts
    , ((modm,               xK_F3    ), sendMessage NextLayout)
    -- gridselect
    , ((modm,               xK_F4    ), goToSelected def)
    -- disable touchpad
    --, ((modm,               xK_F6    ), spawn "$HOME/.local/bin/touchpadToggle.sh")
    -- mocp: prev, toggle, next
    , ((modm,               xK_F7    ), spawn "mocp -r")
    , ((modm,               xK_F8    ), spawn "mocp -G")
    , ((modm,               xK_F9    ), spawn "mocp -f")
    -- volume controls
    , ((modm,               xK_F10   ), spawn "$HOME/.local/bin/audio.sh -z")
    , ((modm,               xK_F11   ), spawn "$HOME/.local/bin/audio.sh -d")
    , ((modm,               xK_F12   ), spawn "$HOME/.local/bin/audio.sh -u")
    -- inc/dec backlight
    , ((modm,               xK_Up    ), spawn "backlight incr 5")
    , ((modm,               xK_Down  ), spawn "backlight decr 5")
    -- browsers
    , ((modm .|. shiftMask, xK_b     ), spawn "firefox")
    , ((modm .|. controlMask, xK_b   ), spawn "qutebrowser $HOME/.config/qutebrowser/launcher.html")
    -- launch dmenu
    , ((modm .|. shiftMask, xK_d     ), spawn "$HOME/.local/bin/appmenu.sh")
    -- launch nsxiv
    , ((modm .|. shiftMask, xK_i     ), spawn "nsxiv -t $HOME/pics/")
    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill1)
    -- Move focus to the next window
    , ((mod1Mask,           xK_Tab   ), windows W.focusDown)
    , ((shiftMask,          xK_Tab   ), windows W.focusUp)
    -- Move focus to the next window
    --, ((modm,               xK_j     ), windows W.focusDown)
    -- Resize Floating Window - Increase
    --, ((modm .|. shiftMask, xK_equal ), withFocused (keysResizeWindow (-10,-10) (1,1)))
    -- Resize Floating Window - Decrease
    --, ((modm .|. shiftMask, xK_minus ), withFocused (keysResizeWindow (10,10) (1,1)))
    -- Move focus to the previous window
    --, ((modm,               xK_k     ), windows W.focusUp  )
    -- Move focus to the master window
    --, ((modm,               xK_m     ), windows W.focusMaster  )
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
    -- VI Movement Keys Below
    -- Swap the focused window with the next window
    , ((modm,               xK_j     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modm,               xK_k     ), windows W.swapUp    )
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    -- Move Up
    , ((modm .|. shiftMask, xK_k     ), withFocused (keysMoveWindow (0, -10)))
    -- Move Down
    , ((modm .|. shiftMask, xK_j     ), withFocused (keysMoveWindow (0, 10)))
    -- Move Right
    , ((modm .|. shiftMask, xK_h     ), withFocused (keysMoveWindow (-10, 0)))
    -- Move Left
    , ((modm .|. shiftMask, xK_l     ), withFocused (keysMoveWindow (10, 0)))
    -- Toggles floats, where clause at end describes toggle
    , ((modm,               xK_f     ), withFocused toggleFloat)
    -- Toggle the status bar gap **NOW BUILT INTO PP**
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --[((m .|. modm, k), windows $ onCurrentScreen f i)
    --    | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
    --    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask), (copy, shiftMask .|. controlMask)]]
    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    -- source: anitpod1 on reddit
    where
        toggleFloat w = windows (\s -> if M.member w (W.floating s)
                        then W.sink w s
                        else (W.float w (W.RationalRect (1/5) (1/4) (3/5) (3/5)) s))
------------------------------------------------------------------------
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
------------------------------------------------------------------------
------------------------------------------------------------------------
-- Layouts:
myLayout = renamed [CutWordsLeft 1]
         . spacingWithEdge 1 
	 $ avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
     -- The default number of windows in the master pane
     -- Default proportion of screen occupied by master pane
     -- Percent of screen to increment by when resizing panes
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100
------------------------------------------------------------------------
------------------------------------------------------------------------
-- Window rules:
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
scratchpads = [ NS "mocp" "st -e mocp" 
		(title =? "mocp") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)) 
              , NS "terminal" "st -c scratchpad" 
	      	(className =? "scratchpad") (customFloating $ W.RationalRect (1/6) (1/8) (2/3) (3/4))
	      , NS "vidplayer" "mpv" 
	      	(className =? "mpv") (customFloating $ W.RationalRect (0.75) (0.03) (0.25) (0.25))
	      , NS "news" "st -e newsboat"
	        (title =? "newsboat") (customFloating $ W.RationalRect (0.25) (1/4) (0.45) (2/5))
              ]
------------------------------------------------------------------------
------------------------------------------------------------------------
myManageHook = composeAll
    [ className =? "Zathura"        --> doShift ( myWorkspaces !! 5 )
    , className =? "Surf"           --> doShift ( myWorkspaces !! 5 )
    , className =? "wow.exe"        --> doShift ( myWorkspaces !! 8 )
    , className =? "Abiword"        --> doShift ( myWorkspaces !! 6 )
    , className =? "Gtkpod"         --> doShift ( myWorkspaces !! 6 )
    , className =? "firefox-esr"    --> doShift ( myWorkspaces !! 4 )
    , className =? "qutebrowser"    --> doShift ( myWorkspaces !! 4 )
    , className =? "Pcmanfm"        --> doShift ( myWorkspaces !! 0 )
    , className =? "Lxappearance"   --> doShift ( myWorkspaces !! 0 )
    , className =? "firefox-esr" <&&> resource =? "Toolkit" --> doRectFloat (W.RationalRect (0.75) (0.03) (0.25) (0.25))
    , className =? "processing-app-Base"          --> doFloat
    , className =? "Gtkpod"         --> doFloat
    , className =? "confirm"        --> doFloat
    , className =? "dialog"         --> doFloat
    , className =? "download"       --> doFloat
    , className =? "error"          --> doFloat
    , className =? "file_progress"  --> doFloat
    , className =? "notification"   --> doFloat
    , isFullscreen --> doFullFloat
    ]
    <+> namedScratchpadManageHook scratchpads
------------------------------------------------------------------------
------------------------------------------------------------------------
-- Event handling
-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
myEventHook = mempty--swallowEventHook (className =? "st-256color") (return True)
------------------------------------------------------------------------
------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
myLogHook = return ()
------------------------------------------------------------------------
------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
-- By default, do nothing.
myStartupHook = return ()
------------------------------------------------------------------------
------------------------------------------------------------------------
main = xmonad
     . ewmhFullscreen
     . workspaceNamesEwmh
     . ewmh
     . docks
     . withEasySB (statusBarProp "xmobar $HOME/.config/xmobar/xmobarrc" (clickablePP $ myFilter myXmobarPP)) defToggleStrutsKey
     $ myConfig

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
      layoutHook         = myLayout,
      manageHook         = myManageHook,
      handleEventHook    = myEventHook,
      logHook            = myLogHook,
      startupHook        = myStartupHook
    }

myXmobarPP = def
      { ppSep              = magenta " <fn=4>\xf111</fn> "
      , ppTitleSanitize    = xmobarStrip
      , ppCurrent          = magenta . wrap "" "" . xmobarBorder "Top" "#8be9fd" 2
      , ppHidden           = white . wrap "" ""
      , ppHiddenNoWindows  = lowWhite . wrap "" ""
      , ppUrgent           = red . wrap (yellow "!") (yellow "!")
      , ppOrder            = \[ws, l, _, wins] -> [ws, l, wins]
      , ppExtras           = [logTitles formatFocused formatUnfocused]
      }
    where
      formatFocused        = wrap (cyan     "[") (cyan     "]") . magenta . ppWindow
      formatUnfocused      = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

      ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 20

      magenta  = xmobarColor "#ff79c6" ""
      blue     = xmobarColor "#bd93f9" ""
      cyan     = xmobarColor "#8be9fd" ""
      --white    = xmobarColor "#f8f8f2" ""
      white    = xmobarColor "#fffdd0" ""
      yellow   = xmobarColor "#f1fa8c" ""
      red      = xmobarColor "#ff5555" ""
      lowWhite = xmobarColor "#666666" ""
