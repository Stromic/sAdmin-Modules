-- Simple adminmode originally made by Exehad, revamped by Stromic.

//  _______              ___ _       
// (_______)            / __|_)      
//  _       ___  ____ _| |__ _  ____ 
// | |     / _ \|  _ (_   __) |/ _  |
// | |____| |_| | | | || |  | ( (_| |
//  \______)___/|_| |_||_|  |_|\___ |
//                            (_____|

sAdmin.AdminMode = sAdmin.AdminMode or {Active = {}, Config = {}}

sAdmin.AdminMode.Config.AdminModeModel = "models/player/combine_super_soldier.mdl" -- This is the playermodel the admin will have when in admin mode, leave blank to disable.

sAdmin.AdminMode.Config.AdminModeJob = "" -- Leave blank to disable, this will change your job to the selected one. (Make it the job name)

sAdmin.AdminMode.Config.EnableGodmode = true -- Should we automatically enable godmode when you ented admin mode?

sAdmin.AdminMode.Config.LockPhysgunEnhancerToAdminMode = true -- If this is enabled it will prevent people from using the physgun enhancer while not in admin mode. (Pickup players etc)

sAdmin.AdminMode.Config.DisallowInAdminMode = { -- These actions can be allowed by either commenting them out or making them false.
    ["canBuyCustomEntity"] = true,
    ["canBuyAmmo"] = true,
    ["canBuyShipment"] = true,
    ["canChangeJob"] = true,
    ["playerCanChangeTeam"] = true,
    ["canDemote"] = true,
    ["canDropWeapon"] = true,
    ["canRequestHit"] = true,
    ["canRequestWarrant"] = true,
    ["CanPlayerSuicide"] = true,
    ["canDropPocketItem"] = true
}

sAdmin.AdminMode.Config.AdminModeCommands = { -- These commands can only be used while in admin mode.
    ["noclip"] = true,
    ["god"] = true,
    ["ungod"] = true,
    ["hp"] = true,
    ["freeze"] = true,
    ["unfreeze"] = true,
    ["strip"] = true,
    ["slay"] = true,
    ["ignite"] = true,
    ["slap"] = true,
    ["giveammo"] = true,
    ["extinguish"] = true,
    ["scale"] = true,
    ["speed"] = true,
    ["walkspeed"] = true,
    ["runspeed"] = true,
    ["bot"] = true,
    ["goto"] = true,
    ["bring"] = true,
    ["tp"] = true,
    ["return"] = true,
    ["demigod"] = true,
    ["undemigod"] = true,
    ["give"] = true,
    ["shipment"] = true
}

-------------------------------------------------------------

local function enterAdminMode(ply)
    ply.sAdminAdminModData = {}
    
    if sAdmin.AdminMode.Config.AdminModeModel != "" and sAdmin.AdminMode.Config.AdminModeJob == "" then -- You cant use both the set model and the job change.
        ply.sAdminAdminModData.mdl = ply:GetModel()

        ply:SetModel(sAdmin.AdminMode.Config.AdminModeModel)
    end

    if sAdmin.AdminMode.Config.AdminModeJob != "" then
        local job

        for k,v in ipairs(RPExtraTeams) do
            if v.name == sAdmin.AdminMode.Config.AdminModeJob then
                job = k

                break
            end
        end

        if job != nil then
            ply.sAdminAdminModData.job = ply:Team()

            ply:changeTeam(job, true)
        end
    end

    if sAdmin.AdminMode.Config.EnableGodmode and !ply:IsBot() then
        sAdmin.godded[ply:SteamID64()] = true
    end

    sAdmin.AdminMode.Active[ply] = true

    sAdmin.networkData(ply, {"inAdminMode"}, true)
end

local function exitAdminMode(ply)
    if ply.sAdminAdminModData.mdl then
        ply:SetModel(ply.sAdminAdminModData.mdl)
    end

    if ply.sAdminAdminModData.job then
        ply:changeJob(ply.sAdminAdminModData.job, true)
    end

    if sAdmin.AdminMode.Config.EnableGodmode and !ply:IsBot() then
        sAdmin.godded[ply:SteamID64()] = nil
    end

    ply.sAdminAdminModData = nil
    sAdmin.AdminMode.Active[ply] = nil

    sAdmin.networkData(ply, {"inAdminMode"}, false)
end

sAdmin.addCommand({
    name = "admin",
    category = "Utility",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("admin", ply, args[1], 1)
        
        for k,v in ipairs(targets) do
            if !sAdmin.AdminMode.Active[v] then
                enterAdminMode(v)
            else
                return sAdmin.msg(ply, "in_adminmode_response", v:Nick())
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
            if sAdmin.AdminMode.Active[ply] then
                exitAdminMode(v)
            else
                return sAdmin.msg(ply, "no_adminmode_response", v:Nick())
            end 
        end

        sAdmin.msg(silent and ply or nil, "unadminmode_response", ply, targets)
    end
})

if SERVER then
    -- Disallow certain actions while in admin mode
    for k, v in pairs(sAdmin.AdminMode.Config.DisallowInAdminMode) do
        if !v then continue end

        hook.Add(k, "sA:DisallowInAdminMode", function(ply)
            if sAdmin.AdminMode.Active[ply] then
                return false
            end
        end)
    end

    -- Prevent physgun enhancer while in admin mode
    hook.Add("sA:OverridePermission", "sA:AdminModePickupPrevent", function(ply, name)
        if name == "phys_players" and sAdmin.AdminMode.Config.LockPhysgunEnhancerToAdminMode and !sAdmin.AdminMode.Active[ply] then
            return false
        end
    end)

    hook.Add("sA:CanNoclip", "sA:AdminModePreventNoclip", function(ply)
        if sAdmin.AdminMode.Config.AdminModeCommands["noclip"] and !sAdmin.AdminMode.Active[ply] then
            sAdmin.msg(ply, "need_adminmode_response", ply, "noclip")
            return false
        end
    end)

    hook.Add("sA:RunCommand", "sA:AdminModeCommandPrevent", function(ply, name, args)
        if sAdmin.AdminMode.Config.AdminModeCommands[name] and !sAdmin.AdminMode.Active[ply] then
            sAdmin.msg(ply, "need_adminmode_response", ply, name)    
        return false end
    end)
else
    local font = slib.createFont("Roboto", 23)
    local scrw, gap = ScrW(), slib.getTheme("margin")

    hook.Add("HUDPaint", "sA:AdminModeHUD", function()
        if !sAdmin.inAdminMode then return end

        draw.SimpleTextOutlined(slib.getLang("sadmin", sAdmin.config["language"], "adminmode_enabled"), font, scrw * .5, gap * 3, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
    end)
end

slib.setLang("sadmin", "en", "adminmode_enabled", "Adminmode Enabled")

slib.setLang("sadmin", "en", "adminmode_response", "%s enabled adminmode for %s.")
slib.setLang("sadmin", "en", "unadminmode_response", "%s disabled adminmode for %s.")
slib.setLang("sadmin", "en", "in_adminmode_response", "%s is already in adminmode.")
slib.setLang("sadmin", "en", "no_adminmode_response", "%s is not in adminmode.")

slib.setLang("sadmin", "en", "need_adminmode_response", "%s have to be in adminmode to use %s.")
