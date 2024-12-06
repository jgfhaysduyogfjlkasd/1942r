-- "gamemodes\\1942rp\\plugins\\hopstop.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
PLUGIN.name = "Hop Stop"
PLUGIN.author = "Vex"
PLUGIN.desc = "Prevents people from being able to Bunny Hop."

if (SERVER) then
	function PLUGIN:KeyPress(player, key)
		if (key == IN_JUMP && !player:InVehicle() && player:GetMoveType() != MOVETYPE_NOCLIP) then
			local stamima = player:getLocalVar("stm", 0)
			if (stamima >= 15) then
				player:setLocalVar("stm", stamima - 15)
				if Frontlines then
					player.lastJump = CurTime()
				end
			end
		end
	end
end

function PLUGIN:StartCommand(ply, cmd)
	if (ply:getLocalVar("stm", 0) < 15 and cmd:KeyDown(IN_JUMP) and ply:GetMoveType() == MOVETYPE_WALK || ply.lastJump && (ply.lastJump or 0) > CurTime() - 1) && ply:GetMoveType() != MOVETYPE_NOCLIP then
		cmd:RemoveKey(IN_JUMP)
	end
end