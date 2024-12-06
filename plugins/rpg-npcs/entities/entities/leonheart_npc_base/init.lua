------------------------------------------------------------------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
------------------------------------------------------------------------------------------
function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:DrawShadow(true)
    self:SetSolid(SOLID_OBB)
    self:PhysicsInit(SOLID_OBB)
    local physObj = self:GetPhysicsObject()
    if IsValid(physObj) then
        physObj:EnableMotion(false)
        physObj:Sleep()
    end

    timer.Simple(1, function() if IsValid(self) then self:setAnim() end end)
end

------------------------------------------------------------------------------------------
function ENT:OnTakeDamage()
    return false
end

------------------------------------------------------------------------------------------
function ENT:Use(client)
    local character = client:getChar()
    if not character then return end
    if not self.NPCType then
        client:notify("NPC not properly set! Returning!")
        return
    end

    netstream.Start(client, "ShowDialog", client, nut.plugin.list[self.NPCType].Settings, self)
end
------------------------------------------------------------------------------------------