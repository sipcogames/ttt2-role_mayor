L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[MAYOR.name] = "Mayor"
L["info_popup_" .. MAYOR.name] = [[You are the Mayor!
Survive with the innocents, and remember to check your voter list.]]
L["body_found_" .. MAYOR.abbr] = "They were an Mayor."
L["search_role_" .. MAYOR.abbr] = "This person was an Mayor!"
L["target_" .. MAYOR.name] = "Mayor"
L["ttt2_desc_" .. MAYOR.name] = [[The Mayor needs to win with the innocents!]]

--Convar Lang
L["ttt2_mayor_min_voter_time"] = "Minimum time between voter reveals (sec)"
L["ttt2_mayor_max_voter_time"] = "Maximum time between voter reveals (sec)"
L["ttt2_mayor_display_voter_time"] = "How long to show the Role (sec)"
L["ttt2_mayor_voter_chat_window"] = "Display result in chat as well?"
L["ttt2_mayor_voter_reveal_type"] = "How Voters are Revealed"