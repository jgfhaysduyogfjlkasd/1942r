local PLUGIN = PLUGIN
PLUGIN.name = "Auto Flags"
PLUGIN.author = "Jeff The Cool Guy"
PLUGIN.desc = "Add support for rank-based flags."

PLUGIN.donatorGroups = {
	["NHC"] = "pet"
}

function PLUGIN:PlayerLoadedChar(client, char)
	local usergroup = client:GetUserGroup()

	local group = PLUGIN.donatorGroups[usergroup]
	if(group and not char:hasFlags(group)) then
		print(group)
		char:giveFlags(group)
	end
	if char:getFaction() == FACTION_STAFF and not char:hasFlags("pet") then
		char:giveFlags("pet")
	end

	if client:getNutData("petDonate") == true and not char:hasFlags("pet") and !client:getNutData("petBlacklisted") then
		char:giveFlags("pet")
	end
	timer.Simple(0.5, function()
		if client:getNutData("petBlacklisted") and char:hasFlags("pet") then
			char:takeFlags("pet")
		end
	end)
end



--[[
local PLUGIN = PLUGIN
PLUGIN.name = "Auto Flags"
PLUGIN.author = "Nutter"
PLUGIN.desc = "Add support for rank-based flags."

PLUGIN.donatorGroups = {
	["donator"] = "pet"
}

function PLUGIN:PlayerLoadedChar(client, char)
	print("loaded")
	local usergroup = client:GetUserGroup()

	local group = PLUGIN.donatorGroups[usergroup]
	if(group && !char:hasFlags(group)) then
		print(group)
		char:giveFlags(group)
	end
end
--]]