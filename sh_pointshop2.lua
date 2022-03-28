sAdmin.registerPermission("pointshop2 manageitems", "Pointshop 2", false, false)
sAdmin.registerPermission("pointshop2 createitems", "Pointshop 2", false, false)
sAdmin.registerPermission("pointshop2 manageusers", "Pointshop 2", false, false)
sAdmin.registerPermission("pointshop2 managemodules", "Pointshop 2", false, false)
sAdmin.registerPermission("pointshop2 exportimport", "Pointshop 2", false, false)
sAdmin.registerPermission("pointshop2 manageservers", "Pointshop 2", false, false)
sAdmin.registerPermission("pointshop2 reset", "Pointshop 2", false, false)
sAdmin.registerPermission("pointshop2 usepac", "Pointshop 2", false, false)

sAdmin.addCommand({
    name = "ps2_addpoints_steamid",
    category = "Pointshop 2",
    inputs = {{"text", "sid64/sid"}, {"numeric", "amount"}},
    func = function(ply, args, silent)
        local steamId = args[1]
        local amount = tonumber(args[2]) or 0
        local currencyType = "points"

        Pointshop2Controller:getInstance( ):addPointsBySteamId( steamId, currencyType, amount )
        :Fail( function( errid, err )
            KLogf( 2, "[Pointshop 2] ERROR: Couldn't give %i %s to %s, %i - %s", amount, currencyType, steamId, errid, err )
        end )
        :Done( function( )
            KLogf( 4, "[Pointshop 2] %s gave %i %s to %s", "CONSOLE", amount, currencyType, steamId )
        end )

        sAdmin.msg(silent and ply or nil, "ps2_addpoints_steamid_response", ply, amount, steamId)
    end
})

sAdmin.addCommand({
    name = "ps2_addpremiumpoints_steamid",
    category = "Pointshop 2",
    inputs = {{"text", "sid64/sid"}, {"numeric", "amount"}},
    func = function(ply, args, silent)
        local steamId = args[1]
        local amount = tonumber(args[2]) or 0
        local currencyType = "premiumPoints"

        Pointshop2Controller:getInstance( ):addPointsBySteamId( steamId, currencyType, amount )
        :Fail( function( errid, err )
            KLogf( 2, "[Pointshop 2] ERROR: Couldn't give %i %s to %s, %i - %s", amount, currencyType, steamId, errid, err )
        end )
        :Done( function( )
            KLogf( 4, "[Pointshop 2] %s gave %i %s to %s", "CONSOLE", amount, currencyType, steamId )
        end )

        sAdmin.msg(silent and ply or nil, "ps2_addpremiumpoints_steamid_response", ply, amount, steamId)
    end
})

sAdmin.addCommand({
    name = "ps2_addpoints",
    category = "Pointshop 2",
    inputs = {{"player", "player_name"}, {"numeric", "amount"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("ps2_addpoints", ply, args[1], 1)
        local amount = tonumber(args[2]) or 0
        local currencyType = "points"
        
        for k,v in ipairs(targets) do
            local steamId = v:SteamID()
            Pointshop2Controller:getInstance( ):addPointsBySteamId( steamId, currencyType, amount )
            :Fail( function( errid, err )
                KLogf( 2, "[Pointshop 2] ERROR: Couldn't give %i %s to %s, %i - %s", amount, currencyType, steamId, errid, err )
            end )
            :Done( function( )
                KLogf( 4, "[Pointshop 2] %s gave %i %s to %s", "CONSOLE", amount, currencyType, steamId )
            end )
        end

        sAdmin.msg(silent and ply or nil, "ps2_addpoints_response", ply, amount, targets)
    end
})

sAdmin.addCommand({
    name = "ps2_addpremiumpoints",
    category = "Pointshop 2",
    inputs = {{"player", "player_name"}, {"numeric", "amount"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("ps2_addpremiumpoints", ply, args[1], 1)
        local amount = tonumber(args[2]) or 0
        local currencyType = "premiumPoints"
        
        for k,v in ipairs(targets) do
            local steamId = v:SteamID()
            Pointshop2Controller:getInstance( ):addPointsBySteamId( steamId, currencyType, amount )
            :Fail( function( errid, err )
                KLogf( 2, "[Pointshop 2] ERROR: Couldn't give %i %s to %s, %i - %s", amount, currencyType, steamId, errid, err )
            end )
            :Done( function( )
                KLogf( 4, "[Pointshop 2] %s gave %i %s to %s", "CONSOLE", amount, currencyType, steamId )
            end )
        end

        sAdmin.msg(silent and ply or nil, "ps2_addpremiumpoints_response", ply, amount, targets)
    end
})

slib.setLang("sadmin", "en", "ps2_addpoints_steamid_response", "%s added %s points to %s.")
slib.setLang("sadmin", "en", "ps2_addpremiumpoints_steamid_response", "%s added %s premium points to %s.")
slib.setLang("sadmin", "en", "ps2_addpoints_response", "%s added %s points to %s.")
slib.setLang("sadmin", "en", "ps2_addpremiumpoints_response", "%s added %s premium points to %s.")
