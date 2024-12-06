local PLUGIN = PLUGIN

local owner = {
	superadmin = true,
	communitymanager = true,
}

local globalRanks = {
	superadmin = true,
	communitymanager = true,
	superadministrator = true,
	senioradministrator = true,
	administrator = true,
	moderator = true,
	eventmanager = true,
	eventstaff = true,
}

local gmRanks = {
	superadmin = true,
	communitymanager = true,
	superadministrator = true,
	senioradministrator = true,
	administrator = true,
	moderator = true,
	gamemaster = true,
	trusted = true,
	eventmanager = true,
	eventstaff = true,
}

local trustedRanks = {
	superadmin = true,
	communitymanager = true,
	superadministrator = true,
	senioradministrator = true,
	administrator = true,
	moderator = true,
	trusted = true,
	eventmanager = true,
	eventstaff = true,
}

local adminRanks = {
	superadmin = true,
	communitymanager = true,
	superadministrator = true,
	senioradministrator = true,
	administrator = true,
}

local sadminRanks = {
	superadmin = true,
	communitymanager = true,
	superadministrator = true,
	senioradministrator = true,
	eventmanager = true,
}

local ssadminRanks = {
	superadmin = true,
	communitymanager = true,
	superadministrator = true,
}
PLUGIN.name = "Administration Commands"
PLUGIN.author = "Red Panda Gaming"
PLUGIN.description = "A list of quality of life administrative commands"


if SERVER then
    util.AddNetworkString("CopyModelToClipboard")
    util.AddNetworkString("CopySteamIDToClipboard")
    util.AddNetworkString("CopyCharID")
    
    hook.Add( "PlayerSay", "CommandIntercept", function( player, text, teamChat )

        -- check if the message is !grabid
        if string.sub( text, 1, 7 ) == "!grabid" then
    
            -- replace the ! with / and pass it to the chat system
            local newText = string.gsub( text, "!", "/" )
            
            -- execute the new command
            game.ConsoleCommand( newText.."\n" )
            
            -- prevent the original command from being executed
            return ""
        end
    
    end )
    
    nut.command.add("chargetmodel", {
        syntax = "<string name>",
        onRun = function(client, arguments)
            local uniqueID = client:GetUserGroup()
            if(!globalRanks[uniqueID]) then
                client:notify("Your rank is not high enough to use this command.")
                return false
            end
            
            local target = nut.command.findPlayer(client, arguments[1])
    
            if (IsValid(target) and target:getChar()) then
                client:notify("MODEL COPIED | Open your console to copy the selected model.")
                client:notify(""..target:GetModel().."")
                netstream.Start(client, "sendToClipboard", target:GetModel())
            end
        end
    })


    nut.command.add("copyid", {
        syntax = "<string name>",
        onRun = function(client, arguments)
            local uniqueID = client:GetUserGroup()
            if(!globalRanks[uniqueID]) then
                client:notify("Your rank is not high enough to use this command.")
                return false
            end
            
            local target = nut.command.findPlayer(client, arguments[1])
    
            if (IsValid(target) and target:getChar()) then
                local characterid = target:getChar():getID()
                client:ChatPrint(target:Nick() .. "'s character ID has been copied to Clipboard!")
                netstream.Start(client, "sendToClipboard", characterid)
            end
        end
    })
    nut.command.add("fixleg", {
        syntax = "<string name>",
        onRun = function(client, arguments)
            local uniqueID = client:GetUserGroup()
            if(!ssadminRanks[uniqueID]) then
                client:notify("Your rank is not high enough to use this command.")
                return false
            end
            
            local target = nut.command.findPlayer(client, arguments[1])
    
            if target and target:IsPlayer() and target:IsValid() then
                if target:GetNWBool("legInjured", true) then
                    client:notify(target:Nick() .. " leg has been healed!")
                    target:notify(client:Nick() .. " healed your legs!")
                    target:SetNWBool("legInjured", false) -- It should be target instead of ply
                    target:SetRunSpeed(235) -- It should be target instead of ply
                else
                    client:notify(target:Nick() .. "'s leg is not injured!")
                end
            else
                client:notify("Target not found!")   
            end
        end
    })

    local function resetBoneAngles( ply )
        if not ply:GetBoneCount() then return end
        for i = 0, ply:GetBoneCount() do
            ply:ManipulateBonePosition( i, Vector( 0, 0, 0 ) )
            ply:ManipulateBoneAngles( i, Angle( 0, 0, 0 ) )
        end
    end

    nut.command.add("unrestrain", {
        syntax = "<string name>",
        onRun = function(client, arguments)
            local uniqueID = client:GetUserGroup()
            if(!ssadminRanks[uniqueID]) then
                client:notify("Your rank is not high enough to use this command.")
                return false
            end
            
            local target = nut.command.findPlayer(client, arguments[1])
    
            if target and target:IsPlayer() and target:IsValid() then
                if target:getNetVar("restricted") then
                    client:notify(target:Nick() .. " has been unrestrained!")
                    target:notify(client:Nick() .. " unrestrained you.")
                    target:setNetVar("restricted", false)
                    target:SetRunSpeed(275)
                    resetBoneAngles(target)
                    target:setRestricted(false)
                else
                    client:notify(target:Nick() .. " is not restrained!")
                end
            else
                client:notify("Target not found!")   
            end
        end
    })

    nut.command.add("restrain", {
        syntax = "<string name>",
        onRun = function(client, arguments)
            local uniqueID = client:GetUserGroup()
            if(!ssadminRanks[uniqueID]) then
                client:notify("Your rank is not high enough to use this command.")
                return false
            end
            
            local target = nut.command.findPlayer(client, arguments[1])
    
            if target and target:IsPlayer() and target:IsValid() then
                if target:getNetVar("restricted") then
                    client:notify(target:Nick() .. " is already restrained!")
                else
                    client:notify(target:Nick() .. " has been restrained!")
                    target:notify(client:Nick() .. " restrained you.")
                    target:setNetVar("restricted", true)
                    target:setRestricted(true)
                    target:SetRunSpeed(target:GetWalkSpeed())
                end
            else
                client:notify("Target not found!")   
            end
        end
    })
    
    
    nut.command.add("grabid", {
        --      syntax = "<string name>",
              onRun = function(client)
                  local uniqueID = client:GetUserGroup()
                  if(!globalRanks[uniqueID]) then
                      client:notify("Your rank is not high enough to use this command.")
                      return false
                  end
                  local trace = client:GetEyeTrace()
                  local target = trace.Entity
                 -- local target = nut.command.findPlayer(client, arguments[1])
                if !target:IsPlayer() then 
                    client:notify("Please make sure you are looking at a player.")
                end
                  if (IsValid(target) and target:getChar()) then
                      local targetsteam = target:SteamID()
                      client:ChatPrint(target:Nick() .. "'s SteamID has been copied to Clipboard!")
                      netstream.Start(client, "sendToClipboard", targetsteam)
                  end
              end
          })
      

