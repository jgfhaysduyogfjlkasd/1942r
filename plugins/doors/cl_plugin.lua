--[[
	This script is part of Black Mesa Roleplay schema by Zoephix and
	exclusively made for LimeFruit (limefruit.net)

	© Copyright 2021: Zoephix. do not share, use, re-distribute or modify
	without written permission from Zoephix.
--]]

ACCESS_LABELS = {}
ACCESS_LABELS[DOOR_OWNER] = "owner"
ACCESS_LABELS[DOOR_TENANT] = "tenant"
ACCESS_LABELS[DOOR_GUEST] = "guest"
ACCESS_LABELS[DOOR_NONE] = "none"

function PLUGIN:ShouldDrawEntityInfo(entity)
	if (entity.isDoor(entity) and !entity.getNetVar(entity, "disabled")) then
		return true
	end
end

local toScreen = FindMetaTable("Vector").ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get
local teamGetColor = team.GetColor

function PLUGIN:DrawEntityInfo(entity, alpha)
	if (entity.isDoor(entity) and !entity:getNetVar("hidden") and hook.Run("CanDrawDoorInfo") != false) then
		local position = toScreen(entity.LocalToWorld(entity, entity.OBBCenter(entity)))
		local x, y = position.x, position.y
		local owner = entity.GetDTEntity(entity, 0)
		local name = entity.getNetVar(entity, "title", entity.getNetVar(entity, "name", IsValid(owner) and L"dTitleOwned" or L"dTitle"))
		local faction = entity.getNetVar(entity, "faction")
		local class = entity.getNetVar(entity, "class")
		local color

		if (faction) then
			color = teamGetColor(faction)
		else
			color = configGet("color")
		end

		local classData
		if (class) then
			classData = nut.class.list[class]
			
			if (classData) then
				color = classData.color
			else
				color = configGet("color")
			end
		else
			color = configGet("color")
		end

		if (ApartmentSystem && entity:IsApartment()) then
			if (ApartmentSystem.Apartments[entity.Apartment]) then
				name = ApartmentSystem.Apartments[entity.Apartment].Name or name
			end
		end
		drawText(name, x, y, colorAlpha(color, alpha), 1, 1)

		if (ApartmentSystem && entity:IsApartment()) then
			local name = "a private citizen"
			local aptData = ApartmentSystem.Apartments[entity.Apartment]
			if (aptData) then
				if (aptData.Owner != "") then
					name = aptData.OwnerLastName
				else
					name = nil
				end
			end
			if (name) then 
				drawText("This property is owned by "..name..".", x, y + 16, colorAlpha(color_white, alpha), 1, 1)
			else
				drawText("This property isn't owned by anyone.", x, y + 16, colorAlpha(color_white, alpha), 1, 1)
			end
		elseif (IsValid(owner)) then
			drawText(L("dOwnedBy", owner.Name(owner)), x, y + 16, colorAlpha(color_white, alpha), 1, 1)
		elseif (faction) then
			if (istable(faction)) then
				-- local infoTable = {}
				local infoText = ""
				
				local space = 3
				local total = 0

				for k, v in pairs(faction) do
					total = total + 1
				end

				if total > 1 then
					infoText =  "This door is owned by" .. "\n"

					drawText(infoText, x, y + (16 * 2), colorAlpha(color_white, alpha), 1, 1)
				end

				for k, v in pairs(faction) do
					infoText = total > 1 and nut.faction.indices[v].name .. "\n" or L("dOwnedBy", L2(nut.faction.indices[v].name) or nut.faction.indices[v].name) .. "\n"

					if total <= 1 then
						drawText(infoText, x, y + (16 * 2), colorAlpha(nut.faction.indices[v].color, alpha), 1, 1)
					else
						drawText(infoText, x, y + (16 * space), colorAlpha(nut.faction.indices[v].color, alpha), 1, 1)
					end
					
					space = space + 1
				end
			else
				local info = nut.faction.indices[faction]
				
				if (info) then
					drawText(L("dOwnedBy", L2(info.name) or info.name), x, y + 16, colorAlpha(color_white, alpha), 1, 1)
				end
			end
		elseif (class) then
			if (classData) then
				drawText(L("dOwnedBy", L2(classData.name) or classData.name), x, y + 16, colorAlpha(color_white, alpha), 1, 1)
			end
		else
			drawText(entity.getNetVar(entity, "noSell") and L"dIsNotOwnable" or L"dIsOwnable", x, y + 16, colorAlpha(color_white, alpha), 1, 1)
		end
	end
end

netstream.Hook("doorMenu", function(entity, access, door2)
	if (IsValid(nut.gui.door)) then
		return nut.gui.door:Remove()
	end

	if (IsValid(entity)) then
		nut.gui.door = vgui.Create("nutDoorMenu")
		nut.gui.door:setDoor(entity, access, door2)
	end
end)

netstream.Hook("doorPerm", function(door, client, access)
	local panel = door.nutPanel

	if (IsValid(panel) and IsValid(client)) then
		panel.access[client] = access

		for k, v in ipairs(panel.access:GetLines()) do
			if (v.player == client) then
				v:SetColumnText(2, L(ACCESS_LABELS[access or 0]))

				return
			end
		end
	end
end)
