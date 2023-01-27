-- The purpos of this module is to control spawn permissions via sAdmin, this is traditionally controlled from gProtect or the gamemode.

slib.setLang("sadmin", "en", "spawnpermissions_category", "Spawn Permissions")

local ignoreHooks = { -- Theese are the hooks that can be controlled in sAdmin
    "PlayerSpawnEffect",
    "PlayerSpawnNPC",
    "PlayerSpawnObject",
    "PlayerSpawnProp",
    "PlayerSpawnRagdoll",
    "PlayerSpawnSENT",
    "PlayerSpawnSWEP",
    "PlayerSpawnVehicle"
}

for k,v in ipairs(ignoreHooks) do
    sAdmin.registerPermission(v, slib.getLang("sadmin", sAdmin.config["language"], "spawnpermissions_category"))

    hook.Add(v, "sA:SpawnPermissions", function(ply)
        if !IsValid(ply) then return end
        
        if !sAdmin.hasPermission(ply, v) then
            sAdmin.msg(ply, "no_permission", v)

            return false
        else 
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
slib.setLang("sadmin", "en", "PlayerSpawnSWEP", "Spawn SWEP")
slib.setLang("sadmin", "en", "PlayerSpawnVehicle", "Spawn Vehicle")
