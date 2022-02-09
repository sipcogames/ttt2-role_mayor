-- replicated convars have to be created on both client and server
CreateConVar("ttt2_mayor_min_voter_time", 30, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_mayor_max_voter_time", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_mayor_display_voter_time", 7, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_mayor_voter_chat_window", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
CreateConVar("ttt2_mayor_voter_reveal_type", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})

hook.Add("TTTUlxDynamicRCVars", "TTTUlxDynamicMayorCVars", function(tbl)
	tbl[ROLE_MAYOR] = tbl[ROLE_MAYOR] or {}

	table.insert(tbl[ROLE_MAYOR], {
		cvar = "ttt2_mayor_min_voter_time",
		slider = true,
		min = 0,
		max = 120,
		decimal = 0,
		desc = "ttt2_mayor_min_voter_time (def. 30)"
	})
	table.insert(tbl[ROLE_MAYOR], {
		cvar = "ttt2_mayor_max_voter_time",
		slider = true,
		min = 0,
		max = 120,
		decimal = 0,
		desc = "ttt2_mayor_max_voter_time (def. 60)"
	})
	table.insert(tbl[ROLE_MAYOR], {
		cvar = "ttt2_mayor_display_voter_time",
		slider = true,
		min = 0,
		max = 60,
		decimal = 0,
		desc = "ttt2_mayor_display_voter_time (def. 7)"
	})
	table.insert(tbl[ROLE_MAYOR], {
		cvar = "ttt2_mayor_voter_chat_window",
		checkbox = true,
		desc = "ttt2_mayor_voter_chat_window (def. 1)"
	})

	table.insert(tbl[ROLE_MAYOR], {
		cvar = "ttt2_mayor_voter_reveal_type",
		combobox = true,
		desc = "ttt2_mayor_voter_reveal_type (Def: 1)",
		choices = {
			"0 - Voter's Role is Revealed",
			"1 - Voter's Team is Revealed",
			"2 - Voter's Role and Team are Revealed"
		},
		numStart = 0
	})
end)
