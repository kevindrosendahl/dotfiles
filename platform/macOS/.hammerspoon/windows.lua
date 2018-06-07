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
