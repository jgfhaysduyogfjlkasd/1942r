------------------------------------------------------------------------------------------
include("shared.lua")
------------------------------------------------------------------------------------------
function ENT:onDrawEntityInfo(alpha)
    local position = FindMetaTable("Vector").ToScreen(self.LocalToWorld(self, self.OBBCenter(self)) + Vector(0, 0, 20))
    local x, y = position.x, position.y
    nut.util.drawText(self.NPCName, x, y, ColorAlpha(nut.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)
    nut.util.drawText(self.NPCDescription, x, y + 16, ColorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
end
------------------------------------------------------------------------------------------