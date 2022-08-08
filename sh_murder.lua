sAdmin.addCommand({
    name = "tospec",
    category = "Murder",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("tospec", ply, args[1], 1)
        local role = args[2]

        for k,v in ipairs(targets) do
            if v:Team() != 1 then
                v:SetTeam(1)
                GAMEMODE:PlayerOnChangeTeam(v, 1, curTeam)
        
                local msgs = Translator:AdvVarTranslate(translate.teamMoved, {
                    player = {text = v:Nick(), color = team.GetColor(curTeam)},
                    team = {text = team.GetName(1), color = team.GetColor(1)}
                })
                local ct = ChatText()
                ct:AddParts(msgs)
                ct:SendAll()
            end
        end
        
        sAdmin.msg(silent and ply or nil, "tospec_response", ply, targets)
    end
})

sAdmin.addCommand({
    name = "forcemurderer",
    category = "Murder",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("forcemurderer", ply, args[1], 1)
        local entIndex

        for k,v in ipairs(targets) do
            entIndex = v:EntIndex()
        end

        RunConsoleCommand( "mu_forcenextmurderer "..entIndex )
        
        sAdmin.msg(silent and ply or nil, "forcemurderer_response", ply, targets)
    end
})

sAdmin.addCommand({
    name = "setslaynr",
    category = "Murder",
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
    category = "Murder",
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
    category = "Murder",
    inputs = {},
    func = function(ply, args, silent)
        GAMEMODE:EndTheRound()
        GAMEMODE:StartNewRound()

        sAdmin.msg(silent and ply or nil, "roundrestart_response", ply)
    end
})

sAdmin.addCommand({
    name = "mapnr",
    category = "Murder",
    inputs = {{"text", "map"}},
    func = function(ply, args, silent)
        local map = args[1]
        sAdmin.MapNR = map

        sAdmin.msg(silent and ply or nil, "mapnr_response", ply, map)
    end
})

sAdmin.addCommand({
    name = "givemagnum",
    category = "Murder",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("givemagnum", ply, args[1], 1)

        for k,v in ipairs(targets) do
            v:Give("weapon_mu_magnum")
        end

        sAdmin.msg(silent and ply or nil, "givemagnum_response", ply, targets)
    end
})

sAdmin.addCommand({
    name = "takemagnum",
    category = "Murder",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("takemagnum", ply, args[1], 1)

        for k,v in ipairs(targets) do
            if v:HasWeapon("weapon_mu_magnum") then
                v:StripWeapon("weapon_mu_magnum")
            end
        end

        sAdmin.msg(silent and ply or nil, "takemagnum_response", ply, targets[1]:Nick())
    end
})

hook.Add("sA:RunCommand", "sA:MurderIntegration", function(ply, name, args) -- Override the default respawn command.
    if name == "respawn" then
        if IsValid(ply) and !sAdmin.hasPermission(ply, name) then
            sAdmin.msg(ply, "no_permission", name)
        return false end

        local targets = sAdmin.getTargets("respawn", ply, args[1], 1)
        local stopCmd = false

        for k,v in ipairs(targets) do
            if v:Team() ~= 2 then
                sAdmin.msg(ply, "cannot_respawn_spectator")

                stopCmd = true
            return end

            v:Spectate(OBS_MODE_NONE)
            v:Spawn()
        end

        if stopCmd then return false end
        
        sAdmin.msg(silent and ply or nil, "respawn_response", ply, targets)
        
        return "" -- This will simply not run the function, but act as if it was ran.
    end
end)

hook.Add("OnStartRound", "sA:KillNextRound", function()
    if sAdmin.MapNR then
        RunConsoleCommand("map "..sAdmin.MapNR)
    end

    timer.Simple(3, function()
        for k,v in ipairs(player.GetAll()) do
            local slays = v:GetPData("sA:SlaysNR", 0)

            if slays > 0 then
                v:Kill()
                v:SetPData("sA:SlaysNR", slays - 1)
            end
        end
    end)
end)

slib.setLang("sadmin", "en", "cannot_respawn_spectator", "You cannot respawn a spectator.")

slib.setLang("sadmin", "en", "tospec_response", "%s set %s to spectator.")
slib.setLang("sadmin", "en", "forcemurderer_response", "%s forced %s to be the murderer in the next round.")
slib.setLang("sadmin", "en", "mapnr_response", "%s set the map to be changed in the next round to %s.")
slib.setLang("sadmin", "en", "setslaynr_response", "%s set %s to be slayed for the next %s rounds.")
slib.setLang("sadmin", "en", "addslaynr_response", "%s added %s next round slays to %s.")
slib.setLang("sadmin", "en", "roundrestart_response", "%s restarted the round.")
slib.setLang("sadmin", "en", "givemagnum_response", "%s gave %s a magnum.")
slib.setLang("sadmin", "en", "takemagnum_response", "%s stripped %s's magnum.")

slib.setLang("sadmin", "en", "forcemurderer_response", "This will force the targetted players role to be the murderer next round.")
slib.setLang("sadmin", "en", "tospec_help", "Force specified player to spectate.")
slib.setLang("sadmin", "en", "mapnr_response", "Set the map in the next round.")
slib.setLang("sadmin", "en", "setslaynr_help", "Set how many rounds to slay specified player.")
slib.setLang("sadmin", "en", "addslaynr_help", "Add how many rounds to slay specified player.")
slib.setLang("sadmin", "en", "roundrestart_help", "Restart the round.")
slib.setLang("sadmin", "en", "givemagnum_help", "Give a magnum to specified player.")
slib.setLang("sadmin", "en", "takemagnum_help", "Strip magnum from specified player.")
