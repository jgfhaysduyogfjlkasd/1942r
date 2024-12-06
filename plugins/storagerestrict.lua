-- "gamemodes\\1942rp\\plugins\\storagerestrict.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
PLUGIN.name = "Storage Restrictor"
PLUGIN.desc = "Restricts access to ns storage boxes"
PLUGIN.author = "Barata"

nut.flag.add("s", "Access to spawning storage containers")

hook.Add("CanPlayerSpawnStorage", "StorageRestrictor", function(ply, model, ent)
	-- If the player is an superadmin allow it.
	if (ply:IsSuperAdmin()) then return true end

	-- If we have s flags allow it.
	if ply:getChar():getFlags():find("s") then return true end

	-- We explicitly say no here since this is a restrict plugin.
	return false
end)
