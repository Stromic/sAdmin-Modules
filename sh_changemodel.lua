sAdmin.addCommand({
    name = "cc",
    category = "Kythin Custom",
    inputs = {{"text", "model"}},
    func = function(ply, args, silent)
        local mdl = args[1]

        if !mdl then 
            ply:ChatPrint(mdl + " is not found. Are you sure it's a valid model?")
            return 
        end
        
        ply:SetModel(mdl)

        ply:ChatPrint("Set model to " + mdl)
    end
})