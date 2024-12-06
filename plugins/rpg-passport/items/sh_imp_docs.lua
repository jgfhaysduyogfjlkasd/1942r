ITEM.name = "German Passport"
ITEM.desc = "Identification documents given to citizens of the Greater German Realm"
ITEM.model = "models/props_lab/binderredlabel.mdl"
ITEM.uniqueID = "papers"
ITEM.netUID = "openUpID"
ITEM.additionalArg = nil

ITEM.functions = {}
ITEM.functions.show = {
    icon = "icon16/vcard.png",
    name = "Show",
    onRun = function(item)
        local ply = item.player
        if (ply.NextDocumentCheck and ply.NextDocumentCheck > SysTime()) then
            ply:notify("Please wait before viewing again!")
            return false
        end
        ply.NextDocumentCheck = SysTime() + 5
        local target = ply:GetEyeTrace().Entity
        if not target:IsPlayer() or not IsValid(target) or target:GetPos():Distance(ply:GetPos()) > 500 then
            return false
        end
        netstream.Start(target, "openUpID", ply)
        return false
    end,
    onCanRun = function(item)
        local trEnt = item.player:GetEyeTrace().Entity
        return IsValid(trEnt) and trEnt:IsPlayer()
    end,
}

ITEM.functions.showself = {
    icon = "icon16/vcard.png",
    name = "View Passport",
    onRun = function(item)
        local ply = item.player
        if (ply.NextDocumentCheck and ply.NextDocumentCheck > SysTime()) then
            ply:notify("Please wait before viewing again!")
            return false
        end
        ply.NextDocumentCheck = SysTime() + 5
        netstream.Start(ply, item.netUID, ply, item.additionalArg)
        return false
    end,
}

-- Prevent the item from being transferred or dropped.
function ITEM:onCanBeTransfered(oldInventory, newInventory)
    return false
end