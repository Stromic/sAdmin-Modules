-- The purpose of this module is to control spawn permissions via sAdmin, this is traditionally controlled from gProtect or the gamemode.

//  _______              ___ _       
// (_______)            / __|_)      
//  _       ___  ____ _| |__ _  ____ 
// | |     / _ \|  _ (_   __) |/ _  |
// | |____| |_| | | | || |  | ( (_| |
//  \______)___/|_| |_||_|  |_|\___ |
//                            (_____|

sAdmin.SpawnPermissions = sAdmin.SpawnPermissions or {Config = {}}
sAdmin.SpawnPermissions.Config.HookHostage = false -- If this is true it will return true if the player has the permission, this can override other hooks unless they are also returning a boolean.

-------------------------------------------------------------

slib.setLang("sadmin", "en", "spawnpermissions_category", "Spawn Permissions")

local ignoreHooks = { -- Theese are the hooks that can be controlled in sAdmin
    "PlayerSpawnEffect",
    "PlayerSpawnNPC",
    "PlayerSpawnObject",
    "PlayerSpawnProp",
    "PlayerSpawnRagdoll",
    "PlayerSpawnSENT",
    "PlayerGiveSWEP",
    "PlayerSpawnVehicle"
}

for k,v in ipairs(ignoreHooks) do
    sAdmin.registerPermission(v, slib.getLang("sadmin", sAdmin.config["language"], "spawnpermissions_category"))

    hook.Add(v, "sA:SpawnPermissions", function(ply)
        if !IsValid(ply) then return end
        
        if !sAdmin.hasPermission(ply, v) then
            sAdmin.msg(ply, "no_permission", v)

            return false
        elseif sAdmin.SpawnPermissions.Config.HookHostage then
            return true
        end
    end)
end

slib.setLang("sadmin", "en", "PlayerSpawnEffect", "Spawn Effect")
slib.setLang("sadmin", "en", "PlayerSpawnNPC", "Spawn NPC")
slib.setLang("sadmin", "en", "PlayerSpawnObject", "Spawn Object")
slib.setLang("sadmin", "en", "PlayerSpawnProp", "Spawn Prop")
slib.setLang("sadmin", "en", "PlayerSpawnRagdoll", "Spawn Ragdoll")
slib.setLang("sadmin", "en", "PlayerSpawnSENT", "Spawn SENT")
slib.setLang("sadmin", "en", "PlayerGiveSWEP", "Spawn SWEP")
slib.setLang("sadmin", "en", "PlayerSpawnVehicle", "Spawn Vehicle")
