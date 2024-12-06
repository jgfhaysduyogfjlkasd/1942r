local PLUGIN = PLUGIN

PLUGIN.name = "Player Management Tool"
PLUGIN.author = "Dave & Lenno"

PLUGIN.usergroups = {
    "superadmin",
    "Helper",
}
nut.util.include("cl_plugin.lua")

hook.Add("InitPostEntity","AdminStickAlwaysRaise",function()
end)

if SERVER then
    util.AddNetworkString("AS_ClearDecals")
    
    hook.Add( "PostPlayerLoadout", "Check Ranks", function(ply)
        if table.HasValue(PLUGIN.usergroups, ply:GetUserGroup()) then
            ply:Give("adminstick")
        end
    end)

    net.Receive("AS_ClearDecals", function(l, ply)
        if table.HasValue(PLUGIN.usergroups, ply:GetUserGroup()) then
            for k, v in ipairs(player.GetHumans()) do 
                v:ConCommand("r_cleardecals") 
            end
        end
    end)
end

nut.command.add("charpk",{
    syntax = "[character name]",
    onCheckAccess = function(client)
        return table.HasValue(PLUGIN.usergroups, client:GetUserGroup())
    end,
    onRun = function(client, args)
        local target = nut.command.findPlayer(client, args[1])
            
        if IsValid(target) and target:getChar() then
            local targetchar = target:getChar()
            
            if !targetchar:getData("permakilled") then
                targetchar:setData("permakilled", true)
                target:Spawn()
                client:notify("You've perma killed " .. target:Name()) 
            end
        end
    end
})