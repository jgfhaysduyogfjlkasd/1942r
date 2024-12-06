if SERVER then return end
local PLUGIN = PLUGIN

-- SERVER GUIDELINES
local PANEL1 = {}
function PANEL1:Init()
    local W, H = self:GetParent():GetSize()
    self:SetPos((ScrW()-W)/2, (ScrH()-H)/1.5)
    self:SetSize(self:GetParent():GetSize())
    self:ShowCloseButton(false)
    
    self:SetTitle(L"Red Panda Gaming | Server Guidelines")
    self.motd = self:Add("HTML")
    self.motd:Dock(FILL)
    self.motd:OpenURL( PLUGIN.urlRULES )
end

function PANEL1:Think()
    if (!self:IsActive()) then
        self:MakePopup()
    end
end

vgui.Register("nut_PK1", PANEL1, "DFrame")


-- PERM-KILL
local PANEL2 = {}
function PANEL2:Init()
    local W, H = self:GetParent():GetSize()
    self:SetPos((ScrW()-W)/2, (ScrH()-H)/1.5)
    self:SetSize(self:GetParent():GetSize())
    self:ShowCloseButton(false)
    
    self:SetTitle(L"Red Panda Gaming | Permanent Death/Kill Guidelines")
    self.motd = self:Add("HTML")
    self.motd:Dock(FILL)
    self.motd:OpenURL( PLUGIN.urlPK )
end

function PANEL2:Think()
    if (!self:IsActive()) then
        self:MakePopup()
    end
end

vgui.Register("nut_PK2", PANEL2, "DFrame")


-- Create Menu Buttons (calling both panels separately)
function PLUGIN:CreateMenuButtons(tabs)
    tabs["SERVER GUIDELINES"] = function(panel)
        panel:Add("nut_PK1")
    end
    tabs["PERM-KILL"] = function(panel)
        panel:Add("nut_PK2")
    end
end
