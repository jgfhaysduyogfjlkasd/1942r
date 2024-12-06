include("shared.lua")
local TEXT_OFFSET = Vector(0, 0, 20)
local toScreen = FindMetaTable("Vector").ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
function ENT:onDrawEntityInfo(alpha)
    local position = toScreen(self.LocalToWorld(self, self.OBBCenter(self)) + TEXT_OFFSET)
    local x, y = position.x, position.y
    drawText("Paul McCormick", x, y, colorAlpha(nut.config.get("color"), alpha), 1, 1, nil, alpha * 0.65)
    drawText("Hey you looking to buy a car?", x, y + 16, colorAlpha(color_white, alpha), 1, 1, "nutSmallFont", alpha * 0.65)
end