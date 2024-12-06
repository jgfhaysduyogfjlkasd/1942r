local PLUGIN = PLUGIN
net.Receive("buy_vehicle", function(len, ply)
    local character = ply:getChar()
    local vehicle = net.ReadString()
    local id = PLUGIN.Vehicles[vehicle].Identifier
    local name = PLUGIN.Vehicles[vehicle].Name
    local price = PLUGIN.Vehicles[vehicle].Price
    if character:getData(id, false) then
        ply:notify("You already own this vehicle!")
    else
        if character:hasMoney(price) then
            character:setData(id, true)
            character:takeMoney(price)
            ply:notify("You've purchased a " .. name .. " for $" .. price .. " (" .. PLUGIN.VehicleTax * 100 .. "% Vehicle Tax)")
        else
            ply:notify("You cannot afford to purchase that!")
        end
    end
end)

net.Receive("spawn_vehicle", function(len, ply)
    local character = ply:getChar()
    local id = net.ReadString()
    local name = net.ReadString()
    local color = net.ReadColor()
    local platform = net.ReadEntity()
    if character:getData(id .. "_towed", false) then
        ply:notify("You're vehicle was towed, go to the police station to have it released.")
        ply:ChatPrint("Note: If you disconnect without returning your vehicle, it will be automatically towed and you will have to pay for it's release.")
    else
        if character:getData(id, false) then
            if character:getVar(id .. "_inuse", false) then
                ply:notify("This vehicle is currently out of the garage!")
            else
                if color ~= Color(255, 255, 255, 255) then
                    if character:getData("paint_mod", false) then
                        local _v = simfphys.SpawnVehicleSimple(id, platform:GetPos() + Vector(0, 0, 40), platform:GetAngles() + Angle(0, 90, 0))
                        _v:SetCreator(ply)
                        _v:SetColor(color)
                        ply:notify("You've taken your " .. name .. " out of the garage.")
                        character:setVar(id .. "_inuse", true)
                        function _v:OnRemove()
                            character:setVar(id .. "_inuse", false)
                            ply:notify("Your " .. name .. " has been destroyed.")
                        end

                        hook.Run("PostVehicleSpawn", _v, ply)
                    else
                        if character:hasMoney(50) then
                            local _v = simfphys.SpawnVehicleSimple(id, platform:GetPos() + Vector(0, 0, 40), platform:GetAngles() + Angle(0, 90, 0))
                            _v:SetCreator(ply)
                            _v:SetColor(color)
                            ply:notify("You've taken your " .. name .. " out of the garage.")
                            character:setVar(id .. "_inuse", true)
                            ply:notify("You've purchased a paint job modification for $50.")
                            character:takeMoney(50)
                            character:setData("paint_mod", true)
                            function _v:OnRemove()
                                character:setVar(id .. "_inuse", false)
                                ply:notify("Your " .. name .. " has been destroyed.")
                            end

                            hook.Run("PostVehicleSpawn", _v, ply)
                        end
                    end
                else
                    local _v = simfphys.SpawnVehicleSimple(id, platform:GetPos() + Vector(0, 0, 40), platform:GetAngles() + Angle(0, 90, 0))
                    _v:SetCreator(ply)
                    _v:SetColor(color)
                    ply:notify("You've taken your " .. name .. " out of the garage.")
                    character:setVar(id .. "_inuse", true)
                    function _v:OnRemove()
                        character:setVar(id .. "_inuse", false)
                        ply:notify("Your " .. name .. " has been destroyed.")
                    end

                    hook.Run("PostVehicleSpawn", _v, ply)
                end
            end
        else
            ply:notify("You do not own this vehicle!")
        end
    end
end)

net.Receive("return_vehicle", function(len, ply)
    local character = ply:getChar()
    local id = net.ReadString()
    local name = net.ReadString()
    if character:getVar(id .. "_inuse", false) then
        if character:hasMoney(50) then
            for k, v in pairs(ents.GetAll()) do
                if v:IsVehicle() and v:GetCreator() == ply then
                    if v:GetCurHealth() == v:GetMaxHealth() then
                        v:Remove()
                        character:setVar(id .. "_inuse", false)
                        character:takeMoney(50)
                        ply:notify("Your " .. name .. " has been returned to the garage for $50.")
                    else
                        ply:notify("You cannot store a damaged vehicle, you must repair it first!")
                    end
                end
            end
        else
            ply:notify("You do not have enough money to have this vehicle returned!")
        end
    else
        ply:notify("This vehicle is not out of the garage!")
    end
end)

