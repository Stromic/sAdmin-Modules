if engine.ActiveGamemode() ~= "terrortown" then return end

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

    sAdmin.GetRoles = function()
        return {"innocent", "traitor", "detective"}
    end

    sAdmin.addCommand({
        name = "swap",
        category = "TTT",
        inputs = {
            {"player", "player_name"},
            {"dropdown", "role", sAdmin.GetRoles}
        },
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("swap", ply, args[1], 1)
            local role = args[2]

            if not roles[role] then
                sAdmin.msg(ply, "invalid_role")

                return
            end

            for k, v in ipairs(targets) do
                v:SetRole(roles[role])
            end

            SendFullStateUpdate()
            sAdmin.msg(silent and ply or nil, "swap_response", ply, targets, role)
        end
    })

    sAdmin.GetSpectatorStates = function()
        return {"Spectator", "Player"}
    end

    sAdmin.addCommand({
        name = "specmode",
        category = "TTT",
        inputs = {
            {"player", "player_name"},
            {"dropdown", "mode", sAdmin.GetSpectatorStates}
        },
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("specmode", ply, args[1], 1)
            local mode = args[2]

            for k, v in ipairs(targets) do
                if mode == "Spectator" then
                    if not v:IsSpec() then
                        v:Kill()
                    end

                    GAMEMODE:PlayerSpawnAsSpectator(v)
                    v:SetTeam(TEAM_SPEC)
                    v:SetForceSpec(true)
                    v:Spawn()
                    v:SetRagdollSpec(false)
                else
                    v:SetForceSpec(false)
                end
            end

            sAdmin.msg(silent and ply or nil, "specmode_response", ply, targets, mode)
        end
    })

    sAdmin.addCommand({
        name = "setkarma",
        category = "TTT",
        inputs = {
            {"player", "player_name"},
            {"numeric", "amount"}
        },
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("setkarma", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0

            for k, v in ipairs(targets) do
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
        inputs = {
            {"player", "player_name"},
            {"numeric", "amount"}
        },
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("addkarma", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0

            for k, v in ipairs(targets) do
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
        inputs = {
            {"player", "player_name"},
            {"numeric", "amount"}
        },
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("addcredits", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0

            for k, v in ipairs(targets) do
                v:SetCredits(amount)
            end

            sAdmin.msg(silent and ply or nil, "setcredits_response", ply, targets, amount)
        end
    })

    sAdmin.addCommand({
        name = "addcredits",
        category = "TTT",
        inputs = {
            {"player", "player_name"},
            {"numeric", "amount"}
        },
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("addcredits", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0

            for k, v in ipairs(targets) do
                v:AddCredits(amount)
            end

            sAdmin.msg(silent and ply or nil, "addcredits_response", ply, amount, targets)
        end
    })

    sAdmin.addCommand({
        name = "setslaynr",
        category = "TTT",
        inputs = {
            {"player", "player_name"},
            {"numeric", "amount"},
            {"text", "reason"}
        },
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("setslaynr", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0
            local reason = args[3] or slib.getLang("sadmin", sAdmin.config["language"], "no_reason_provided")

            for k, v in ipairs(targets) do
                v:SetPData("sA:SlaysNR", amount)
            end

            sAdmin.msg(silent and ply or nil, "setslaynr_response", ply, targets, amount, reason)
        end
    })

    sAdmin.addCommand({
        name = "addslaynr",
        category = "TTT",
        inputs = {
            {"player", "player_name"},
            {"numeric", "amount"},
            {"text", "reason"}
        },
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("addslaynr", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0
            local reason = args[3] or slib.getLang("sadmin", sAdmin.config["language"], "no_reason_provided")

            for k, v in ipairs(targets) do
                v:SetPData("sA:SlaysNR", v:GetPData("sA:SlaysNR", 0) + amount)
            end

            sAdmin.msg(silent and ply or nil, "addslaynr_response", ply, targets, amount, reason)
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

            for k, v in ipairs(targets) do
                v:SpawnForRound(true)
            end
        end
    end)

    hook.Add("PlayerDeath", "sA:NotifySlay", function(victim, inflictor, attacker)
        if IsValid(victim) then
            local slays = tonumber(victim:GetPData("sA:SlaysNR", 0))

            if slays > 0 then
                victim:SetPData("sA:SlaysNR", slays - 1)
            end
        end
    end)

    hook.Add("TTTBeginRound", "sA:KillNextRound", function()
        for k, v in ipairs(player.GetAll()) do
            local slays = tonumber(v:GetPData("sA:SlaysNR", 0))

            if slays > 0 then
                v:Kill()
                v:SetPData("sA:SlaysNR", slays - 1)
                sAdmin.msg(v, "slay_message", slays - 1)
            end
        end
    end)

    slib.setLang("sadmin", "en", "swap_response", "%s set %s's role to %s.")
    slib.setLang("sadmin", "en", "specmode_response", "%s set %s to %s mode.")
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
    slib.setLang("sadmin", "en", "slay_message", "You will be slain %s more time(s).")
    slib.setLang("sadmin", "en", "roundrestart_help", "Restart the round.")
    --ru
    slib.setLang("sadmin", "ru", "swap_response", "%s установил роль %s как %s.")
    slib.setLang("sadmin", "ru", "specmode_response", "%s перевёл %s в режим %s.")
    slib.setLang("sadmin", "ru", "setkarma_response", "%s установил карму %s равной %s.")
    slib.setLang("sadmin", "ru", "addkarma_response", "%s добавил %s к карме %s.")
    slib.setLang("sadmin", "ru", "setcredits_response", "%s установил количество кредитов %s равным %s.")
    slib.setLang("sadmin", "ru", "addcredits_response", "%s добавил %s к кредитам %s.")
    slib.setLang("sadmin", "ru", "setslaynr_response", "%s установил для %s казнь на следующих %s раундах.")
    slib.setLang("sadmin", "ru", "addslaynr_response", "%s добавил казнь %s на следующий раунд для %s.")
    slib.setLang("sadmin", "ru", "roundrestart_response", "%s перезапустил раунд.")
    slib.setLang("sadmin", "ru", "swap_help", "Это поменяет роль целевого игрока на указанную роль или следующую роль.")
    slib.setLang("sadmin", "ru", "tospec_help", "Заставить указанного игрока наблюдать, для отмены используйте unspec.")
    slib.setLang("sadmin", "ru", "unspec_help", "Позволить указанному игроку играть, а не наблюдать.")
    slib.setLang("sadmin", "ru", "setkarma_help", "Установить карму указанного игрока.")
    slib.setLang("sadmin", "ru", "addkarma_help", "Добавить карму указанному игроку.")
    slib.setLang("sadmin", "ru", "setcredits_help", "Установить кредиты указанного игрока.")
    slib.setLang("sadmin", "ru", "addcredits_help", "Добавить кредиты указанному игроку.")
    slib.setLang("sadmin", "ru", "setslaynr_help", "Установить, сколько раундов убивать указанного игрока.")
    slib.setLang("sadmin", "ru", "addslaynr_help", "Добавить, сколько раундов убивать указанного игрока.")
    slib.setLang("sadmin", "ru", "slay_message", "Вас убьет еще %s раз(а).")
    slib.setLang("sadmin", "ru", "roundrestart_help", "Перезапустить раунд.")
end)
