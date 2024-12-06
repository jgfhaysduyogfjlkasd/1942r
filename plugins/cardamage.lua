-- "gamemodes\\1942rp\\plugins\\damage.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLUGIN = PLUGIN



PLUGIN.name = "Passenger Damage Transfer"

PLUGIN.desc = "Allows the passengers and drivers of a vehicle to be shot (contrary to GMod's default functionality)."

PLUGIN.author = "Logan"



-- Function to handle damage to a vehicle seat and transfer it to the player

local function TransferSeatDamageToPlayer(seat, dmgInfo)

    if seat:IsVehicle() then

       -- print("Vehicle detected")



        -- Check if the vehicle is of the correct class

        if seat:GetClass() == "gmod_sent_vehicle_fphysics_base" then

            -- Get the player in the driver's seat

            local player = seat:GetDriver()

            if IsValid(player) then

             --   print("Valid player detected")



                -- Get the damage hit position

                local hitPos = dmgInfo:GetDamagePosition()



                -- Get the player's position (or seat position)

                local playerPos = player:GetPos()



                -- Check if the hit position is close enough to the player's position

                -- Adjust the threshold distance as needed

                local thresholdDistance = 53 -- example distance in units

                if hitPos:Distance(playerPos) <= thresholdDistance then

                --    print("Hit near player")



                    -- Manually adjust the player's health

                    local newHealth = player:Health() - (dmgInfo:GetDamage()*0.3) -- a bit more than half damage

                    if newHealth > 0 then

                        player:SetHealth(newHealth)

                    else

                        player:Kill() -- Kills the player if the damage exceeds their current health

                    end

                end

            end

        end

    end

end



-- Hook into the EntityTakeDamage event to process damage to vehicle seats

function PLUGIN:EntityTakeDamage(entity, dmgInfo)

    TransferSeatDamageToPlayer(entity, dmgInfo)

end

