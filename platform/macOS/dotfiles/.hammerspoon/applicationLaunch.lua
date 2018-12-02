-- set application launch hotkeys
function openApp(mods, key, app)
    hs.hotkey.bind(mods, key, function()
        hs.application.open(app)
    end)
end

openApp({"cmd"}, "return", "/Applications/Alacritty.app")
openApp({"cmd", "shift"}, "D", "/System/Library/CoreServices/Finder.app")
openApp({"cmd", "shift"}, "C", "/Applications/Google Chrome.app")
openApp({"cmd", "shift"}, "I", "/Users/kevinrosendahl/Applications/JetBrains Toolbox/IntelliJ IDEA Ultimate.app")
openApp({"cmd", "shift"}, ",", "/Applications/Messages.app")
openApp({"cmd", "shift"}, "S", "/Applications/Slack.app")
openApp({"cmd", "shift"}, "X", "/Applications/Spotify.app")
