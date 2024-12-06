local PLUGIN = PLUGIN
PLUGIN.name = "Clear Chat"
PLUGIN.desc = "Adds a command for clearing the chat"
PLUGIN.author = "Zoephix"

PLUGIN.whitelist = {
	"founder",
	"communitymanager",
	"superadmin"
}

if CLIENT then
	netstream.Hook("adminClearChat", function()
		local chat = nut.plugin.list["chatbox"]
		if chat and IsValid(chat.panel) then
			chat.panel:Remove()
			chat:createChat()
		else
			LocalPlayer():ConCommand("fixchatplz")
		end
	end)
end

nut.command.add("clearchat", {
	adminOnly = true,
	onRun = function(admin, arguments)
		if SERVER then
			if not table.HasValue(PLUGIN.whitelist, admin:GetUserGroup()) then
				admin:notify("You are not allowed to do this.")
				return
			end

			netstream.Start(player.GetAll(), "adminClearChat")
			nut.log.addRaw(admin:GetName() .. " has cleared the chat.")
			admin:notify("Global chat has been cleared")
		end
	end
})
