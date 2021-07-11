sAdmin.addCommand({
    name = "molotov",
    category = "Fire System",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("molotov", ply, args[1], 1)

        for k,v in ipairs(targets) do
            v:Give("fire_molotov")
        end

        sAdmin.msg(silent and ply or nil, "molotov_response", ply, targets)
    end
})

sAdmin.addCommand({
    name = "extinguisher",
    category = "Fire System",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("extinguisher", ply, args[1], 1)
        
        for k,v in ipairs(targets) do
            v:Give("fire_extinguisher")
        end

        sAdmin.msg(silent and ply or nil, "extinguisher_response", ply, targets)
    end
})

sAdmin.addCommand({
    name = "forcefirefighter",
    category = "Fire System",
    inputs = {{"player", "player_name"}},
    func = function(ply, args, silent)
        local targets = sAdmin.getTargets("forcefirefighter", ply, args[1], 1)
        
        for k,v in ipairs(targets) do
            v:changeTeam(TEAM_FIREFIGHTER)
        end

        sAdmin.msg(silent and ply or nil, "forcefirefighter_response", ply, targets)
    end
})

sAdmin.addCommand({
    name = "fireoff",
    category = "Fire System",
    inputs = {},
    func = function(ply, args, silent)
        for k, v in ipairs(ents.FindByClass("fire")) do
            v:KillFire()
        end

        sAdmin.msg(silent and ply or nil, "fireoff_response", ply)
    end
})

sAdmin.addCommand({
    name = "startfire",
    category = "Fire System",
    inputs = {},
    func = function(ply, args, silent)
        local tr = ply:GetEyeTrace()
		
        local fire = ents.Create("fire")
        fire:SetPos(tr.HitPos)
        fire:Spawn()
        
        sAdmin.msg(silent and ply or nil, "startfire_response", ply)
    end
})


sAdmin.addCommand({
    name = "validfires",
    category = "Fire System",
    inputs = {},
    func = function(ply, args, silent)
        for k, v in pairs(file.Find("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/fire_location_*.txt", "DATA")) do
            local PosFile = file.Read("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/".. v, "DATA")
            local ThePos = string.Explode( ";", PosFile )
            local ThePrintPos = ThePos[1], ThePos[2], ThePos[3]
                        
            ply:PrintMessage(HUD_PRINTCONSOLE, "NAMES OF VALID FIRES:")
            ply:PrintMessage(HUD_PRINTCONSOLE, "File Name: ".. v .." - Fire Position: "..ThePrintPos)
            ply:PrintMessage(HUD_PRINTCONSOLE, "REMEMBER: YOU ONLY USE THE LAST OF THE FILE NAME. SO IF A FILE NAME IS CALLED 'FIRE_LOCATION_TRAIN', THEN YOU WOULD USE 'CH_REMOVE_FIRE TRAIN' TO REMOVE IT!")
        end
        
        ply:ChatPrint("A list of valid fires has been printed to your console!")
        
        sAdmin.msg(silent and ply or nil, "validfires_response", ply)
    end
})

sAdmin.addCommand({
    name = "allfires",
    category = "Fire System",
    inputs = {},
    func = function(ply, args, silent)
        for k, v in pairs(file.Find("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/fire_location_*.txt", "DATA")) do
            if FIRE_CurrentFires >= FIRE_MaxFires then 
                return 
            end
            
            local Randomize = 2
            if FIRE_RandomizeFireSpawn then
                Randomize = math.random(1,2)
            end
            
            if tonumber(Randomize) == 2 then
                local PositionFile = file.Read("craphead_scripts/fire_system/".. string.lower(game.GetMap()) .."/".. v, "DATA")
                    
                local ThePosition = string.Explode( ";", PositionFile )
                    
                local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
                local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])
    
                local Fire = ents.Create("fire")
                Fire:SetPos(TheVector)
                Fire:SetAngles(TheAngle)
                Fire:Spawn()
            end
        end
        
        sAdmin.msg(silent and ply or nil, "allfires_response", ply)
    end
})

slib.setLang("sadmin", "en", "molotov_response", "%s gave a molotov to %s.")
slib.setLang("sadmin", "en", "extinguisher_response", "%s gave an extinguisher to %s.")
slib.setLang("sadmin", "en", "forcefirefighter_response", "%s forced %s to become a fire fighter.")
slib.setLang("sadmin", "en", "fireoff_response", "%s turned off all fires.")
slib.setLang("sadmin", "en", "startfire_response", "%s started a fire.")
slib.setLang("sadmin", "en", "validfires_response", "%s looked up valid fires.")
slib.setLang("sadmin", "en", "allfires_response", "%s started all fires.")
