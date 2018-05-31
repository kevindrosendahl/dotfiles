--------------
-- defaults --
--------------

-- set window animation duration default to 0
hs.window.animationDuration = 0

------------------
-- applications --
------------------

-- set application launch hotkeys
function openApp(mods, key, app)
    hs.hotkey.bind(mods, key, function()
        hs.application.open(app)
    end)
end

openApp({"cmd"}, "return", "/Applications/iTerm.app")
openApp({"cmd", "shift"}, "C", "/Applications/Google Chrome.app")
openApp({"cmd", "shift"}, "I", "/Applications/IntelliJ IDEA.app")
openApp({"cmd", "shift"}, ".", "/Applications/Messages.app")
openApp({"cmd", "shift"}, "S", "/Applications/Slack.app")
openApp({"cmd", "shift"}, "P", "/Applications/Spotify.app")

-------------
-- windows --
-------------

-- set window resizing hotkeys
function resizeWindow(mods, key, resizeFn)
    hs.hotkey.bind(mods, key, function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        resizeFn(f, max)
        win:setFrame(f)
    end)
end

-- full

-- cmd + shift + f -> full screen
resizeWindow({"cmd", "shift"}, "F", function(f, max)
    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
end)

-- half

-- cmd + shift + h -> left half
resizeWindow({"cmd", "shift"}, "H", function(f, max)
    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
end)

-- cmd + shift + l -> right half
resizeWindow({"cmd", "shift"}, "L", function(f, max)
    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
end)

-- cmd + shift + k -> top half
resizeWindow({"cmd", "shift"}, "K", function(f, max)
    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h / 2
end)

-- cmd + shift + j -> bottom half
resizeWindow({"cmd", "shift"}, "J", function(f, max)
    f.x = max.x
    f.y = max.y + (max.h / 2)
    f.w = max.w
    f.h = max.h / 2
end)

-- two thirds

-- ctrl + shift + h -> left two thirds
resizeWindow({"ctrl", "shift"}, "H", function(f, max)
    f.x = max.x
    f.y = max.y
    f.w = 2 * max.w / 3
    f.h = max.h
end)

-- ctrl + shift + l -> right two thirds
resizeWindow({"ctrl", "shift"}, "L", function(f, max)
    f.x = max.x + (max.w / 3)
    f.y = max.y
    f.w = 2 * max.w / 3
    f.h = max.h
end)

-- thirds

-- alt + shift + h -> left third
resizeWindow({"alt", "shift"}, "H", function(f, max)
    f.x = max.x
    f.y = max.y
    f.w = max.w / 3
    f.h = max.h
end)

-- alt + shift + f -> middle third
resizeWindow({"alt", "shift"}, "f", function(f, max)
    f.x = max.x + (max.w / 3)
    f.y = max.y
    f.w = max.w / 3
    f.h = max.h
end)

-- alt + shift + l -> right third
resizeWindow({"alt", "shift"}, "L", function(f, max)
    f.x = max.x + (2 * max.w / 3)
    f.y = max.y
    f.w = max.w / 3
    f.h = max.h
end)

-------------
-- screens --
-------------

function moveWindowScreen(mods, key, next)
    hs.hotkey.bind(mods, key, function()
        local win = hs.window.focusedWindow()

        if next then
            win:moveOneScreenEast()
        else
            win:moveOneScreenWest()
        end
    end)
end

moveWindowScreen({"cmd", "shift"}, "right", true)
moveWindowScreen({"cmd", "shift"}, "left", false)
