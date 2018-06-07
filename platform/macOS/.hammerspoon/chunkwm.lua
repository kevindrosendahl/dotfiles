-- call chunkc command
function chunkcCmd(mods, key, cmd)
    hs.hotkey.bind(mods, key, function()
        os.execute("/usr/local/bin/chunkc " .. cmd)
    end)
end

-- fullscreen the focused container
chunkcCmd({"alt"}, "F", "tiling::window --toggle fullscreen")

-- switch layout types
chunkcCmd({"alt"}, "E", "tiling::desktop --layout bsp")
chunkcCmd({"alt"}, "S", "tiling::desktop --layout monocle")
chunkcCmd({"alt"}, "space", "tiling::window --toggle float")

-- change focus
chunkcCmd({"alt"}, "H", "tiling::window --focus west")
chunkcCmd({"alt"}, "J", "tiling::window --focus south")
chunkcCmd({"alt"}, "K", "tiling::window --focus north")
chunkcCmd({"alt"}, "L", "tiling::window --focus east")
chunkcCmd({"alt"}, "P", "tiling::window --focus prev")
chunkcCmd({"alt"}, "N", "tiling::window --focus next")

-- move window
chunkcCmd({"cmd", "shift"}, "H", "tiling::window --warp west")
chunkcCmd({"cmd", "shift"}, "J", "tiling::window --warp south")
chunkcCmd({"cmd", "shift"}, "K", "tiling::window --warp north")
chunkcCmd({"cmd", "shift"}, "L", "tiling::window --warp east")

-- rotate windows
chunkcCmd({"cmd", "shift"}, "R", "tiling::desktop --rotate 270")

-- move to workspace
chunkcCmd({"cmd", "shift"}, "l", "tiling::window --send-to-desktop $(/usr/local/bin/chunkc get _last_active_desktop)")
chunkcCmd({"cmd", "shift"}, "p", "tiling::window --send-to-desktop prev")
chunkcCmd({"cmd", "shift"}, "n", "tiling::window --send-to-desktop next")
chunkcCmd({"cmd", "shift"}, "1", "tiling::window --send-to-desktop 1")
chunkcCmd({"cmd", "shift"}, "2", "tiling::window --send-to-desktop 2")
chunkcCmd({"cmd", "shift"}, "3", "tiling::window --send-to-desktop 3")
chunkcCmd({"cmd", "shift"}, "4", "tiling::window --send-to-desktop 4")
chunkcCmd({"cmd", "shift"}, "5", "tiling::window --send-to-desktop 5")
chunkcCmd({"cmd", "shift"}, "6", "tiling::window --send-to-desktop 6")
