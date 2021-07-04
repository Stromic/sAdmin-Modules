sAdmin.addCommand({
    name = "setlevel",
    category = "DarkRP",
    inputs = {{"player", "player_name"}, {"numeric", "amount"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("setlevel", ply, args[1], 1)
        local level = tonumber(args[2]) or 0

        for k,v in ipairs(targets) do
            v:setXP(0)
            v:setLevel(level)
        end

        sAdmin.msg(silent and ply or nil, "setlevel_response", ply, targets, level)
    end
})

sAdmin.addCommand({
    name = "setxp",
    category = "DarkRP",
    inputs = {{"player", "player_name"}, {"numeric", "amount"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("setlevel", ply, args[1], 1)
        local xp = tonumber(args[2]) or 0

        for k,v in ipairs(targets) do
            v:setXP(xp)
        end

        sAdmin.msg(silent and ply or nil, "setxp_response", ply, targets, xp)
    end
})

sAdmin.addCommand({
    name = "addxp",
    category = "DarkRP",
    inputs = {{"player", "player_name"}, {"numeric", "amount"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("setlevel", ply, args[1], 1)
        local xp = tonumber(args[2]) or 0

        for k,v in ipairs(targets) do
            v:addXP(xp)
        end

        sAdmin.msg(silent and ply or nil, "addxp_response", ply, xp, targets)
    end
})


slib.setLang("sadmin", "en", "setlevel_response", "%s set %s's level to %s.")
slib.setLang("sadmin", "en", "setxp_response", "%s set %s's XP to %s.")
slib.setLang("sadmin", "en", "addxp_response", "%s added %s XP to %s.")
