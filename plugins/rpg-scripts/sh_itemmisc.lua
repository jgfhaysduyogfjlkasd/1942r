PLUGIN.name = "Item Misc"
PLUGIN.desc = "Item Clean up, logging and general anti-crash."
PLUGIN.author = "Dave"

local resetTime = (60 * 240) -- 1 Hour

if (SERVER) then

    function PLUGIN:InitializedPlugins()

        timer.Create("clearWorldItemsWarning", resetTime - (60 * 10), 0, function()
            for i, v in pairs(player.GetAll()) do
                v:ChatPrint("[ WARNING ]  Nutscript items will be cleared in 10 minutes!")
            end
        end)

        timer.Create("clearWorldItemsWarning", resetTime - (60 * 5), 0, function()
            for i, v in pairs(player.GetAll()) do
                v:ChatPrint("[ WARNING ]  Nutscript items will be cleared in 5 minutes!")
            end
        end)

        timer.Create("clearWorldItemsWarningFinal", resetTime - 60, 0, function()
            for i, v in pairs(player.GetAll()) do
                v:ChatPrint("[ WARNING ]  Nutscript items will be cleared in 60 Seconds!")
            end
        end)

        timer.Create("clearWorldItemsWarningFinal", resetTime - 10, 0, function()
            for i, v in pairs(player.GetAll()) do
                v:ChatPrint("[ WARNING ]  Nutscript items will be cleared in 10 Seconds! Get ready!")
            end
        end)

        timer.Create("clearWorldItems", resetTime, 0, function()
            for i, v in pairs(ents.FindByClass("nut_item")) do
                v:Remove()
            end
        end)
    end
end

function PLUGIN:EntityTakeDamage(target, dmginfo)

    if (target:IsPlayer()) then
        local inflictor = dmginfo:GetInflictor()

        if (IsValid(inflictor) and (inflictor:GetClass() == "nut_item")) then
            if (not IsValid(target:GetVehicle())) then
                local damage = dmginfo:GetDamage()
                dmginfo:ScaleDamage(0)

                if (damage > 5) then
                    if (not IsValid(target.nutRagdoll)) then
                        target:setRagdolled(true, 2)
                    end
                end
            end
        end

        if (IsValid(inflictor) and ((inflictor:GetClass() == "prop_physics") or (inflictor:GetClass() == "nut_storage"))) then
            if (not IsValid(target:GetVehicle())) then
                local damage = dmginfo:GetDamage()
                dmginfo:ScaleDamage(0.1)

                if (damage > 5) then
                    if (not IsValid(target.nutRagdoll)) then
                        target:setRagdolled(true, 2)
                        local ragdoll = target.nutRagdoll
                        local num = ragdoll:GetPhysicsObjectCount() - 1
                        local v = target:GetVelocity()

                        if (dmginfo) then
                            v = v + (dmginfo:GetDamageForce() / 20)
                        end

                        for i = 0, num do
                            local bone = ragdoll:GetPhysicsObjectNum(i)

                            if IsValid(bone) then
                                local bp, ba = target:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))

                                if bp and ba then
                                    bone:SetPos(bp)
                                    bone:SetAngles(ba)
                                end

                                bone:SetVelocity(v)
                            end
                        end
                    end
                end
            end
        end
    end
end

if CLIENT then
    NUT_CVAR_ITEMESP = CreateClientConVar("nut_obsitemesp", 1, true, true)

    function PLUGIN:HUDPaint()
        local client = LocalPlayer()

        if (client:IsAdmin() and client:GetMoveType() == MOVETYPE_NOCLIP and not client:InVehicle() and NUT_CVAR_ADMINESP:GetBool() and NUT_CVAR_ITEMESP:GetBool()) then
            local sx, sy = surface.ScreenWidth(), surface.ScreenHeight()

            for k, v in ipairs(ents.GetAll()) do
                if (v:GetClass() == "nut_item") then
                    local scrPos = v:GetPos():ToScreen()
                    local marginx, marginy = sy * .1, sy * .1
                    local x, y = math.Clamp(scrPos.x, marginx, sx - marginx), math.Clamp(scrPos.y, marginy, sy - marginy)
                    local distance = client:GetPos():Distance(v:GetPos())
                    local factor = 1 - math.Clamp(distance / 1024, 0, 1)
                    local size = math.max(10, 32 * factor)
                    local alpha = math.Clamp(255 * factor, 80, 255)
                    surface.SetDrawColor(255, 83, 40, 222)
                    surface.DrawRect(x - size / 2, y - size / 2, size, size)
                    local name = "invalid"

                    if (v.getItemTable and v:getItemTable()) then
                        name = v:getItemTable().name
                    end

                    nut.util.drawText("item: " .. name, x, y - size, ColorAlpha(Color(205, 205, 205, 255), alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
                end
            end
        end
    end

    function PLUGIN:SetupQuickMenu(menu)
        if (LocalPlayer():IsAdmin() or LocalPlayer():IsUserGroup("operator")) then
            local buttonItem = menu:addCheck("Toggle Item ESP", function(panel, state)
                if (state) then
                    RunConsoleCommand("nut_obsitemesp", "1")
                else
                    RunConsoleCommand("nut_obsitemesp", "0")
                end
            end, NUT_CVAR_ITEMESP:GetBool())

            menu:addSpacer()
        end
    end
end

nut.command.add("cleanitems", {
    adminOnly = true,
    onRun = function(client, arguments)
        for k, v in pairs(ents.FindByClass("nut_item")) do
            v:Remove()
        end

        client:notify("Dropped items have been removed from the map.")
    end
})



timer.Create("itemcleanup", 8, 0, function()
    if table.Count(ents.FindByClass("nut_item")) >= 25 then
        for k, v in pairs(player.GetAll()) do
            if v:IsAdmin() then
                print("[ITEM LOG] 25+ Items are currently dropped - Be cautious.")
                v:notify("ITEMMISC: Many items are dropped! - 25 ITEMS (Be cautious and look around)")
            end
        end

        if table.Count(ents.FindByClass("nut_item")) >= 40 then
            for k, v in pairs(player.GetAll()) do
                if v:IsAdmin() then
                    print("[ITEM LOG] 40+ Items are currently dropped - Be aware of possible crashing.")
                    v:notify("ITEMMISC: Too many items are dropped! - 40+ ITEMS (do /cleanitems and make sure you warn everyone about clean up!")
                end
            end
        end
    end
end)