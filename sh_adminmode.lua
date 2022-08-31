sAdmin.addCommand({
    name = "admin",
    category = "Utility",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("admin", ply, args[1], 1)
        
        for k,v in ipairs(targets) do
            if !v:GetNWString( "is_admined", false) then
                local sid64 = v:SteamID64()
                local model = v:GetModel()
                v:SetNWString( "model", model )
                v:SetNWString( "is_admined", true )
                sAdmin.godded[sid64] = true
            else
                sAdmin.msg(ply, "in_adminmode_response", targets)
                return
            end 
        end

        sAdmin.msg(silent and ply or nil, "adminmode_response", ply, targets)
    end
})

sAdmin.addCommand({
    name = "unadmin",
    category = "Utility",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("unadmin", ply, args[1], 1)
        
        for k,v in ipairs(targets) do
            local sid64 = v:SteamID64()
            sAdmin.godded[sid64] = nil
            sAdmin.adminHandle(v)
        end

        sAdmin.msg(silent and ply or nil, "adminmode_response", ply, targets)
    end
})


slib.setLang("sadmin", "en", "adminmode_response", "%s put %s into adminmode")
slib.setLang("sadmin", "en", "in_adminmode_response", "%s is already in adminmode!")
slib.setLang("sadmin", "en", "unadminmode_response", "%s took %s out of adminmode")
