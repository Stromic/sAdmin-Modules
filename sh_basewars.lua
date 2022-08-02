hook.Add("PostGamemodeLoaded", "sA:LoadBaseWars", function()
    if !BaseWars then return end

    sAdmin.addCommand({
        name = "setmoney",
        category = "BaseWars",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("setmoney", ply, args[1], 1)
            local amount = tonumber(args[2]) or 0

            for k,v in ipairs(targets) do
                v:SetMoney(amount)
            end

            sAdmin.msg(silent and ply or nil, "setmoney_response", ply, targets, amount)
        end
    })

    sAdmin.addCommand({
        name = "addmoney",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        category = "BaseWars",
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("addmoney", ply, args[1])
            local amount = tonumber(args[2]) or 0

            for k,v in ipairs(targets) do
                v:GiveMoney(amount)
            end

            sAdmin.msg(silent and ply or nil, "addmoney_response", ply, amount, targets)
        end
    })
    
    sAdmin.addCommand({
        name = "setlevel",
        category = "BaseWars",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("setlevel", ply, args[1], 1)
            local level = tonumber(args[2]) or 0
    
            for k,v in ipairs(targets) do
                v:SetLevel(level)
            end
    
            sAdmin.msg(silent and ply or nil, "setlevel_response", ply, targets, level)
        end
    })
    
    sAdmin.addCommand({
        name = "addlevel",
        category = "BaseWars",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("setlevel", ply, args[1], 1)
            local level = tonumber(args[2]) or 0
    
            for k,v in ipairs(targets) do
                v:AddLevel(level)
            end
    
            sAdmin.msg(silent and ply or nil, "addlevel_response", ply, level, targets)
        end
    })
    
    sAdmin.addCommand({
        name = "setxp",
        category = "BaseWars",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("setxp", ply, args[1], 1)
            local xp = tonumber(args[2]) or 0
    
            for k,v in ipairs(targets) do
                v:SetXP(xp)
            end
    
            sAdmin.msg(silent and ply or nil, "setxp_response", ply, targets, xp)
        end
    })
    
    sAdmin.addCommand({
        name = "addxp",
        category = "BaseWars",
        inputs = {{"player", "player_name"}, {"numeric", "amount"}},
        func = function(ply, args, silent)
            local targets = sAdmin.getTargets("addxp", ply, args[1], 1)
            local xp = tonumber(args[2]) or 0
    
            for k,v in ipairs(targets) do
                v:AddXP(xp)
            end
    
            sAdmin.msg(silent and ply or nil, "addxp_response", ply, xp, targets)
        end
    })

    slib.setLang("sadmin", "en", "setlevel_response", "%s set %s's level to %s.")
    slib.setLang("sadmin", "en", "addlevel_response", "%s added %s levels to %s.")
    slib.setLang("sadmin", "en", "setxp_response", "%s set %s's XP to %s.")
    slib.setLang("sadmin", "en", "addxp_response", "%s added %s XP to %s.")
        
    slib.setLang("sadmin", "en", "setlevel_help", "Set the level of specified player.")
    slib.setLang("sadmin", "en", "addlevel_help", "Add the level(s) to specified player.")
    slib.setLang("sadmin", "en", "setxp_help", "Set the XP of specified player.")
    slib.setLang("sadmin", "en", "addxp_help", "Add XP to specified player.")
end)
