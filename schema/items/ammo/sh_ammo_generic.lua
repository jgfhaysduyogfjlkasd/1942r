ITEM.name = "Box of Ammunition"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.ammoAmount = 60 -- Amount of the ammo
ITEM.price = 50
ITEM.desc = "Ammunition box that contains sixty bullets.\nUse items with the gun you want loaded out."
ITEM.category = "Black Market"
ITEM.flag = "v"

local ignoreTable = {
        "weapon_crowbar",
        "weapon_stunstick",
        "weapon_physcannon",
        "weapon_physgun",
        "weapon_bugbait",
        "gmod_tool",
        "gmod_camera",
        "weapon_extinguisher",
        "swep_flamethrower",
        "weapon_gascan",
        "weapon_midascannon",
        "riotshield",
        "spiderman_swep",
        "m_cyclonetrap",
        "m_electrobolt",
        "m_incinerate",
        "m_insectswarm",
        "m_winterblast",
        "bb_css_knife",
        "weapon_axe",
        "weapon_bat",
        "weapon_keyboard",
        "weapon_shovel",
        "weapon_sledgehammer",
        "weapon_fists",
        "cutter",
        "weapon_glowstick",
        "weapon_glowstick_blu",
        "weapon_glowstick_lblu",
        "weapon_glowstick_rng",
        "weapon_glowstick_pnk",
        "weapon_glowstick_red",
        "weapon_glowstick_wht",
        "weapon_glowstick_ylw",
        "m9k_ied_detonator",
        "nut_hands",
        "nut_keys",
        "super_aug",
        "doi_atow_bayonetde",
        "doi_atow_bayonetcw",
        "doi_atow_bayonetus",
        "doi_atow_knifeus",
        "doi_atow_etoolde",
        "doi_atow_etoolus",
        "adminstick",
        "cw_flash_grenade",
        "cw_frag_grenade",
        "cw_smoke_grenade",
        "doi_atow_binocularscw",
        "doi_atow_binocularsde",
        "doi_atow_binocularsus",
        "doi_atow_etoolcw"
}

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		draw.SimpleText(item.ammoAmount, "DermaDefault", w , h - 5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
	end
end

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.

ITEM.functions.use = { -- Sorry, for name order.
	name = "Load",
	tip = "useTip",
	icon = "icon16/add.png",
	onRun = function(item)
		local client = item.player
		
        weapon = client:GetActiveWeapon()
 
        if !IsValid(weapon) then return false end
       
        for p, q in pairs(ignoreTable) do
                if weapon:GetClass() == q then
                        client:notify("This weapon may not be resupplied.") -- Notifies the player in the top right corner.
                        client:EmitSound("Player.DenyWeaponSelection")
                return false end
        end

        client:GiveAmmo( item.ammoAmount ,  weapon:GetPrimaryAmmoType(), false)
                client:notify("You picked up some ammo.") -- Notifies the player in the top right corner.
		client:EmitSound("items/ammo_pickup.wav", 110)
		
		return true
	end,
}