--[[
    
    nut.command.add("cleanitems", {
        onRun = function(client)
            for k,v in ipairs(player.GetAll()) do
                v:ChatPrint(client:Nick() .. " has removed all dropped items from the map!")
                for k,v in ipairs(ents.GetAll()) do
                    if v:GetClass() == "nut_item" then v:Remove() end
                end
            end
        end
    })
    
    nut.command.add("gracecleanitems", {
        onRun = function(client)
            for k,v in ipairs(player.GetAll()) do
                v:ChatPrint(client:Nick() .. " has initiated an item wipe in 1 minute")
                timer.Simple(30, function()
                    v:ChatPrint("All ground items will be despawned in 30 seconds!")
                end)
                timer.Simple(60, function()
                    for k,v in ipairs(ents.GetAll()) do
                        if v:GetClass() == "nut_item" then v:Remove() end
                    end
                    v:ChatPrint(client:Nick() .. " has removed all dropped items from the map!")
                end)
            end
        end
    })
    --]]

    
    nut.command.add("seeflags", {
        syntax = "<string name>",
        onRun = function(client, arguments)
            local uniqueID = client:GetUserGroup()
            if(!globalRanks[uniqueID]) then
                client:notify("Your rank is not high enough to use this command.")
                return false
            end
            
            local target = nut.command.findPlayer(client, arguments[1])
    
            if IsValid(target) and target:getChar() then
                local flags = target:getChar():getFlags()
                -- Split the flags by comma
                -- Return flags to client
                client:ChatPrint("Flags for player " .. target:Name() .. ":")
                client:ChatPrint(flags)
            else
                client:ChatPrint("Invalid target.")
            end

        end
    })
--[[
    nut.command.add("seeflags", {
        onRun = function(client)
            local trace = client:GetEyeTrace()
            local target = trace.Entity

            if target:IsPlayer() and target:getChar() then
                local flags = target:getChar():getFlags()
                client:ChatPrint(target:Nick() .. "'s character has the following flags:")
                client:ChatPrint(flags)
            else
                client:ChatPrint("Invalid target!")
            end
        end
    })
    --]]
end

--[[
if CLIENT then
    net.Receive("CopyModelToClipboard", function()
        local charmodel = net.ReadString()
        SetClipboardText(charmodel)
    end)
    net.Receive("CopySteamIDToClipboard", function()
        local targetsteamid = net.ReadString()
        SetClipboardText(targetsteamid)
    end)
    net.Receive("CopyCharID", function()
        local characterid = net.ReadString()
        SetClipboardText(characterid)
    end)
end--]]