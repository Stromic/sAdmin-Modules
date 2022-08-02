hook.Add("PostGamemodeLoaded", "sA:LoadTTT", function()    
    sAdmin = sAdmin or {}
    sAdmin.TTT = sAdmin.TTT or {}
    sAdmin.TTT.SlayNR = sAdmin.TTT.SlayNR or {}

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
        inputs = {{"player", "player_name"}, {"text", "model"}},
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
        name = "slaynr",
        category = "TTT",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}, {"numeric", "to_add"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("slaynr", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0
            local to_add = tonumber(args[3]) or 0

            for k,v in ipairs(targets) do
                sAdmin.TTT.SlayNR[v] = sAdmin.TTT.SlayNR[v] or 0
                sAdmin.TTT.SlayNR[v] = to_add and sAdmin.TTT.SlayNR[v] + amount or sAdmin.TTT.SlayNR[v] - amount
            end

            sAdmin.msg(silent and ply or nil, to_add == 0 and "slaynr_response" or "slaynr_take_response", ply, amount, targets)
        end
    })

    sAdmin.addCommand({
        name = "roundrestart",
        category = "TTT",
        inputs = {{"player", "player_name"}},
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
                print(v)
            end
        end
    end)

    hook.Add("TTTBeginRound", "sA:KillNextRound", function()
        for k,v in pairs(sAdmin.TTT.SlayNR) do
            if IsValid(k) and v > 0 then
                k:Kill()

                sAdmin.TTT.SlayNR[k] = sAdmin.TTT.SlayNR[k] - 1 > 0 and sAdmin.TTT.SlayNR[k] - 1 or nil
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
    slib.setLang("sadmin", "en", "slaynr_response", "%s added %s slays to %s.")
    slib.setLang("sadmin", "en", "slaynr_take_response", "%s removed %s slays from %s.")
    slib.setLang("sadmin", "en", "roundrestart_response", "%s restarted the round.")

    slib.setLang("sadmin", "en", "swap_help", "This will swap the targetted players role to specified role or next role.")
    slib.setLang("sadmin", "en", "tospec_help", "Force specified player to spectate, to disable use unspec.")
    slib.setLang("sadmin", "en", "unspec_help", "Allow specified player play instead of spectate.")
    slib.setLang("sadmin", "en", "setkarma_help", "Set the karma of a specified player.")
    slib.setLang("sadmin", "en", "addkarma_help", "Adds karma to a specified player.")
    slib.setLang("sadmin", "en", "setcredits_help", "Set the credits of a specified player.")
    slib.setLang("sadmin", "en", "addcredits_help", "Adds credits to a specified player.")
    slib.setLang("sadmin", "en", "slaynr_help", "Slay a specified player in the next round.")
    slib.setLang("sadmin", "en", "roundrestart_help", "Restart the round.")
end)
