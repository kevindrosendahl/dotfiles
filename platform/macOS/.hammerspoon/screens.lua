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
