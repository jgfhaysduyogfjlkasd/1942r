PLUGIN.name = "community commands"
PLUGIN.author = "berko"
PLUGIN.desc = "adds cmds for my community"

-- Community Related Commands

nut.command.add("group", {
    syntax = "",
	onRun = function(client, arguments)
	 client:SendLua([[gui.OpenURL("")]])
	end
})

nut.command.add("forums", {
    syntax = "",
	onRun = function(client, arguments)
	 client:SendLua([[gui.OpenURL("")]])
	end
})

nut.command.add("content", {
    syntax = "",
	onRun = function(client, arguments)
	 client:SendLua([[gui.OpenURL("https://steamcommunity.com/workshop/filedetails/?id=3125439583")]])
	end
})

nut.command.add("rules", {
    syntax = "",
	onRun = function(client, arguments)
	 client:SendLua([[gui.OpenURL("")]])
	end
})

nut.command.add("guilded", {
    syntax = "",
	onRun = function(client, arguments)
	 client:SendLua([[gui.OpenURL("https://discord.gg/pNfNBJxBH7")]])
	end
})

-- ! Community Related Commands

local commandTriggerContent = "!content"
local commandTriggerGroup = "!group"
local commandTriggerForums = "!forums"
local commandTriggerRules = "!rules"
local commandTriggerGuilded = "!guilded"

hook.Add("PlayerSay", "AutoSayCommandContent", function(ply, text, teamChat)
    if string.lower(text) == string.lower(commandTriggerContent) then
        ply:ConCommand("say /content")
        return true
    end
end)

hook.Add("PlayerSay", "AutoSayCommandGroup", function(ply, text, teamChat)
    if string.lower(text) == string.lower(commandTriggerGroup) then
        ply:ConCommand("say /group")
        return true
    end
end)

hook.Add("PlayerSay", "AutoSayCommandForums", function(ply, text, teamChat)
    if string.lower(text) == string.lower(commandTriggerForums) then
        ply:ConCommand("say /forums")
        return true
    end
end)

hook.Add("PlayerSay", "AutoSayCommandRules", function(ply, text, teamChat)
    if string.lower(text) == string.lower(commandTriggerRules) then
        ply:ConCommand("say /rules")
        return true
    end
end)

hook.Add("PlayerSay", "AutoSayCommandGuilded", function(ply, text, teamChat)
    if string.lower(text) == string.lower(commandTriggerGuilded) then
        ply:ConCommand("say /guilded")
        return true
    end
end)