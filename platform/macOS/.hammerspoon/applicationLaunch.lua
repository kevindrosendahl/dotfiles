-- set application launch hotkeys
function openApp(mods, key, app)
    hs.hotkey.bind(mods, key, function()
        hs.application.open(app)
    end)
end

openApp({"cmd"}, "return", "/Applications/iTerm.app")
openApp({"cmd", "shift"}, "D", "/System/Library/CoreServices/Finder.app")
openApp({"cmd", "shift"}, "C", "/Applications/Google Chrome.app")
openApp({"cmd", "shift"}, "I", "/Applications/IntelliJ IDEA.app")
openApp({"cmd", "shift"}, ",", "/Applications/Messages.app")
openApp({"cmd", "shift"}, "S", "/Applications/Slack.app")
openApp({"cmd", "shift"}, "X", "/Applications/Spotify.app")
