PLUGIN.name = "Watermark"
PLUGIN.author = "Dave"
PLUGIN.desc = "Text Watermark"

SCHEMA.logotext = 'RED PANDA GAMING v1.1'
resource.AddFile("materials/rpglogos/redpg.png")

if CLIENT then
	local agLogo = Material("materials/rpglogos/redpg.png")
	hook.Add("HUDPaint", "watermarkpaint", function()
		local w,h = 0,0

		surface.SetMaterial(agLogo)
		surface.SetDrawColor(255, 255, 255, 130)
		surface.DrawTexturedRect(5, ScrH()-h-5, w, h)
		
		surface.SetTextColor(255, 255, 255, 130)
		surface.SetFont("nutMediumFont")
		local tw,th = surface.GetTextSize(SCHEMA.logotext)
		surface.SetTextPos(15 + w, 25)
		surface.DrawText(SCHEMA.logotext)
	end)
end