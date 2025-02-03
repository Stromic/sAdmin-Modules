hook.Add("PostGamemodeLoaded", "sA:LoadTTT", function()    
    local roles = {
        ["innocent"] = ROLE_INNOCENT,
        ["traitor"] = ROLE_TRAITOR,
        ["detective"] = ROLE_DETECTIVE
    }

    local rolesToTxt = {
        [ROLE_INNOCENT] = "Innocent",
        [ROLE_TRAITOR] = "Traitor",
        [ROLE_DETECTIVE] = "Detective"
    }

    sAdmin.addCommand({
        name = "swap",
        category = "TTT",
        inputs = {{"player", "player_name"}, {"text", "role"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("swap", ply, args[1], 1)
            local role = args[2]
            local roleSelected = ""

            for k,v in ipairs(targets) do
                local nextRole = ((tonumber(v:GetRole()) or -1) + 1)
                nextRole = nextRole > 2 and 0 or nextRole

                roleSelected = rolesToTxt[role and roles[string.lower(role)] or nextRole]
                v:SetRole(role and roles[string.lower(role)] or nextRole)
            end

            SendFullStateUpdate()

            sAdmin.msg(silent and ply or nil, "swap_response", ply, targets, roleSelected)
        end
    })

    sAdmin.addCommand({
        name = "tospec",
        category = "TTT",
        inputs = {{"player", "player_name"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("tospec", ply, args[1], 1)
            local role = args[2]

            for k,v in ipairs(targets) do
                if not v:IsSpec() then
                    v:Kill()
                end
        
                GAMEMODE:PlayerSpawnAsSpectator(v)
                v:SetTeam(TEAM_SPEC)
                v:SetForceSpec(true)
                v:Spawn()
        
                v:SetRagdollSpec(false)
            end
            
            sAdmin.msg(silent and ply or nil, "tospec_response", ply, targets)
        end
    })

    sAdmin.addCommand({
        name = "unspec",
        category = "TTT",
        inputs = {{"player", "player_name"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("unspec", ply, args[1], 1)
            local role = args[2]

            for k,v in ipairs(targets) do
                ply:SetForceSpec(false)
            end
            
            sAdmin.msg(silent and ply or nil, "unspec_response", ply, targets)
        end
    })

    sAdmin.addCommand({
        name = "setkarma",
        category = "TTT",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("setkarma", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0

            for k,v in ipairs(targets) do
                v:SetBaseKarma(amount)
                v:SetLiveKarma(amount)
                KARMA.ApplyKarma(v)
            end

            sAdmin.msg(silent and ply or nil, "setkarma_response", ply, targets, amount)
        end
    })

    sAdmin.addCommand({
        name = "addkarma",
        category = "TTT",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("addkarma", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0

            for k,v in ipairs(targets) do
                v:SetBaseKarma(v:GetBaseKarma() + amount)
                v:SetLiveKarma(v:GetLiveKarma() + amount)
                KARMA.ApplyKarma(v)
            end

            sAdmin.msg(silent and ply or nil, "addkarma_response", ply, amount, targets)
        end
    })

    sAdmin.addCommand({
        name = "setcredits",
        category = "TTT",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("addcredits", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0

            for k,v in ipairs(targets) do
                v:SetCredits(amount)
            end

            sAdmin.msg(silent and ply or nil, "setcredits_response", ply, targets, amount)
        end
    })


    sAdmin.addCommand({
        name = "addcredits",
        category = "TTT",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("addcredits", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0

            for k,v in ipairs(targets) do
                v:AddCredits(amount)
            end

            sAdmin.msg(silent and ply or nil, "addcredits_response", ply, amount, targets)
        end
    })


    sAdmin.addCommand({
        name = "setslaynr",
        category = "TTT",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("setslaynr", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0

            for k,v in ipairs(targets) do
                v:SetPData("sA:SlaysNR", amount)
            end

            sAdmin.msg(silent and ply or nil, "setslaynr_response", ply, targets, amount)
        end
    })

    sAdmin.addCommand({
        name = "addslaynr",
        category = "TTT",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("addslaynr", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0

            for k,v in ipairs(targets) do
                v:SetPData("sA:SlaysNR", v:GetPData("sA:SlaysNR", 0) + amount)
            end

            sAdmin.msg(silent and ply or nil, "addslaynr_response", ply, amount, targets)
        end
    })

    sAdmin.addCommand({
        name = "roundrestart",
        category = "TTT",
        inputs = {},
        func = function(ply, args, silent)
            RunConsoleCommand("ttt_roundrestart")

            sAdmin.msg(silent and ply or nil, "roundrestart_response", ply)
        end
    })

    hook.Add("sA:RanCommand", "sA:TTTIntegration", function(ply, name, args)
        if name == "respawn" then
            local targets = sAdmin.getTargets("respawn", ply, args[1], 1)

            for k,v in ipairs(targets) do
                v:SpawnForRound(true)
            end
        end
    end)

    hook.Add("TTTBeginRound", "sA:KillNextRound", function()
        for k,v in ipairs(player.GetAll()) do
            local slays = v:GetPData("sA:SlaysNR", 0)

            if slays > 0 then
                v:Kill()
                v:SetPData("sA:SlaysNR", slays - 1)
            end
        end
    end)

    slib.setLang("sadmin", "en", "swap_response", "%s set %s's role to %s.")
    slib.setLang("sadmin", "en", "tospec_response", "%s set %s to spectator.")
    slib.setLang("sadmin", "en", "unspec_response", "%s unset %s from spectator.")
    slib.setLang("sadmin", "en", "setkarma_response", "%s set %s's karma to %s.")
    slib.setLang("sadmin", "en", "addkarma_response", "%s added %s to %s's karma.")
    slib.setLang("sadmin", "en", "setcredits_response", "%s set %s's credits to %s.")
    slib.setLang("sadmin", "en", "addcredits_response", "%s added %s to %s's credits.")
    slib.setLang("sadmin", "en", "setslaynr_response", "%s set %s to be slayed for the next %s rounds.")
    slib.setLang("sadmin", "en", "addslaynr_response", "%s added %s next round slays to %s.")
    slib.setLang("sadmin", "en", "roundrestart_response", "%s restarted the round.")

    slib.setLang("sadmin", "en", "swap_help", "This will swap the targetted players role to specified role or next role.")
    slib.setLang("sadmin", "en", "tospec_help", "Force specified player to spectate, to disable use unspec.")
    slib.setLang("sadmin", "en", "unspec_help", "Allow specified player play instead of spectate.")
    slib.setLang("sadmin", "en", "setkarma_help", "Set the karma of a specified player.")
    slib.setLang("sadmin", "en", "addkarma_help", "Adds karma to a specified player.")
    slib.setLang("sadmin", "en", "setcredits_help", "Set the credits of a specified player.")
    slib.setLang("sadmin", "en", "addcredits_help", "Adds credits to a specified player.")
    slib.setLang("sadmin", "en", "setslaynr_help", "Set how many rounds to slay specified player.")
    slib.setLang("sadmin", "en", "addslaynr_help", "Add how many rounds to slay specified player.")
    slib.setLang("sadmin", "en", "roundrestart_help", "Restart the round.")
end)
