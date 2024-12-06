------------------------------------------------------------------------------------------
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Roleplay NPCs Base"
ENT.Author = "STEAM_0:1:176123778"
ENT.Contact = "@liliaplayer"
ENT.Category = "Leonheart NPCs"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.DrawEntityInfo = true
ENT.Model = "models/player/breen.mdl"
ENT.NPCName = ""
ENT.NPCDescription = ""
ENT.NPCType = ""
------------------------------------------------------------------------------------------
function ENT:setAnim()
    for k, v in ipairs(self:GetSequenceList()) do
        if v:lower():find("idle") and v ~= "idlenoise" then return self:ResetSequence(k) end
    end

    self:ResetSequence(4)
end
------------------------------------------------------------------------------------------