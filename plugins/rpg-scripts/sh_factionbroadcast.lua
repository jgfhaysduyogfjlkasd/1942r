nut.flag.add("F", "Access to the /factionbroadcast command")

if SERVER then
    util.AddNetworkString("BroadcastChat")
    
    nut.command.add("factionbroadcast", {
        syntax = "<string factions> <string text>",
        onRun = function(client, arguments)
            if (!client:getChar() || !client:getChar():hasFlags("F")) then
                return "Your character does not have the required flags for this command."
            end
            
            if (!arguments[1]) then
                return "Invalid argument (#1)"
            end
            
            if (!arguments[2]) then
                return "Invalid argument (#2)"
            end
            
            local message = table.concat(arguments, " ", 2)
            local factionList = {}
            local factionListSimple = {}
            
            for k,v in pairs(string.Explode(",", arguments[1])) do
                local foundFaction
                local foundID
                local multiFind
                for m,n in pairs(nut.faction.indices) do
                    if (string.lower(n.uniqueID) == string.lower(v)) then
                        foundFaction = m
                        foundID = n.name
                        multiFind = false
                        break
                    elseif (string.lower(n.uniqueID):find(string.lower(v), 1, true)) then
                        if (foundFaction) then
                            multiFind = true
                        end
                        
                        foundID = n.name
                        foundFaction = m
                    end
                end
                
                if (foundFaction == "staff" || foundFaction == FACTION_staff) then
                    return "No."
                end
                
                if (!foundFaction) then
                    return "Cannot find faction '" .. v .. "' - use the unique IDs of factions (example: okw, okh, citizen, etc)"
                end
                
                if (multiFind) then
                    return "Ambiguous entry (multiple possible factions) - '" .. v .. "'"
                end
                
                factionList[foundFaction] = foundID
                factionListSimple[#factionListSimple + 1] = foundID
            end
            
            if (table.Count(factionList) == 0) then
                return "No valid factions found"
            end
            
            for k,v in pairs(player.GetAll()) do
                if (v == client || (v:getChar() && factionList[v:getChar():getFaction()])) then
                    net.Start("BroadcastChat")
                    net.WriteEntity(client)
                    net.WriteString(message)
                    net.WriteTable(factionListSimple)
                    net.Send(v)
                end
            end
            
            client:notify("Broadcast sent.")
        end
    })
end

if CLIENT then
    nut.command.add("factionbroadcast", {
        onRun = function(client, arguments) end
    })

    net.Receive("BroadcastChat", function()
        local client = net.ReadEntity()
        local message = net.ReadString()
        local factionListSimple = net.ReadTable()
        
        chat.AddText(Color(255, 100, 53), "Historia Networks", Color(255, 255, 255), " | Your message has been sent to ", table.concat(factionListSimple, ", "), ".")
        chat.AddText(Color(200, 200, 100), "Faction Broadcast", Color(255, 255, 255),": ", Color(180, 180, 100), client:Nick(), Color(255, 255, 255), ": ", message)
    end)
end