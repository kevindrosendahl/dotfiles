enableAutoClick = false
-- Seconds to delay before next click. 0.001 works OK.
speedDelay = 0.03

function mouseRightClick()
    -- Run right mouseclick
    hs.eventtap.leftClick(hs.mouse.getAbsolutePosition(), 1)
end

function isAutoClickerEnabled()
    return enableAutoClick
end

function setupClicker()
    -- Set continuous run to true
    enableAutoClick = true
    print("Enabled autoclicker")

    myTimer = hs.timer.doWhile(isAutoClickerEnabled, mouseRightClick, speedDelay)
    
end

function stopClicker()
    -- Stop autoclicker
    enableAutoClick = false
end

hs.hotkey.bind({"cmd","alt"}, "B", setupClicker)
hs.hotkey.bind({"cmd","alt"}, "N", stopClicker)
