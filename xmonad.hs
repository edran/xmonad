{-
  This is my xmonad configuration file.
  There are many like it, but this one is mine.

  If you want to customize this file, the easiest workflow goes
  something like this:
    1. Make a small change.
    2. Hit "super-q", which recompiles and restarts xmonad
    3. If there is an error, undo your change and hit "super-q" again to
       get to a stable place again.
    4. Repeat

  Author:     David Brewer
  Repository: https://github.com/davidbrewer/xmonad-ubuntu-conf
-}

import XMonad
import XMonad.Actions.GridSelect
import XMonad.Actions.Plane
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers -- for fullscreen support
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Circle
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Prompt
import XMonad.Prompt.Workspace
import XMonad.Util.EZConfig
import XMonad.Util.Run
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Data.Ratio ((%))

{-
  Xmonad configuration variables. These settings control some of the
  simpler parts of xmonad's behavior and are straightforward to tweak.
-}

myFocusFollowsMouse  = True
myModMask            = mod4Mask       -- changes the mod key to "super"
myNormalBorderColor  = "#FFFFFF"
myFocusedBorderColor = "#FF0000"
myBorderWidth        = 1              -- width of border around windows
myTerminal           = "terminator"   -- which terminal software to use


{-
  Xmobar configuration variables. These settings control the appearance
  of text which xmonad is sending to xmobar via the DynamicLog hook.
-}

myTitleColor     = "#eeeeee"  -- color of window title
myTitleLength    = 80         -- truncate window title to this length
myCurrentWSColor = "#e6744c"  -- color of active workspace
myVisibleWSColor = "#c185a7"  -- color of inactive workspace
myUrgentWSColor  = "#cc0000"  -- color of workspace with 'urgent' window
myCurrentWSLeft  = "["        -- wrap active workspace with these
myCurrentWSRight = "]"
myVisibleWSLeft  = "("        -- wrap inactive workspace with these
myVisibleWSRight = ")"
myUrgentWSLeft  = "{"         -- wrap urgent workspace with these
myUrgentWSRight = "}"


{-
  Workspace configuration. Here you can change the names of your
  workspaces. Note that they are organized in a grid corresponding
  to the layout of the number pad.

  I would recommend sticking with relatively brief workspace names
  because they are displayed in the xmobar status bar, where space
  can get tight. Also, the workspace labels are referred to elsewhere
  in the configuration file, so when you change a label you will have
  to find places which refer to it and make a change there as well.

  This central organizational concept of this configuration is that
  the workspaces correspond to keys on the number pad, and that they
  are organized in a grid which also matches the layout of the number pad.
  So, I don't recommend changing the number of workspaces unless you are
  prepared to delve into the workspace navigation keybindings section
  as well.
-}

myWorkspaces =
  [
    "1:α",
    "2:β",
    "3:γ",
    "4:δ",
    "5:ε",
    "6:ζ",
    "7:η",
    "8:θ",
    "9:ι"
    --    "0:κ"
  ]

startupWorkspace = "1:α"

myTabConfig :: Theme
myTabConfig = defaultTheme { fontName = "xft: Ubuntu-10"
                           , activeColor         =  "#272822"
                           , inactiveColor       =  "#272822"
                           , urgentColor         =  "#C4BE89"
                           , activeBorderColor   =  "#282923"
                           , inactiveBorderColor =  "#282923"
                           , urgentBorderColor   =  "#C4BE89"
                           , activeTextColor     =  "#A6E22E"
                           , inactiveTextColor   =  "#6D8E290"
                           , urgentTextColor     =  "#6D8E29"
                           , decoWidth           = 100
                           , decoHeight          = 17
                           , windowTitleAddons   = []
                           , windowTitleIcons    = []
}
preLayout = avoidStruts $ desktopLayoutModifiers
            $   tiled
            ||| Mirror tiled
            ||| Grid
            ||| tabbed shrinkText myTabConfig
            ||| Full

  where
    -- mfocus = named "Magic Focus" (magicFocus (Mirror tiled))
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    ratio   = 3/5
    delta   = 3/100

