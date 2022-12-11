sAdmin.secondary_rank_timeleft = sAdmin.secondary_rank_timeleft or {}

local function storeSecondaryRank(sid64, new_rank, time, no_save)
    local ply = slib.sid64ToPly[sid64]

    if !no_save then
        if new_rank != "" then
            local expire = time > 0 and os.time() + time or time
            file.CreateDir("sadmin/secondaryrank")
            file.Write("sadmin/secondaryrank/"..sid64..".json", util.TableToJSON({rank = new_rank, expiry = expire}))
        else
            file.Delete("sadmin/secondaryrank/"..sid64..".json", result)
        end
    end

    if IsValid(ply) then
        ply:SetNWString("sA:SecondaryRank", new_rank)

        if time and time > 0 then
            sAdmin.secondary_rank_timeleft[ply] = time

            timer.Create("sA:RevertSecondaryRank_"..sid64, time, 1, function() storeSecondaryRank(sid64, "") end)
        end
    end
end

sAdmin.addCommand({
    name = "setsecondaryrank",
    category = "Secondary Rank",
    inputs = {{"player", "player_name"}, {"dropdown", "rank", sAdmin.GetRanks}, {"time"}},
    func = function(ply, args, silent)
        local targets, rank, time = sAdmin.getTargets("setsecondaryrank", ply, args[1], 1), args[2], sAdmin.getTime(args, 3)

        if !rank or !time then sAdmin.msg(ply, "invalid_arguments") return end
        if !sAdmin.usergroups[rank] then sAdmin.msg(ply, "invalid_usergroup") return end

        for k,v in ipairs(targets) do
            local sid64 = v:SteamID64()

            storeSecondaryRank(sid64, rank, time)
        end

        sAdmin.msg(silent and ply or nil, "setsecondaryrank_response", ply, targets, rank, time)
    end
})

sAdmin.addCommand({
    name = "setsecondaryrankid",
    category = "Management",
    inputs = {{"text", "sid64/sid"}, {"dropdown", "rank", sAdmin.GetRanks}, {"time"}},
    func = function(ply, args, silent)
        local sid64 = sAdmin.convertSID64(args[1])
        if !sid64 then return end
        local rank, time = args[2], sAdmin.getTime(args, 3)

        if !rank or !time then sAdmin.msg(ply, "invalid_arguments") return end
        if !sAdmin.usergroups[rank] then sAdmin.msg(ply, "invalid_usergroup") return end

        storeSecondaryRank(sid64, rank, time)

        sAdmin.msg(silent and ply or nil, "setsecondaryrankid_response", ply, sid64, rank, time)
    end
})

sAdmin.addCommand({
    name = "removesecondaryrank",
    category = "Secondary Rank",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("removesecondaryrank", ply, args[1])
        local time = sAdmin.getTime(args, 2)

        for k,v in ipairs(targets) do
            local sid64 = v:SteamID64()

            storeSecondaryRank(sid64, "")
        end

        sAdmin.msg(silent and ply or nil, "removesecondaryrank_response", ply, targets)
    end
})

sAdmin.addCommand({
    name = "removesecondaryrankid",
    category = "Management",
    inputs = {{"text", "sid64/sid"}},
    func = function(ply, args, silent)
        local sid64 = sAdmin.convertSID64(args[1])
        if !sid64 then return end
        local rank, time = args[2], sAdmin.getTime(args, 3)

        if !rank or !time then sAdmin.msg(ply, "invalid_arguments") return end
        if !sAdmin.usergroups[rank] then sAdmin.msg(ply, "invalid_usergroup") return end

        storeSecondaryRank(sid64, "", time)

        sAdmin.msg(silent and ply or nil, "removesecondaryrankid_response", ply, sid64)
    end
})

sAdmin.addCommand({
    name = "secondaryrank",
    category = "Utility",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("secondaryrank", ply, args[1], 1)

        local target

        for k,v in ipairs(targets) do
            target = v
            
            break
        end

        if !target then return end

        local secondary_rank = target:GetSecondaryUserGroup()
        local timeleft = sAdmin.secondary_rank_timeleft[target]

        if secondary_rank and secondary_rank != "" then
            sAdmin.msg(ply, "secondaryrank_response", target:Nick(), secondary_rank, timeleft and sAdmin.formatTime(timeleft, true) or slib.getLang("sadmin", sAdmin.config["language"], "eternity"))
        else
            sAdmin.msg(ply, "secondaryrank_norank_response", target:Nick())
        end
    end
})

hook.Add("slib.FullLoaded", "sA:LoadSecondaryRank", function(ply)
    local sid64 = ply:SteamID64()
    local data = file.Read("sadmin/secondaryrank/"..sid64..".json", "DATA")
    
    if data then
        local tbl = util.JSONToTable(data)

        if tbl.rank then
            tbl.expiry = tonumber(tbl.expiry) or 0            
            
            local timeLeft = tbl.expiry - os.time()

            if tbl.expiry > 0 and timeLeft <= 0 then
                storeSecondaryRank(sid64, "")
            return end

            storeSecondaryRank(sid64, tbl.rank, timeLeft, true)
        end
    end
end)

local meta = FindMetaTable("Player")

function meta:GetSecondaryUserGroup()
    return self:GetNWString("sA:SecondaryRank", "")
end


function meta:SetSecondaryUserGroup(usergroup, time) -- The time in here is in seconds.
    if SERVER then
        storeSecondaryRank(self:SteamID64(), usergroup, time or 0)
    end

    self:SetNWString("sA:SecondaryRank", usergroup)
end

slib.setLang("sadmin", "en", "secondaryrank_response", "%s's secondary rank is %s for %s.")
slib.setLang("sadmin", "en", "secondaryrank_norank_response", "%s doesnt have a secondary rank.")

slib.setLang("sadmin", "en", "setsecondaryrank_response", "%s set the secondary rank for %s to %s for %t.")
slib.setLang("sadmin", "en", "setsecondaryrankid_response", "%s set the secondary rank for %s to %s for %t.")
slib.setLang("sadmin", "en", "removesecondaryrank_response", "%s removed %s's secondary rank.")
slib.setLang("sadmin", "en", "removesecondaryrankid_response", "%s removed %s's secondary rank.")

slib.setLang("sadmin", "en", "secondaryrank_help", "This will print information about the secondary rank")
slib.setLang("sadmin", "en", "setsecondaryrank_help", "This will set the secondary rank of a specified player!")
slib.setLang("sadmin", "en", "setsecondaryrankid_help", "This will set the secondary rank of a specified SteamID64!")
slib.setLang("sadmin", "en", "removesecondaryrank_help", "This will reset the secondary rank of a specified player!")
slib.setLang("sadmin", "en", "removesecondaryrankid_help", "This will reset the secondary rank of a specified SteamID64!")
