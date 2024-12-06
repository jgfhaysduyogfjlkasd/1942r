AdminStick = AdminStick or {}
local function OpenNameUI(target)
    AdminStick.IsOpen = true

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Change Name")
    frame:SetSize(300,110)
    frame:Center()

    function frame:OnClose()
        frame:Remove()
        AdminStick.IsOpen = false
    end

    local edit = vgui.Create("DTextEntry",frame)
    edit:Dock(FILL)
    //edit:SetMultiline(true)
    edit:SetPlaceholderText(target:Name())

    local button = vgui.Create("DButton",frame)
    button:Dock(BOTTOM)
    button:SetText("Copy Name to Clipboard")
    function button:DoClick()
        SetClipboardText(target:Name())
        button:SetText("Copied '" .. target:Name() .. "'s' name to Clipboard")
        surface.PlaySound("buttons/lightswitch2.wav")

        timer.Simple(2, function()
            button:SetText("Copy Name to Clipboard")
        end)
    end

    local button1 = vgui.Create("DButton",frame)
    button1:Dock(BOTTOM)
    button1:SetText("Change")
    function button1:DoClick()
        local txt = edit:GetValue()
    LocalPlayer():ConCommand('say /charsetname "'..target:Name()..'" "'..edit:GetValue()..'"')
        AdminStick.IsOpen = false
    end
    frame:MakePopup()
end

local function OpenPlayerModelUI(target)
    AdminStick.IsOpen = true

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Change Playermodel")
    frame:SetSize(450,300)
    frame:Center()

    function frame:OnClose()
        frame:Remove()
        AdminStick.IsOpen = false
    end

    local scroll = vgui.Create("DScrollPanel",frame)
    scroll:Dock(FILL)
    local wrapper = vgui.Create("DIconLayout",scroll)
    wrapper:Dock(FILL)
    local edit = vgui.Create("DTextEntry",frame)
    edit:Dock(BOTTOM)
    edit:SetPlaceholderText("Model Path")
    
    local button = vgui.Create("DButton",frame)
    button:SetText("Change")
    button:Dock(TOP)
    function button:DoClick()
        local txt = edit:GetValue()
    LocalPlayer():ConCommand('say /charsetmodel "'..target:Name()..'" "'..edit:GetValue()..'"')
        AdminStick.IsOpen = false
    end

    for name, model in SortedPairs( player_manager.AllValidModels() ) do

			local icon = wrapper:Add("SpawnIcon")
			icon:SetModel( model )
			icon:SetSize( 64, 64 )
			icon:SetTooltip( name )
			icon.playermodel = name
			icon.model_path = model
            --icon:Dock(LEFT)
            icon.DoClick = function(self)
                edit:SetValue(self.model_path)
            end

		end

    frame:MakePopup()
end

local function OpenReasonUI(target,cmd,time)
    AdminStick.IsOpen = true

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Reason for "..cmd)
    frame:SetSize(300,150)
    frame:Center()
    function frame:OnClose()
        frame:Remove()
        AdminStick.IsOpen = false
    end
    local edit = vgui.Create("DTextEntry",frame)
    edit:Dock(FILL)
    edit:SetMultiline(true)
    edit:SetPlaceholderText("Reason")
    local timeedit
    if cmd=="gag" then
        local time = vgui.Create("DNumSlider",frame)
        time:Dock(TOP)
        time:SetText("Length (minutes)")
        time:SetMin(0)
        time:SetMax(365)
        time:SetDecimals(0)
        timeedit = time
    end

    local button = vgui.Create("DButton",frame)
    button:Dock(BOTTOM)
    button:SetText("Change")
    function button:DoClick()
        local txt = edit:GetValue()
        if (cmd == "gag") then
			local time = timeedit:GetValue()*1*1
            RunConsoleCommand("sam",cmd,target:Name(),time,txt)
        else
            RunConsoleCommand("sam",cmd,target:Name(),txt)
        end
        frame:Remove()
        AdminStick.IsOpen = false
    end
    frame:MakePopup()
end

local function OpenReasonUI(target,cmd,time)
    AdminStick.IsOpen = true

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Reason for "..cmd)
    frame:SetSize(300,150)
    frame:Center()
    function frame:OnClose()
        frame:Remove()
        AdminStick.IsOpen = false
    end
    local edit = vgui.Create("DTextEntry",frame)
    edit:Dock(FILL)
    edit:SetMultiline(true)
    edit:SetPlaceholderText("Reason")
    local timeedit
    if cmd=="ban" then
        local time = vgui.Create("DNumSlider",frame)
        time:Dock(TOP)
        time:SetText("Length (days)")
        time:SetMin(0)
        time:SetMax(365)
        time:SetDecimals(0)
        timeedit = time
    end

    local button = vgui.Create("DButton",frame)
    button:Dock(BOTTOM)
    button:SetText("Change")
    function button:DoClick()
        local txt = edit:GetValue()
        if (cmd == "ban") then
			local time = timeedit:GetValue()*64*24
            RunConsoleCommand("sam",cmd,target:Name(),time,txt)
        else
            RunConsoleCommand("sam",cmd,target:Name(),txt)
        end
        frame:Remove()
        AdminStick.IsOpen = false
    end
    frame:MakePopup()
