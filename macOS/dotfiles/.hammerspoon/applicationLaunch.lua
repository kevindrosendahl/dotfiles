local home = os.getenv("HOME") or ""

-- set application launch hotkeys
function openApp(mods, key, app)
    hs.hotkey.bind(mods, key, function()
        hs.application.open(app)
    end)
end

openApp({"cmd"}, "return", "/Applications/Ghostty.app")
openApp({"cmd", "shift"}, ";", "/System/Library/CoreServices/Finder.app")
openApp({"cmd", "shift"}, "C", "/Applications/Google Chrome.app")
openApp({"cmd", "shift"}, "I", home .. "/Applications/IntelliJ IDEA Ultimate.app")
openApp({"cmd", "shift"}, ",", "/System/Applications/Messages.app")
openApp({"cmd", "shift"}, "S", "/Applications/Slack.app")
openApp({"cmd", "shift"}, "X", "/Applications/Spotify.app")
openApp({"cmd", "shift"}, "B", "/Applications/zoom.us.app")
openApp({"cmd", "shift"}, "D", "/Applications/Obsidian.app")
-- openApp({"cmd", "shift"}, "E", "/Applications/Todoist.app")

-- focus Ghostty and switch its tmux client to a session + pane
function focusGhosttyTmux(mods, key, session, window, pane)
    hs.hotkey.bind(mods, key, function()
        local tmuxBin = "/opt/homebrew/bin/tmux"
        local sessionExact = "=" .. session
        local sessionQuoted = string.format("%q", sessionExact)
        local targetQuoted = string.format("%q", string.format("=%s:%d.%d", session, window, pane))
        local tmuxQuoted = string.format("%q", tmuxBin)
        local script = string.format([[
            tmux=%s
            session=%s
            target=%s
            "$tmux" has-session -t "$session" 2>/dev/null || exit 0
            client=$("$tmux" list-clients -F '#{client_activity} #{client_name}' | sort -nr | head -n 1 | awk '{print $2}')
            if [ -n "$client" ]; then
                "$tmux" switch-client -c "$client" -t "$target"
            fi
        ]],
            tmuxQuoted,
            sessionQuoted,
            targetQuoted
        )

        local task = hs.task.new("/bin/zsh", function(exitCode, stdOut, stdErr)
            if exitCode ~= 0 or (stdErr and #stdErr > 0) then
                print(string.format("tmux switch error (exit %d): %s", exitCode, stdErr or ""))
            end
        end, {"-lc", script})
        if task then
            task:start()
        end

        hs.application.open("/Applications/Ghostty.app")
    end)
end

focusGhosttyTmux({"cmd", "shift"}, "E", "amux-dashboard", 1, 0)
