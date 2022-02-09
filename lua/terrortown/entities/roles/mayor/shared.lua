if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mayor")
	util.AddNetworkString("ttt2_mayor_message")
end


function ROLE:PreInitialize()
	self.color                      = Color(102, 178, 255, 255)

	self.abbr                       = "mayor"
	self.surviveBonus               = 0
	self.score.killsMultiplier      = 2
	self.score.teamKillsMultiplier  = -8
	self.unknownTeam                = true
	self.isPublicRole				= true
	self.isPolicingRole				= true
	self.isOmniscientRole			= true

	self.defaultTeam                = TEAM_INNOCENT

	self.conVarData = {
		pct          = 0.15, -- necessary: percentage of getting this role selected (per player)
		maximum      = 1, -- maximum amount of roles in a round
		minPlayers   = 7, -- minimum amount of players until this role is able to get selected
		credits      = 2, -- the starting credits of a specific role
		minKarma	 = 700,
		shopFallback = SHOP_FALLBACK_DETECTIVE,
		togglable    = true, -- option to toggle a role for a client if possible (F1 menu)
		random       = 33
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_DETECTIVE)
end

if SERVER then
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		MayorMessage(ply)
	end

	function MayorMessage(ply)
		local messageTime = math.random( GetConVar("ttt2_mayor_min_voter_time"):GetInt(), GetConVar("ttt2_mayor_max_voter_time"):GetInt() )
		timer.Create("mayor-message" .. ply:SteamID64(), messageTime, 1, function()
			if not IsValid(ply) then return end
			if SpecDM and (ply.IsGhost and ply:IsGhost() or (vics.IsGhost and vics:IsGhost())) then return end

			local target = ""
			local role = ""
			local team = ""

			local tmp = {}

			for _, p in ipairs(player.GetAll()) do
				if not p:IsActive() or not p:IsTerror() then continue end

				if p:GetBaseRole() ~= ROLE_DETECTIVE and p ~= ply then
					tmp[#tmp + 1] = p
				end
			end
			if #tmp >= 2 then --if more than detective

				local index = math.random(1, #tmp) -- pick a random target from list of players
				
				target = tmp[index]:GetName() -- get first target's name
				team = tmp[index]:GetTeam()
				role = roles.GetByIndex(tmp[index]:GetSubRole()).name
				table.remove(tmp, index) -- remove first target from list

				net.Start("ttt2_mayor_message")
				net.WriteString(target)
				net.WriteString(role)
				net.WriteString(team)
				net.Send(ply)
			end

			MayorMessage(ply)
		end)
	end

	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		timer.Remove("mayor-message" .. ply:SteamID64())
	end
end

if CLIENT then
  net.Receive("ttt2_mayor_message", function()
    local msg_target = net.ReadString()
		local msg_role = net.ReadString()
		local msg_team = net.ReadString()

		local team_colour = Color(255,0,255,255)
		if msg_team == TEAM_INNOCENT then
			team_colour = Color(0,255,0,255)
		elseif msg_team == TEAM_TRAITOR then
			team_colour = Color(255,0,0,255)
		end

		if(GetConVar("ttt2_mayor_voter_reveal_type"):GetInt() == 2) then --show role and team
		
			EPOP:AddMessage({text = msg_team, color = team_colour}, {
				text = "Your Voter " .. msg_target .. " is a " .. msg_role,
        color = Color(255, 255, 255, 255)}, 
				GetConVar("ttt2_mayor_display_voter_time"):GetInt())

    	if GetConVar("ttt2_mayor_voter_chat_window"):GetInt() >= 1 then
				chat.AddText(Color(255, 255, 255, 255), "Mayor: Your Voter " .. msg_target .. " is a ".. msg_role .. " on team: ", team_colour, msg_team)
			end

		elseif(GetConVar("ttt2_mayor_voter_reveal_type"):GetInt() == 1) then --if set to show team only
    	
    	EPOP:AddMessage({text = msg_team, color = team_colour}, {
				text = "Your Voter " .. msg_target .. " is on this team...",
        color = Color(255, 255, 255, 255)}, 
				GetConVar("ttt2_mayor_display_voter_time"):GetInt())

    	if GetConVar("ttt2_mayor_voter_chat_window"):GetInt() >= 1 then
				chat.AddText(Color(255, 255, 255, 255), "Mayor: Your Voter " .. msg_target .. " is on the team: ", team_colour, msg_team)
			end

		else --just show role

			EPOP:AddMessage({text = msg_role, color = team_colour}, {
				text = "Your Voter " .. msg_target .. " is this role..",
        color = Color(255, 255, 255, 255)}, 
				GetConVar("ttt2_mayor_display_voter_time"):GetInt())

    	if GetConVar("ttt2_mayor_voter_chat_window"):GetInt() >= 1 then
				chat.AddText(Color(255, 255, 255, 255), "Mayor: Your Voter " .. msg_target .. " is a ".. msg_role .. ".")
			end

    end	
  end)
end

if CLIENT then
  function ROLE:AddToSettingsMenu(parent)
    local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

    form:MakeSlider({
      serverConvar = "ttt2_mayor_min_voter_time",
      label = "ttt2_mayor_min_voter_time",
      min = 1,
      max = 120,
      decimal = 0
    })

    form:MakeSlider({
      serverConvar = "ttt2_mayor_max_voter_time",
      label = "ttt2_mayor_max_voter_time",
      min = 1,
      max = 120,
      decimal = 0
    })

    form:MakeSlider({
      serverConvar = "ttt2_mayor_display_voter_time",
      label = "ttt2_mayor_display_voter_time",
      min = 1,
      max = 60,
      decimal = 0
    })

    form:MakeCheckBox({
      serverConvar = "ttt2_mayor_voter_chat_window",
      label = "ttt2_mayor_voter_chat_window"
    })

    form:MakeComboBox({
    	serverConvar = "ttt2_mayor_voter_reveal_type",
    	label = "ttt2_mayor_voter_reveal_type (F1 Menu Version Not Available)",
    	choices = {
				"0 - Voter's Role is Revealed",
				"1 - Voter's Team is Revealed",
				"2 - Voter's Role and Team are Revealed"
			},
			numStart = 0
    })

  end
end