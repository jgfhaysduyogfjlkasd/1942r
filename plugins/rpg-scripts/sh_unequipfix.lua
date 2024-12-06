local PLUGIN = PLUGIN

PLUGIN.name = "Unequip Weapons"
PLUGIN.desc = "Unequip weapons on spawn"
PLUGIN.author = "Jeff"

function PLUGIN:PostPlayerLoadout(ply)
    print("Postplayerloadout")
    for _, equippedItem in pairs(ply:getChar():getInv():getItems()) do
            if equippedItem:getData("equip") then
                equippedItem:setData("equip", nil)
            end

            if equippedItem.class then
                ply:StripWeapon(equippedItem.class)
            end
        
    end
end