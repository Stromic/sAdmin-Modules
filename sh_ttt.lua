sAdmin = sAdmin or {}
sAdmin.TTT = sAdmin.TTT or {}
sAdmin.TTT.SlayNR = sAdmin.TTT.SlayNR or {}

local roles = {
    ["innocent"] = ROLE_INNOCENT,
    ["traitor"] = ROLE_TRAITOR,
    ["detective"] = ROLE_DETECTIVE
}

sAdmin.addCommand({
    name = "swap",
    category = "TTT",
    inputs = {{"player", "player_name"}, {"text", "model"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("swap", ply, args[1], 1)
        local role = args[2]

        for k,v in ipairs(targets) do
            local nextRole = ((tonumber(v:GetRole()) or -1) + 1)
            nextRole = nextRole > 2 and 0 or nextRole

            v:SetRole(role and roles[string.lower(role)] or nextRole)
        end

        SendFullStateUpdate()

        sAdmin.msg(silent and ply or nil, "swap_response", ply, amount, steamId)
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
        
        sAdmin.msg(silent and ply or nil, "tospec_response", ply, amount, steamId)
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
        
        sAdmin.msg(silent and ply or nil, "unspec_response", ply, amount, steamId)
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

        sAdmin.msg(silent and ply or nil, "addkarma_response", ply, targets, amount)
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

        sAdmin.msg(silent and ply or nil, "addcredits_response", ply, targets, amount)
    end
})


sAdmin.addCommand({
    name = "slaynr",
    category = "TTT",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("slaynr", ply, args[1], 1)
        local amount = tonumber(args[2]) or 0

        for k,v in ipairs(targets) do
            Admin.TTT.SlayNR[v] = true
        end

        sAdmin.msg(silent and ply or nil, "slaynr_response", ply, targets, amount)
    end
})

sAdmin.addCommand({
    name = "roundrestart",
    category = "TTT",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        BeginRound()

        sAdmin.msg(silent and ply or nil, "roundrestart_response", ply, targets, amount)
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
        if IsValid(k) then
            k:Kill()
        end
    end

    Admin.TTT.SlayNR = {}
end)

slib.setLang("sadmin", "en", "swap_response", "%s set %s's role to %s.")
slib.setLang("sadmin", "en", "tospec_response", "%s set %s to spectator.")
slib.setLang("sadmin", "en", "unspec_response", "%s unset %s to spectator.")
slib.setLang("sadmin", "en", "setkarma_response", "%s set %s's karma to %s.")
slib.setLang("sadmin", "en", "addkarma_response", "%s added to %s's karma.")
slib.setLang("sadmin", "en", "setcredits_response", "%s set %s's credits to %s.")
slib.setLang("sadmin", "en", "addcredits_response", "%s added to %s's credits.")
slib.setLang("sadmin", "en", "slaynr_response", "%s set %s to be slayed next round.")
slib.setLang("sadmin", "en", "roundrestart_response", "%s restarted the round.")

slib.setLang("sadmin", "en", "swap_response", "This will swap the targetted players role to specified role or next role.")
slib.setLang("sadmin", "en", "tospec_response", "Force specified player to spectate, to disable use unspec.")
slib.setLang("sadmin", "en", "unspec_response", "Allow specified player play instead of spectate.")
slib.setLang("sadmin", "en", "setkarma_response", "Set the karma of a specified player.")
slib.setLang("sadmin", "en", "addkarma_response", "Adds karma to a specified player.")
slib.setLang("sadmin", "en", "setcredits_response", "Set the credits of a specified player.")
slib.setLang("sadmin", "en", "addcredits_response", "Adds credits to a specified player.")
slib.setLang("sadmin", "en", "slaynr_response", "Slay a specified player in the next round.")
slib.setLang("sadmin", "en", "roundrestart_response", "Restart the round.")