myLayout = smartBorders preLayout

{-
  http://xmonad.org/xmonad-docs/xmonad/doc-index-X.html

  run "xev" command-line tool to determine the code for a specific
  key. Launch the command, then type the key in question and watch the
  output.
-}

myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
  [
    ((modm, xK_b), sendMessage ToggleStruts)
    , ((modm, xK_a), sendMessage MirrorShrink)
    , ((modm, xK_z), sendMessage MirrorExpand)
    , ((modm, xK_p), spawn "dmenu_run -nf \"#839496\" -nb \"#002b36\" -fn \"Droid Sans Mono-9\" -sf \"#dc322f\" -sb \"#073642\"")
    , ((modm .|. shiftMask, xK_p), spawn "sh /home/edran/.xmonad/dmenufm.sh")
    , ((modm, xK_u), focusUrgent)
    , ((modm, xK_g), goToSelected defaultGSConfig)
    , ((modm .|. shiftMask, xK_x), spawn "xkill")
    , ((modm, xK_s), spawn "/home/edran/.xmonad/switch_layout.sh")
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm .|. shiftMask, xK_Tab   ), windows W.focusUp  )
    , ((modm,               xK_k     ), windows W.focusDown)
    , ((modm,               xK_l     ), windows W.focusUp  )
    , ((modm,               xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_k     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_l     ), windows W.swapUp    )
    , ((modm,               xK_j     ), sendMessage Shrink)
    , ((modm,               xK_semicolon     ), sendMessage Expand)
    , ((modm .|. shiftMask, xK_t     ), workspacePrompt defaultXPConfig (windows . W.shift))
    , ((0, xK_Print), spawn "gnome-screenshot")
    , ((shiftMask, xK_Print), spawn "gnome-screenshot -i")
    , ((0, 0x1008FF12), spawn "amixer -q set Master toggle")
    , ((0, 0x1008FF11), spawn "amixer -q set Master 10%-")
    , ((0, 0x1008FF13), spawn "amixer -q set Master 10%+")
    ,  ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf++" --working-directory=~")
    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm .|. shiftMask, xK_n     ), refresh)
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    , ((modm .|. shiftMask, xK_t     ), workspacePrompt defaultXPConfig (windows . W.shift))
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
  ] ++

    [((m .|. modm, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
                                               -- ++ [xK_0,
                                               --     xK_a,
                                               --     xK_s,
                                               --     xK_d,
                                               --     xK_f,
                                               --     xK_b,
                                               --     xK_n,
                                               --     xK_m])
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
     | (key, sc) <- zip [xK_e, xK_w, xK_r] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myManagementHooks :: [ManageHook]
myManagementHooks = [
  resource =? "stalonetray" --> doIgnore
  , className =? "rdesktop" --> doFloat
  , className =? "Unity-2d-panel"    --> doIgnore
  , className =? "Unity-2d-launcher" --> doIgnore
  ]


{-
  Here we actually stitch together all the configuration settings
  and run xmonad. We also spawn an instance of xmobar and pipe
  content into it via the logHook.
-}

main = xmonad $ withUrgencyHook NoUrgencyHook $ gnomeConfig {
    focusedBorderColor = myFocusedBorderColor
  , normalBorderColor = myNormalBorderColor
  , terminal = myTerminal
  , borderWidth = myBorderWidth
  , keys = myKeys
  , layoutHook = myLayout
  , workspaces = myWorkspaces
  , modMask = myModMask
  , handleEventHook = fullscreenEventHook
  , startupHook = do
      setWMName "LG3D"
      windows $ W.greedyView startupWorkspace
      spawn "~/.xmonad/startup-hook"
  , manageHook = manageHook gnomeConfig
      <+> composeAll myManagementHooks
      <+> manageDocks
  }
--     `additionalKeys` myKeys
