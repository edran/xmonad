--
-- xmonad config file for 
--

import Solarized
import XMonad
import Data.Monoid
import System.Exit
import XMonad.Actions.GridSelect
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Config.Gnome
import XMonad.Config.Desktop
import XMonad.Layout.Tabbed
import XMonad.Layout.ShowWName    -- for showing workspace when switching
import XMonad.Layout.NoBorders    -- for no border in fullscreen window
import XMonad.Hooks.ManageHelpers -- for fullscreen support
import XMonad.Prompt.Workspace
import XMonad.Prompt
import XMonad.Layout.MagicFocus
import XMonad.Layout.Named

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "mate-terminal"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False -- True

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--

--myWorkspaces    = ["system","web","irc","4","5","files","7","8","9","10","code","testing","13","14","15","16","17"]

myWorkspaces = ["1-Main", "2-Temp", "3-Work", "4-Misc", "5-IRC", "6-Media", "7", "8", "9"]

-- Specify a workspace(s) to use focusFollowsMouse on (such as for use with gimp):
-- We will disable follow-mouse on all but the last:
-- followEventHook = followOnlyIf $ disableFollowOnWS allButLastWS
--    where allButLastWS = init allWS
--          allWS        = workspaces gnomeConfig

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = solarizedBase01 -- "#000000"
myFocusedBorderColor = solarizedRed    -- "#FF0000"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf++" --working-directory=~")

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run -nf \"#6D8E29\" -nb \"#272822\" -fn \"Ubuntu-10\" -sf \"#a6e22e\" -sb \"#272822\"")
    , ((modm .|. shiftMask, xK_p     ), spawn "dmenu_run -nf \"#6D8E29\" -nb \"#272822\" -fn \"Ubuntu-10\" -sf \"#a6e22e\" -sb \"#272822\" -b")


    -- launch a script to rotate the screen
    -- , ((modm,               xK_slash ), spawn "sh /home/kit/.scripts/toggle_rotate.sh"  )

    -- launch gridselect
    , ((modm, xK_g), goToSelected defaultGSConfig)

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

    -- run xkill to terminate unruly processes
    , ((modm .|. shiftMask, xK_x     ), spawn "xkill")

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm .|. shiftMask, xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm .|. shiftMask, xK_Tab   ), windows W.focusUp  )

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Prompt for a workspace
    , ((modm .|. shiftMask, xK_t     ), workspacePrompt defaultXPConfig (windows . W.shift))

    -- Lock the screen
    --, ((modm .|. shiftMask, xK_l     ), spawn "mate-screensaver-command -l")

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
     , ((modm              , xK_bracketleft), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run printscreen
    , ((0, xK_Print), spawn "mate-screenshot")

    -- Run printscreen in interactive mode
    , ((shiftMask, xK_Print), spawn "mate-screenshot -i")]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
     | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9])
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

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--

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
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- defaultConfig as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

myTabConfig = defaultTheme { fontName = "xft: Ubuntu-10"
                           -- , activeColor         = "#272822" -- "#272822"
                           -- , inactiveColor       = "#272822" -- "#272822"
                           -- , urgentColor         = "#C4BE89" -- "#C4BE89"
                           -- , activeBorderColor   = "#282923" -- "#282923"
                           -- , inactiveBorderColor = "#282923" -- "#282923"
                           -- , urgentBorderColor   = "#C4BE89" -- "#C4BE89"
                           -- , activeTextColor     = "#A6E22E" -- "#A6E22E"
                           -- , inactiveTextColor   = "#6D8E29" -- "#6D8E290"
                           -- , urgentTextColor     = "#6D8E29" -- "#6D8E29"
                           , decoWidth           = 100
                           , decoHeight          = 17
                           , windowTitleAddons   = []
                           , windowTitleIcons    = []
}

preLayout = avoidStruts $ desktopLayoutModifiers 
            $   tiled 
            ||| Mirror tiled 
            ||| mfocus  -- TODO: Find a way to use this with followmouse = true
            ||| (tabbed shrinkText myTabConfig) 
            ||| Full

  where
    
    -- Magic Focus
    mfocus = named "Magic Focus" (magicFocus (Mirror tiled))
    
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 2/3

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-- Avoid borders when fullscreen
myLayout = smartBorders (preLayout)

-- ###

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--

fullManageHook = composeAll [
                isFullscreen --> doFullFloat
               ]

myManageHook = fullManageHook <+> manageHook gnomeConfig <+> manageDocks
               
------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH event handling to your custom event hooks by
-- combining them with ewmhDesktopsEventHook.
--
myHandleEventHook = fullscreenEventHook -- <+> promoteWarp -- TODO: See magicFocus layout

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add EWMH logHook actions to your custom log hook by
-- combining it with ewmhDesktopsLogHook.
--
--myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--
-- * NOTE: EwmhDesktops users should use the 'ewmh' function from
-- XMonad.Hooks.EwmhDesktops to modify their defaultConfig as a whole.
-- It will add initialization of EWMH support to your custom startup
-- hook by combining it with ewmhDesktopsStartup.
--
myStartupHook = setWMName "LG3D" -- Makes Java run

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
--main = xmonad defaults
main = xmonad defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = gnomeConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = showWName myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myHandleEventHook,
        startupHook        = myStartupHook
        {-logHook          = myLogHook, -} 
    }



