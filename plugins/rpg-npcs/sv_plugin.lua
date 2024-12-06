-------------------------------------------------------------------------------------------
function PLUGIN:SaveData()
    local data = {}
    for k, v in ipairs(ents.GetAll()) do
        if v.Base ~= "leonheart_npc_base" then continue end
        if v.IsCarDealer then continue end
        data[#data + 1] = {
            class = v:GetClass(),
            pos = v:GetPos(),
            angles = v:GetAngles()
        }
    end

    self:setData(data)
end

-------------------------------------------------------------------------------------------
function PLUGIN:LoadData()
    for k, v in ipairs(self:getData() or {}) do
        local entity = ents.Create(v.class)
        entity:SetPos(v.pos)
        entity:SetAngles(v.angles)
        entity:Spawn()
    end
end
-------------------------------------------------------------------------------------------