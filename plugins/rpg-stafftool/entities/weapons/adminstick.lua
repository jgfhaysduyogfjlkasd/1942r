AddCSLuaFile()

local Plugin = Plugin or {}

if CLIENT then
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = true
end

net.Receive("AdminRequestInfo", function()
    local info = net.ReadString()

    if info == "entinfo" then
        local ent = net.ReadEntity()
        ent.reqCreator = net.ReadEntity()
        ent.receivedInfo = true
    end
end)

SWEP.Author = "Dave"
SWEP.PrintName = "STAFF Tool"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.IsAlwaysRaised = true 

SWEP.Spawnable = true
SWEP.AnimPrefix  = "stunstick"
SWEP.ViewModel = Model("models/weapons/v_stunstick.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false 
SWEP.Primary.Ammo = ""
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Deploy()
    local allowedUsergroups = {
        ["superadmin"] = true,
        ["RootManagement"] = true,
        ["CommunityManager"] = true,
        ["StaffManager"] = true,
        ["SupervisorAdministrator"] = true,
        ["HeadAdministrator"] = true,
        ["SeniorAdministrator"] = true,
        ["Administrator"] = true,
        ["SeniorModerator"] = true,
        ["Moderator"] = true,
        ["Helper"] = true
    }

    if SERVER then
        local owner = self:GetOwner()
        local ownerUsergroup = owner:IsPlayer() and owner:GetUserGroup() or ""

        if not allowedUsergroups[ownerUsergroup] then
            self:Remove()
        end
    end
end


function SWEP:PrimaryAttack()
    if SERVER then return end
    local target = IsValid(LocalPlayer().AdminStickTarget) and LocalPlayer().AdminStickTarget or LocalPlayer():GetEyeTrace().Entity

    if IsValid(target) and not target:IsPlayer() then
        if target:IsVehicle() and IsValid(target:GetDriver()) then
            target = target:GetDriver()
        end
    end

    if IsValid(target) and target:IsPlayer() or target:isDoor() or target:GetClass() == "nut_storage" then
        AdminStick:OpenAdminStickUI(false, target)
    end
end

function SWEP:SecondaryAttack()
    if SERVER then return end
    if not IsFirstTimePredicted() then return end
    local target = IsValid(LocalPlayer().AdminStickTarget) and LocalPlayer().AdminStickTarget or LocalPlayer():GetEyeTrace().Entity

    if IsValid(target) and not target:IsPlayer() then
        if target:IsVehicle() and IsValid(target:GetDriver()) then
            target = target:GetDriver()
        end
    end

    if IsValid(target) and target:IsPlayer() and target ~= LocalPlayer() then
        local cmd = target:IsFrozen() and "sam unfreeze" or "sam freeze"
        LocalPlayer():ConCommand(cmd .. " " .. target:SteamID())
    else
        nut.util.notify("You cannot freeze this!")
    end
end

function SWEP:DrawHUD()
    local x, y = ScrW() / 2, ScrH() / 2
    local target = IsValid(LocalPlayer().AdminStickTarget) and LocalPlayer().AdminStickTarget or LocalPlayer():GetEyeTrace().Entity
    local crossColor = Color(205, 67, 67)
    local information = {}

    if IsValid(target) then
        if not target:IsPlayer() then
            if target:IsVehicle() and IsValid(target:GetDriver()) then
                target = target:GetDriver()
            end
        end

        if target:IsPlayer() then
            crossColor = Color(255, 179, 0)

            information = {IsValid(LocalPlayer().AdminStickTarget) and "PLAYER SELECTED!" or "Player", "Steam Name: " .. (target.SteamName and target:SteamName() or target:Name()), "SteamID: " .. target:SteamID(), "Health: " .. target:Health(), "Armor: " .. target:Armor(), "Usergroup: " .. target:GetUserGroup()}

            if target:getChar() then
                local char = target:getChar()
                local faction = nut.faction.indices[target:Team()]

                table.Add(information, {"Character Name: " .. char:getName(), "Faction: " .. faction.uniqueID .. " (" .. faction.name .. ")"})
            else
                table.insert(information, "No Loaded Character")
            end
        elseif target:IsWorld() then
            if not LocalPlayer().NextRequestInfo or SysTime() >= LocalPlayer().NextRequestInfo then
                LocalPlayer().NextRequestInfo = SysTime() + 1
            end

            information = {"Entity", "Class: " .. target:GetClass(), "Model: " .. target:GetModel(), "Position: " .. tostring(target:GetPos()), "Angles: " .. tostring(target:GetAngles()), "Owner: " .. tostring(target:GetNWString("Creator_Nick", "NULL")), "EntityID: " .. target:EntIndex()}

            crossColor = Color(255, 255, 0)
        else
            if not LocalPlayer().NextRequestInfo or SysTime() >= LocalPlayer().NextRequestInfo then
                LocalPlayer().NextRequestInfo = SysTime() + 1
            end

            information = {"Entity", "Class: " .. target:GetClass(), "Model: " .. target:GetModel(), "Position: " .. tostring(target:GetPos()), "Angles: " .. tostring(target:GetAngles()), "Owner: " .. tostring(target:GetNWString("Creator_Nick", "NULL")), "EntityID: " .. target:EntIndex()}

            crossColor = Color(255, 255, 0)
        end
    end

    local length = 15
    local thickness = 2
    surface.SetDrawColor(crossColor)
    surface.DrawRect(x - length / 2, y - thickness / 2, length, thickness)
    surface.DrawRect(x - thickness / 2, y - length / 2, thickness, length)
    local startPosX, startPosY = ScrW() / 2 + 10, ScrH() / 2 + 10
    local font = "DebugFixed"
    local buffer = 0

    for k, v in pairs(information) do
        surface.SetFont(font)
        surface.SetTextColor(color_black)
        surface.SetTextPos(startPosX + 1, startPosY + buffer + 1)
        surface.DrawText(v)
        surface.SetTextColor(crossColor)
        surface.SetTextPos(startPosX, startPosY + buffer)
        surface.DrawText(v)
        local t_w, t_h = surface.GetTextSize(v)
        buffer = buffer + t_h
    end
end

function SWEP:Reload()
    if SERVER then return end
    if self.NextReload and self.NextReload > SysTime() then return end
    self.NextReload = SysTime() + 0.5
    local lookingAt = LocalPlayer():KeyDown(IN_SPEED) and LocalPlayer() or LocalPlayer():GetEyeTrace().Entity

    if IsValid(lookingAt) and not lookingAt:IsPlayer() then
        if lookingAt:IsVehicle() and IsValid(lookingAt:GetDriver()) then
            lookingAt = lookingAt:GetDriver()
        end
    end

    if IsValid(lookingAt) and lookingAt:IsPlayer() then
        LocalPlayer().AdminStickTarget = lookingAt
    else
        LocalPlayer().AdminStickTarget = nil
    end
end

function SWEP:DrawWorldModel()
    if self:GetOwner():IsAdmin() and self:GetOwner():GetMoveType() == MOVETYPE_NOCLIP then
        return
    end
    self:DrawModel()
end