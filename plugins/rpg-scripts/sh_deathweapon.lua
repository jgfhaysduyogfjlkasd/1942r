local PLUGIN = PLUGIN

PLUGIN.name = "Weapon Drop on Death"
PLUGIN.author = "Lenno"
PLUGIN.desc = "Weapon drop"

function PLUGIN:PlayerDeath( client )
    local items = client:getChar():getInv():getItems()
    for k, item in pairs( items ) do
        if item.isWeapon then
            if item:getData( "equip" ) then
                client.lostWep = {
                    uniqueID = item.uniqueID,
                    name = item.name
                }
				item:remove()
                print("DEBUG: " .. client:Nick() .. "'s lost weapon set to: " .. client.lostWep.name)  -- DEBUG
                print("DEBUG: " .. client:Nick() .. "'s lost weapon set to: " .. client.lostWep.uniqueID)  -- DEBUG
				client:notify("All weapons equiped have been lost.")
            end
        end
    end
end