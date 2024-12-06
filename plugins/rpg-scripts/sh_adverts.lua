PLUGIN.name = "Advertising"
PLUGIN.author = "Lenno & Dave"
PLUGIN.desc = "Basic advertisement system for Jobs and Civilians"

nut.chat.register("announcement", {
	onCanSay =  function(speaker, text)
		return speaker:IsAdmin()
	end,
	onCanHear = 1000000,
	onChatAdd = function(speaker, text)
		chat.AddText(Color(255, 60, 46), " [Staff Announcement] ", color_white, text)
	end,
	prefix = {"/announce"}
})

nut.chat.register("advert", {
	onCanSay =  function(speaker, text)	
		if speaker:getChar():hasMoney(100) then
			speaker:getChar():takeMoney(100)
			speaker:notify("You have paid 100RM to broadcast your message.")
			return true
		else 

			speaker:notify("You lack sufficient funds.")
			return false 
		end
	end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(251, 255, 0), " [Advertisement] ",  Color(118, 219, 255), speaker:Nick(), Color(255, 255, 255), ": ",  text)
	end,
	prefix = {"/advert", "broadcast"},
	noSpaceAfter = true,
	filter = "advertisements"
})

nut.chat.register("jobadvert", {
	onCanSay =  function(speaker, text)	
		if speaker:getChar():hasMoney(50) then
			speaker:getChar():takeMoney(50)
			speaker:notify("You have paid 50RM to broadcast your message.")
			return true
		else 
			speaker:notify("You lack sufficient funds.")
			return false 
		end
	end,
	onChatAdd = function(speaker, text)
		chat.AddText( Color(255, 146, 63), " [Job Advertisement] ",  Color(118, 219, 255), speaker:Nick(), Color(255, 255, 255), ": ",  text)
	end,
	prefix = {"/jobadvert"},
	noSpaceAfter = true,
	filter = "jobadvertisements"
})
