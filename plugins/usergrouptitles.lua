-- "gamemodes\\1942rp\\plugins\\usergrouptitles.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLUGIN = PLUGIN
PLUGIN.name = "Admin Drawing"
PLUGIN.author = "CallowayIsWeird"
PLUGIN.desc = "Shows above the head if they are an admin or not using usergroups."
 
if (CLIENT) then
    local SUPERADMIN = Color(255, 209, 20)
    local ROOTMANAGEMENT = Color(255, 209, 20)
    local COMMUNITYMANAGER = Color(255, 209, 20)
    local STAFFMANAGER = Color(255, 209, 20)
    local SUPERVISORADMINISTRATOR = Color(255, 209, 20)
    local HEADADMINISTRATOR = Color(255, 209, 20)
    local SENIORADMINISTRATOR = Color(255, 209, 20)
    local ADMINISTRATOR = Color(255, 209, 20)
    local SENIORMODERATOR = Color(255, 209, 20)
    local MODERATOR = Color(255, 209, 20)
    local HELPER = Color(255, 209, 20)
    local GAMEMASTER = Color(4, 251, 255)

    hook.Add( "DrawCharInfo", "DrawCharInfoStaff", function( client, character, info )
        if (client:Team() == FACTION_STAFF) then

         

            if (client:IsUserGroup("superadmin")) then
                info[#info + 1] = {"Superadmin", SUPERADMIN}
            end

            if (client:IsUserGroup("RootManagement")) then
                info[#info + 1] = {"Root Management", ROOTMANAGEMENT}
            end
            
            if (client:IsUserGroup("Helper")) then
                info[#info + 1] = {"Helper", HELPER}
            end

            if (client:IsUserGroup("GameMaster")) then
                info[#info + 1] = {"Game Master", GAMEMASTER}
            end
        end
    end )
end