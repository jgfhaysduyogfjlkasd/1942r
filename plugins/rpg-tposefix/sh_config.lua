local PLUGIN = PLUGIN
PLUGIN.TposingModels = {}

-- Recursive function to find all .mdl files in a directory.
local function addModelsFromDirectory(dir)
    local files, directories = file.Find(dir .. "/*", "GAME")

    for _, v in ipairs(files) do
        if string.GetExtensionFromFilename(v) == "mdl" then
            table.insert(PLUGIN.TposingModels, dir .. "/" .. v)
        end
    end

    for _, v in ipairs(directories) do
        addModelsFromDirectory(dir .. "/" .. v)
    end
end

-- Call the function starting with your base directory.
addModelsFromDirectory("models/brot/rpg")
addModelsFromDirectory("models/rpg")
addModelsFromDirectory("models/brot/rpg/mattipm0v3edits/nsdap/reichsleitung")

addModelsFromDirectory("models/brot/rpgnew")
addModelsFromDirectory("models/rpgnew")
addModelsFromDirectory("models/brot/rpgnew/mattipm0v3edits/nsdap/reichsleitung")

addModelsFromDirectory("models/suanro")
addModelsFromDirectory("models/pentagon")
addModelsFromDirectory("models/ss")
addModelsFromDirectory("models/tpang")
addModelsFromDirectory("models/orpo")
addModelsFromDirectory("models/matti")
addModelsFromDirectory("models/hts")
addModelsFromDirectory("models/schl")
addModelsFromDirectory("models/delos")
addModelsFromDirectory("models/players")
addModelsFromDirectory("models/brot")
addModelsFromDirectory("models/humans")
addModelsFromDirectory("models/sujelo")
addModelsFromDirectory("models/sentry")
addModelsFromDirectory("models/humans")
addModelsFromDirectory("models/olympus")
for _, v in pairs(PLUGIN.TposingModels) do
    nut.anim.setModelClass(v, "player")
end
