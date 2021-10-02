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
end)
