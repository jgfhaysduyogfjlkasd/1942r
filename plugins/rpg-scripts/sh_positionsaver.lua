PLUGIN.name = "Character Position Saver"
PLUGIN.desc = "Remembers where you last left off your character!"
PLUGIN.author = "Nutter"

local playerPositions = {}

-- Save the position and angles when the player disconnects.
hook.Add("PlayerDisconnected", "SavePlayerPosition", function(ply)
    local char = ply:getChar()
    
    if char then
        local charID = char:getID()
        local position = ply:GetPos()
        local angles = ply:EyeAngles()

        playerPositions[charID] = {position = position, angles = angles}

        print("Saved position for character " .. charID .. ":")
        print("Position: " .. tostring(position))
        print("Angles: " .. tostring(angles))
    end
end)

-- Save the position and angles when the player switches character.
function PLUGIN:PrePlayerLoadedChar(ply, character, lastChar)
    if lastChar then
        local charID = lastChar:getID()
        local position = ply:GetPos()
        local angles = ply:EyeAngles()

        playerPositions[charID] = {position = position, angles = angles}

        print("Saved position for character " .. charID .. ":")
        print("Position: " .. tostring(position))
        print("Angles: " .. tostring(angles))
    end
end

-- Save the position and angles when the player switches character.
function PLUGIN:PlayerLoadedChar(ply, character, lastChar)
    local newCharID = character:getID()
    if playerPositions[newCharID] then
        print("Restoring position for character " .. newCharID .. ":")
        print("Position: " .. tostring(playerPositions[newCharID].position))
        print("Angles: " .. tostring(playerPositions[newCharID].angles))
        
        local playerPos = playerPositions[newCharID].position
        local playerAng = playerPositions[newCharID].angles

        timer.Simple(0.4, function()
            if IsValid(ply) then
                ply:SetPos(playerPos)
                ply:SetEyeAngles(playerAng)
            end
        end)

        -- Clear the stored data after it's been used.
        playerPositions[newCharID] = nil
    else
        print("No saved position for character " .. newCharID)
    end
end


--PrePlayerLoadedChar