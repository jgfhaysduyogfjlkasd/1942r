include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
function ENT:Initialize()
    self:SetModel("models/hunter/plates/plate3x6.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetMaterial("models/props_pipes/GutterMetal01a", false)
    self.InUse = false
    self.Cooldown = 0
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then phys:Wake() end
end

function ENT:Use(activator, caller)
    net.Start("garage_ui")
    net.WriteEntity(self)
    net.Send(activator)
end

function ENT:Think()
end

function ENT:Touch(ent)
    if ent:IsVehicle() then
        self.InUse = true
    else
        self.InUse = false
    end
end