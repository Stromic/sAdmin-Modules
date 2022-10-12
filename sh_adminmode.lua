-- Simple adminmode that will god and set the users model on !admin and ungod and restore their old model on !unadmin

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
                v:SetNWString( "bfa_model", model )
                v:SetModel( "models/player/combine_super_soldier.mdl" )
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
            if v:GetNWString( "is_admined", false) then
                local sid64 = v:SteamID64()
                local model = v:GetNWString( "bfa_model" )
                v:SetModel( model )
                v:SetNWString( "is_admined", false )
                sAdmin.godded[sid64] = nil
            else
                sAdmin.msg(ply, "no_adminmode_response", targets)
                return
            end 
        end

        sAdmin.msg(silent and ply or nil, "unadminmode_response", ply, targets)
    end
})
do
    -- adding disallows for when user is in adminmode
    local disallow = function(ply)
        if ply:GetNWString( "is_admined", false) then
            return false
        end
    end

    for _, v in ipairs({"canBuyCustomEntity","canBuyAmmo","canBuyShipment","canChangeJob","playerCanChangeTeam","canDemote","canDropWeapon","canRequestHit","canRequestWarrant","CanPlayerSuicide","canDropPocketItem"}) do
    hook.Add(v, "Exe_Adminmode", disallow)
    end
    
    -- overriding the sAdmin physgun pickup
    hook.Remove( "OnPhysgunPickup", "sA:AdminPhysgunPickup" )
    hook.Add("OnPhysgunPickup", "sA:xAdminmodePhysgunPickup", function(ply, ent)
        if ent:IsPlayer() and sAdmin.hasPermission(ply, "phys_players") and ply:GetNWString( "is_admined", false) then
            ent.adminPickedUp = true
            ent:Lock()
        end
    end)

    hook.Remove( "PhysgunPickup", "sA:AdminPhysgunLogic" )
    hook.Add("PhysgunPickup", "sA:xAdminmodePhysgunLogic", function(ply, ent)
        if ent:IsPlayer() then
            return sAdmin.hasPermission(ply, "phys_players") and ply:GetNWString( "is_admined", false) and (tonumber(sAdmin.hasPermission(ply, "immunity")) or 0) >= (tonumber(sAdmin.hasPermission(ent, "immunity")) or 0)
        end
    end)
end

if(CLIENT) then
    -- Yes this is a repurposed jail hud. sue me :p
    local color_white = Color(255,255,255,255)
    local color_black = Color(0,0,0,150)
    local color_darkgray = Color(30,30,30,200)
    local blur = Material("pp/blurscreen")

    local scale = function(num, isY)
        return num * (isY and (ScrH() / 1080) or (ScrW() / 1920))
    end

    surface.CreateFont( "JailedFont", {
        font = "Another Round", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = 55,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })

    function BlurRect(x, y, w, h, alpha)
        local X, Y = 0,0
        surface.SetDrawColor(255,255,255)
        surface.SetMaterial(blur)
        for i = 1, 5 do
            blur:SetFloat("$blur", (i / 4) * 4)
            blur:Recompute()
            render.UpdateScreenEffectTexture()
            render.SetScissorRect( x, y, x + w, y + h, true )
                surface.DrawTexturedRect( X * -1, Y * -1, ScrW(), ScrH() )
            render.SetScissorRect( 0, 0, 0, 0, false )
        end
        draw.RoundedBox(5,x,y,w,h,Color(0,0,0,alpha))
    end
    function adminHUD()
        local ply = LocalPlayer()
        local ypos = 800
        if !ply:GetNWString( "is_admined", false) then
            return
        elseif ply:GetNWString( "is_admined", false) then
            --BlurRect(ScrW() / 2 - scale(250), scale(163) + scale(ypos), scale(500), scale(70), 130)
    
            draw.SimpleText("Adminmode Enabled", "JailedFont", scale(964), scale(192) - scale(20) + scale(ypos), color_black, 1) -- Adminmode Shadow/Outline
            draw.SimpleText("Adminmode Enabled", "JailedFont", scale(960), scale(188) - scale(20) + scale(ypos), color_white, 1) -- Adminmode Text
        end
    end
    hook.Add("HUDPaint", "PRJail_HUD", adminHUD)
end

slib.setLang("sadmin", "en", "adminmode_response", "%s put %s into adminmode")
slib.setLang("sadmin", "en", "in_adminmode_response", "%s is already in adminmode!")
slib.setLang("sadmin", "en", "no_adminmode_response", "%s is not in adminmode!")
slib.setLang("sadmin", "en", "unadminmode_response", "%s took %s out of adminmode")