net.Receive("sell_vehicle", function(len, ply)
    local character = ply:getChar()
    local vehicle = net.ReadString()
    local id = PLUGIN.Vehicles[vehicle].Identifier
    local name = PLUGIN.Vehicles[vehicle].Name
    local price = PLUGIN.Vehicles[vehicle].Price
    if character:getData(id, false) then
        character:setData(id, false)
        character:giveMoney(price / 2)
        ply:notify("You've sold your " .. name .. " for $" .. price / 2 .. "!")
    else
        ply:notify("You do not own this vehicle!")
    end
end)

net.Receive("testdrive_vehicle", function(len, ply)
    local character = ply:getChar()
    local vehicle = net.ReadString()
    local id = PLUGIN.Vehicles[vehicle].Identifier
    local name = PLUGIN.Vehicles[vehicle].Name
    local price = PLUGIN.Vehicles[vehicle].Price
    if character:getVar(id .. "_testdrive", false) then
        ply:notify("You've already test driven this vehicle!")
    else
        if character:hasMoney(price / 2) then
            local _v = simfphys.SpawnVehicleSimple(id, Vector(83.072548, -575.466797, -12735.968750), Angle(23.380030, -1.501000, 0.000000))
            _v:SetCreator(ply)
            character:setVar(id .. "_testdrive", true)
            ply:notify("You have 30 seconds to test drive the " .. name .. "!")
            timer.Simple(30, function()
                _v:Remove()
                ply:notify("Your test drive is over!")
            end)
        else
            ply:notify("You must have at least half of the price of this vehicle to test drive!")
        end
    end
end)

net.Receive("repair_vehicle", function(len, ply)
    local character = ply:getChar()
    local price = PLUGIN.VehicleRepairCost
    local time = PLUGIN.VehicleRepairTime
    if character:hasMoney(price) then
        ply:Give("weapon_simrepair")
        character:takeMoney(price)
        ply:notify("You've rented repair equipment for $" .. price .. " you have " .. time .. " seconds to repair your vehicle.")
        timer.Simple(time, function()
            ply:StripWeapon("weapon_simrepair")
            ply:notify("Your repair equipment rental has expired.")
        end)
    end
end)

net.Receive("purchase_function", function(len, ply)
    local uniqueID = net.ReadString()
    local amnt = net.ReadInt(6)
    local itemTable = nut.item.list[uniqueID]
    local price = itemTable.price or 50
    local tax = price * nut.config.SalesTax
    local price = math.Round(price + tax)
    local character = ply:getChar()
    if character:hasMoney(price) then
        if amnt ~= 1 then
            if character:hasMoney(price * amnt) then
                for i = 1, amnt do
                    character:getInv():add(uniqueID)
                end

                character:takeMoney(price * amnt)
                ply:notify("You've purchased x" .. amnt .. " an item for $" .. price * amnt .. " (" .. nut.config.SalesTax * 100 .. "% Sales Tax)")
            else
                ply:notify("You do not have enough money to purchase this item.")
            end
        else
            character:getInv():add(uniqueID)
            character:takeMoney(price)
            ply:notify("You've purchased an item for $" .. price .. " (" .. nut.config.SalesTax * 100 .. "% Sales Tax)")
        end
    else
        ply:notify("You do not have enough money to purchase this item.")
    end
end)

net.Receive("sell_func", function(len, ply)
    local uniqueID = net.ReadString()
    local itemTable = nut.item.list[uniqueID]
    local price = itemTable.price or 50
    local character = ply:getChar()
    if character:getInv():hasItem(uniqueID) then
        character:removeItem(uniqueID, 1)
        character:giveMoney(price / 2)
        ply:notify("You've sold an item for $" .. price .. ".")
    else
        ply:notify("You do not have this item to sell.")
    end
end)