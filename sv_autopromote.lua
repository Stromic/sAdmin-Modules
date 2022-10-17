-- This module is inspired by GPromote (https://github.com/RoniJames/GPromote)

------------------------------------------------------------------------------
------------------------------CONFIG START------------------------------------
------------------------------------------------------------------------------

local check_autopromote_timer = 10

local autopromote_ranks = { -- The first one will automatically be the starting group, it wont work with ranks outside of this table!
    {rank = "user"},
    {rank = "regular", playtime = "24h"},
    {rank = "trusted", playtime = "3d"},
    {rank = "veteran", playtime = "1w"},
}

local promote_sound = "/garrysmod/save_load1.wav" -- Make it an empty string to not play any sound (Inspired by APromote)
------------------------------------------------------------------------------
--------------------------------CONFIG END------------------------------------
------------------------------------------------------------------------------

local rank_to_key = {}

for k,v in ipairs(autopromote_ranks) do
    rank_to_key[v.rank] = k
end

timer.Create("sA:AutoPromote", check_autopromote_timer, 0, function()
	for k,v in ipairs(player.GetHumans()) do
        local cur_rank_key = rank_to_key[v:GetUserGroup()]
        if !cur_rank_key then continue end

        local next_rank
        local playtime = sAdmin.getTotalPlaytime(v)

        for i = #autopromote_ranks, 1, -1 do
            local rank_data = autopromote_ranks[i]

            if !rank_data or !rank_data.rank or !rank_data.playtime or cur_rank_key >= i then continue end

            local playtime_required = sAdmin.getTime(rank_data.playtime) or 0

            if playtime >= playtime_required then
                next_rank = rank_data
            break end
        end

        if !next_rank then continue end

        RunConsoleCommand("sa", "setrank", v:SteamID64(), next_rank.rank)

        if promote_sound != "" then
            v:SendLua("surface.PlaySound('"..promote_sound.."')")
        end
	end
end)
