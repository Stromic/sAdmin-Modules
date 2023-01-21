//  _______              ___ _       
// (_______)            / __|_)      
//  _       ___  ____ _| |__ _  ____ 
// | |     / _ \|  _ (_   __) |/ _  |
// | |____| |_| | | | || |  | ( (_| |
//  \______)___/|_| |_||_|  |_|\___ |
//                            (_____|

sAdmin.gPAutoWarn = sAdmin.gPAutoWarn or {Config = {}, Triggers = {}}

sAdmin.gPAutoWarn.Config.TriggersNeeded = 3 -- How many anticollide triggers are needed for the player to get warned?

sAdmin.gPAutoWarn.Config.TriggersClearTimer = 5 -- How long should we wait before we clear the triggers?

-------------------------------------------------------------

hook.Add("gP:CollidedTooMuch", "sA:gProtectAntiCollide", function(ply, ent)
    if !IsValid(ply) or ply:IsBot() then return end

    local sid64 = ply:SteamID64()
    local curtime = CurTime()

    sAdmin.gPAutoWarn.Triggers[sid64] = sAdmin.gPAutoWarn.Triggers[sid64] or {}
    table.insert(sAdmin.gPAutoWarn.Triggers[sid64], curtime)

    local triggerCount = #sAdmin.gPAutoWarn.Triggers[sid64]
    local activeTriggers = 0

    for i = triggerCount + 1, 1, -1 do
        local value = sAdmin.gPAutoWarn.Triggers[sid64][i]
        if !value then continue end

        if curtime - value > sAdmin.gPAutoWarn.Config.TriggersClearTimer then sAdmin.gPAutoWarn.Triggers[sid64][i] = nil continue end

        activeTriggers = activeTriggers + 1
    end

    if activeTriggers >= sAdmin.gPAutoWarn.Config.TriggersNeeded then
        RunConsoleCommand("sa", "warn", sid64, slib.getLang("sadmin", sAdmin.config["language"], "gp_autowarn_msg"))
    end
end)

slib.setLang("sadmin", "en", "gp_autowarn_msg", "[gProtect] Triggered anticollide")
