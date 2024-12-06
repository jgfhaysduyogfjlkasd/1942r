--------------------------------------------------------------------------------------------------------
local PLUGIN = PLUGIN
--------------------------------------------------------------------------------------------------------
nut.command.add(
    "partytier",
    {
        adminOnly = true,
        privilege = "Management - Assign Party Tiers",
        syntax = "<string target> <string number>",
        onRun = function(client, arguments)
            local char = client:getChar()
            if not char then return "You must be on a character to use this" end
            local target = nut.command.findPlayer(client, arguments[1])
            if not (IsValid(target)) then
                client:notify("Invalid target.")

                return
            elseif not char:hasFlags("T") then
                client:notify("You don't have permissions for that.")

                return
            end

            local tChar = target:getChar()
            if tChar then
                tChar:setData("party_tier", tonumber(arguments[2]), false, player.GetAll())
                client:notify("Du hast " .. target:Name() .. "'s Partei Tier geändert zu " .. tonumber(arguments[2]) .. " .")
                if tonumber(arguments[2]) > 0 and tonumber(arguments[2]) <= 5 then
                    target:notify("Deine Partei Tier wurde geändert zu " .. tonumber(arguments[2]) .. " .")
                elseif tonumber(arguments[2]) == 0 then
                    target:notify(client:Name() .. " hat deine Partei Tier entfährt!")
                end
            end
            PLUGIN:UpdatePartyTiers()
        end
    }
)
--------------------------------------------------------------------------------------------------------