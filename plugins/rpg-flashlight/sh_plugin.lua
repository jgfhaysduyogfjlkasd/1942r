PLUGIN.name = "Flashlight"
PLUGIN.author = "Lenno"
PLUGIN.desc = "Flashlight as an item"

function PLUGIN:PlayerSwitchFlashlight(client, state)
	local character = client:getChar()

	if (!character or !character:getInv()) then
		return false
	end

	if (character:getInv():hasItem("flashlight")) then
		return true
	end
end