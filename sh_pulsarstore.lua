sAdmin.addCommand({
    name = "ps_givecredits",
    category = "Pulsar Store",
    inputs = {{"player", "player_name"}, {"numeric", "amount"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("ps_givecredits", ply, args[1], 1)
        local amount = tonumber(args[2]) or 0
        
        for k,v in ipairs(targets) do
            Lyth_Pulsar.DB.GiveCredits(ply, v, amount)
        end

        sAdmin.msg(silent and ply or nil, "ps_givecredits_response", ply, amount, targets)
    end
})

sAdmin.addCommand({
    name = "ps_removecredits",
    category = "Pulsar Store",
    inputs = {{"player", "player_name"}, {"numeric", "amount"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("ps_removecredits", ply, args[1], 1)
        local amount = tonumber(args[2]) or 0
        
        for k,v in ipairs(targets) do
            Lyth_Pulsar.DB.GiveCredits(ply, v, -amount)
        end

        sAdmin.msg(silent and ply or nil, "ps_removecredits_response", ply, amount, targets)
    end
})

sAdmin.addCommand({
    name = "ps_setcredits",
    category = "Pulsar Store",
    inputs = {{"player", "player_name"}, {"numeric", "amount"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("ps_setcredits", ply, args[1], 1)
        local amount = tonumber(args[2]) or 0
        
        for k,v in ipairs(targets) do
            Lyth_Pulsar.SetCredits(ply, v, amount)
        end

        sAdmin.msg(silent and ply or nil, "ps_setcredits_response", ply, amount, targets)
    end
})

slib.setLang("sadmin", "en", "ps_setcredits_response", "%s set %s's credits to %s.")
slib.setLang("sadmin", "en", "ps_removecredits_response", "%s removed %s credits from %s.")
slib.setLang("sadmin", "en", "ps_givecredits_response", "%s gave %s credits to %s.")

slib.setLang("sadmin", "en", "ps_setcredits_help", "Set the credits of specified player.")
slib.setLang("sadmin", "en", "ps_removecredits_help", "Remove credits from specified player.")
slib.setLang("sadmin", "en", "ps_givecredits_help", "Add credits to specified player.")