end

function AdminStick:OpenAdminStickUI(isright,target)
    isright = isright or false
    if isright then target = LocalPlayer() end
    AdminStick.IsOpen = true
    AdminStick.AdminMenu = DermaMenu()
    
    local AdminMenu = AdminStick.AdminMenu
    local menutitle = AdminMenu:AddOption("Red Panda Gaming | Staff Tool")
    menutitle:SetIcon( "icon16/asterisk_orange.png" )
	if target:IsPlayer() then
		local name = AdminMenu:AddOption( "Character Name: "..target:Name(),function()
			LocalPlayer():ChatPrint("Copied Name: "..target:Name())
			SetClipboardText(target:Name())
			AdminStick.IsOpen = false
		end)
		name:SetIcon( "icon16/vcard.png" )

		local charid = AdminMenu:AddOption( "CharID: "..target:getChar():getID(),function()
			LocalPlayer():ChatPrint("Copied CharID: "..target:getChar():getID())
			SetClipboardText(target:getChar():getID())
			AdminStick.IsOpen = false
		end)
		charid:SetIcon( "icon16/information.png" )

		local steamid = AdminMenu:AddOption( "SteamID: "..target:SteamID(),function()
			LocalPlayer():ChatPrint("Copied SteamID: "..target:SteamID())
			SetClipboardText(target:SteamID())
			AdminStick.IsOpen = false
		end)
		steamid:SetIcon( "icon16/status_online.png" )

		local steamid64 = AdminMenu:AddOption( "SteamID64: "..target:SteamID64(),function()
			LocalPlayer():ChatPrint("Copied SteamID64: "..target:SteamID64())
			SetClipboardText(target:SteamID64())
			AdminStick.IsOpen = false
		end)
		steamid64:SetIcon( "icon16/status_online.png" )

		AdminMenu:AddSpacer()

		for i,fac in pairs(nut.faction.teams) do
			if fac.index == target:getChar():getFaction() then
					local faction = AdminMenu:AddSubMenu("Set Character Faction ("..fac.name..")")
					for i,v in pairs(nut.faction.teams) do
						faction:AddOption(v.name,function()
							LocalPlayer():ConCommand('say /plytransfer "'..target:Name()..'" "'..v.name..'"')
							AdminStick.IsOpen = false
						end)
					end
			end
		end

		local administration = AdminMenu:AddSubMenu("Administration Tools")
		local notes = administration:AddOption( "View Notes",function() 
			RunConsoleCommand("say", "/adminnotes "..target:SteamID())
			AdminStick.IsOpen = false
		end)
		notes:SetIcon( "icon16/application_form_magnify.png" )

		local checkmoney = administration:AddOption( "Check Money",function() 
			LocalPlayer():ConCommand('say /checkallmoney "'..target:SteamID()..'"')
			AdminStick.IsOpen = false
		end)
		checkmoney:SetIcon( "icon16/money.png" )

		local checkinventory = administration:AddOption( "Check Inventory",function() 
			LocalPlayer():ConCommand('say /checkinventory "'..target:SteamID()..'"')
			AdminStick.IsOpen = false
		end)
		checkinventory:SetIcon( "icon16/group.png" )
				
		local clearinventory = administration:AddOption( "Clear Inventory",function() 
			LocalPlayer():ConCommand('say /clearinv "'..target:SteamID()..'"')
			AdminStick.IsOpen = false
		end)
		clearinventory:SetIcon( "icon16/group_delete.png" )
				
		if (target:IsFrozen()) then
			local unfreeze = administration:AddOption( "Unfreeze",function() 
				RunConsoleCommand("sam","unfreeze",target:Name())
				AdminStick.IsOpen = false
			end)
			unfreeze:SetIcon( "icon16/disconnect.png" )
		else
			local freeze = administration:AddOption( "Freeze",function() 
				RunConsoleCommand("sam","freeze",target:Name())
				AdminStick.IsOpen = false
			end)
			freeze:SetIcon( "icon16/connect.png" )
		end
		
		local jail = administration:AddOption( "Jail",function() 
				RunConsoleCommand("sam","jail",target:Name())
				AdminStick.IsOpen = false
		end)
		jail:SetIcon( "icon16/connect.png" )

		local unjail = administration:AddOption( "Unjail",function() 
				RunConsoleCommand("sam","unjail",target:Name())
				AdminStick.IsOpen = false
		end)
		unjail:SetIcon( "icon16/disconnect.png" )
		
		local ban = administration:AddOption("Ban",function()
			OpenReasonUI(target,"ban",0)
		end)
		ban:SetIcon("icon16/cancel.png")

		local kick = administration:AddOption( "Kick",function() 
				OpenReasonUI(target,"kick",0)
		end)
		kick:SetIcon( "icon16/delete.png" )
		
		local gag = administration:AddOption("Voice Chat Gag",function()
			OpenReasonUI(target,"gag",0)
		end)
		gag:SetIcon( "icon16/transmit_delete.png" )

		local ungag = administration:AddOption( "Voice Chat Ungag",function() 
			RunConsoleCommand("sam","ungag",target:Name())
			AdminStick.IsOpen = false
		end)
		ungag:SetIcon( "icon16/transmit_add.png" )
		
		local mute = administration:AddOption( "Chat Mute",function() 
			OpenReasonUI(target,"mute",0)
			AdminStick.IsOpen = false
		end)
		mute:SetIcon( "icon16/sound_delete.png" )
			
		local unmute = administration:AddOption( "Chat Unmute",function() 
			RunConsoleCommand("sam","unmute",target:SteamID())
				AdminStick.IsOpen = false
		end)
		unmute:SetIcon( "icon16/sound_add.png" )

		local character = AdminMenu:AddSubMenu("Character Options")
		local pk = character:AddOption( "Permanently Kill",function() 
			LocalPlayer():ConCommand('say /charban "'..target:SteamID()..'"')
			AdminStick.IsOpen = false
		end)
		pk:SetIcon( "icon16/lightning.png" )
				
		local pkactive = character:AddOption( "Toggle Permanent Kill ",function() 
			LocalPlayer():ConCommand('say /pkactive "'..target:SteamID()..'"')
			AdminStick.IsOpen = false
		end)
		pkactive:SetIcon( "icon16/lightning_delete.png" )
		
		local charkick = character:AddOption( "Kick From Character",function() 
			LocalPlayer():ConCommand('say /charkick "'..target:SteamID()..'"')
			AdminStick.IsOpen = false
		end)
		charkick:SetIcon( "icon16/lightning.png" )

		local setplayername = character:AddOption( "Set Player Name",function() 
			OpenNameUI(target)
		end)
		setplayername:SetIcon( "icon16/user_gray.png" )

		local setplayermodel = character:AddOption( "Set Playermodel",function() 
			OpenPlayerModelUI(target)
		end)
		setplayermodel:SetIcon( "icon16/user_suit.png" )
		
		local copyplayermodel = character:AddOption( "Copy Playermodel",function() 
			LocalPlayer():ConCommand('say /chargetmodel '..target:Name())
		end)
		copyplayermodel:SetIcon( "icon16/user_red.png" )

		local respawn = character:AddOption( "Respawn",function() 
			RunConsoleCommand("sam","respawn",target:Name())
			AdminStick.IsOpen = false
		end)
		respawn:SetIcon( "icon16/wand.png" )
		
		local slay = character:AddOption( "Slay",function() 
			RunConsoleCommand("sam","slay",target:Name())
			AdminStick.IsOpen = false
		end)
		slay:SetIcon( "icon16/status_busy.png" )
		
		local goto = character:AddOption( "Goto",function() 
			RunConsoleCommand("sam","goto",target:Name())
			AdminStick.IsOpen = false
		end)
		goto:SetIcon( "icon16/arrow_right.png" )
		
		local bring = character:AddOption( "Bring",function() 
			RunConsoleCommand("sam","bring",target:Name())
			AdminStick.IsOpen = false
		end)
		bring:SetIcon( "icon16/arrow_down.png" )

		local returnf = character:AddOption( "Return",function() 
			RunConsoleCommand("sam","return",target:Name())
			AdminStick.IsOpen = false
		end)
		returnf:SetIcon( "icon16/arrow_redo.png" )

		local utility = AdminMenu:AddSubMenu("Server Utilities")
		local econ = utility:AddOption( "Clear Chat",function() 
			LocalPlayer():ConCommand('say /clearchat ')
			AdminStick.IsOpen = false
		end)
		econ:SetIcon( "icon16/sport_tennis.png" )
		
		local decals = utility:AddOption( "Clear Decals",function() 
			net.Start("AS_ClearDecals")
			net.SendToServer()
			AdminStick.IsOpen = false
		end)
		decals:SetIcon( "icon16/wrench_orange.png" )
		
		local cleanitem = utility:AddOption( "Clear Items",function() 
			LocalPlayer():ConCommand('say /cleanitems ')
			AdminStick.IsOpen = false
		end)
		cleanitem:SetIcon( "icon16/drive_delete.png" )
		
		local stopsound = utility:AddOption( "Stop Sounds",function() 
			RunConsoleCommand("sam","stopsound",target:Name())
			AdminStick.IsOpen = false
		end)
		stopsound:SetIcon( "icon16/exclamation.png" )

		local mapreset = utility:AddOption( "Map Reset",function() 
			RunConsoleCommand("sam","mapreset",target:Name())
			AdminStick.IsOpen = false
		end)
		mapreset:SetIcon( "icon16/world.png" )

		local time = utility:AddOption( "Show Playtime",function() 
			RunConsoleCommand("sam","time",target:Name())
			AdminStick.IsOpen = false
		end)
		time:SetIcon( "icon16/application_xp_terminal.png" )
	-------------------------------------------------------------------------------------------------------------
	elseif target:isDoor() then
	
		local doortitle = AdminMenu:AddOption( "Set Door Title",function() 
			LocalPlayer():ConCommand('say /doorsettitle')
			AdminStick.IsOpen = false
		end)
		doortitle:SetIcon( "icon16/door.png" )
		
		if (target:getNetVar("hidden") == nil or target:getNetVar("hidden") == false) then
			local doorhide = AdminMenu:AddOption( "Make Door Hidden",function() 
				LocalPlayer():ConCommand('say /doorsethidden')
				AdminStick.IsOpen = false
			end)
			doorhide:SetIcon( "icon16/door.png" )
		elseif (target:getNetVar("hidden") == true) then
			local doorhide1 = AdminMenu:AddOption( "Make Door Visible",function() 
				LocalPlayer():ConCommand('say /doorsethidden 0')
				AdminStick.IsOpen = false
			end)
			doorhide1:SetIcon( "icon16/door.png" )
		end
		
		if (target:getNetVar("noSell") == true) then
			local ownable = AdminMenu:AddOption( "Make Door Ownable",function() 
				LocalPlayer():ConCommand('say /doorsetownable')
				AdminStick.IsOpen = false
			end)
			ownable:SetIcon( "icon16/door_in.png" )
		elseif (target:getNetVar("noSell") == nil) then
			local unownable = AdminMenu:AddOption( "Make Door Unownable",function() 
				LocalPlayer():ConCommand('say /doorsetunownable')
				AdminStick.IsOpen = false
			end)
			unownable:SetIcon( "icon16/door_in.png" )
		end
		
		local addfaction = AdminMenu:AddSubMenu("Add Faction To Door")
		for i,v in pairs(nut.faction.teams) do
			local factions = string.Split(target:getNetVar("faction", ""), ",")
			if table.HasValue(factions, tostring(v.uniqueID)) then continue end
			if v.French then continue end
			addfaction:AddOption(v.name,function()
				LocalPlayer():ConCommand('say /dooraddfaction "'..v.name..'"')
				AdminStick.IsOpen = false
			end)
		end
		
		if target:getNetVar("faction") != nil then
			local removefaction = AdminMenu:AddSubMenu("Remove Faction From Door")
			for i,v in pairs(nut.faction.teams) do
				local factions = string.Split(target:getNetVar("faction", ""), ",")
				if !table.HasValue(factions, tostring(v.uniqueID)) then continue end
				removefaction:AddOption(v.name,function()
					LocalPlayer():ConCommand('say /doorremovefaction "'..v.name..'"')
					AdminStick.IsOpen = false
				end)
			end

			local removeallfaction = AdminMenu:AddOption("Clear Factions From Door", function()
				LocalPlayer():ConCommand('say /doorremovefaction')
				AdminStick.IsOpen = false
			end)
		end
		
		if (target:getNetVar("owner", 0) > 0) then
			local removeowner = AdminMenu:AddOption("Clear Owner From Door", function()
				LocalPlayer():ConCommand('say /doorsetpermaowner')
				AdminStick.IsOpen = false
			end)
		end
	end
	
	if target:GetClass() == "nut_storage" then
		if target:getNetVar("locked") then
			local removelock = AdminMenu:AddOption("Remove Lock", function()
				LocalPlayer():ConCommand('say /storagelock')
				AdminStick.IsOpen = false
			end)
			removelock:SetIcon( "icon16/lock_open.png" )
		end
		local lock = AdminMenu:AddOption("Edit Password", function()
			AdminStick.IsOpen = false
            Derma_StringRequest(
                'Edit Password', 
                'Enter Storage Password', 
                '', 
                function(text)
					LocalPlayer():ConCommand("say /storagelock "..text)
                end
            )
		end)
		lock:SetIcon( "icon16/lock_edit.png" )
	end

    function AdminMenu:OnClose()
        AdminStick.IsOpen = false
    end
    AdminMenu:Open()
    AdminMenu:Center()
end