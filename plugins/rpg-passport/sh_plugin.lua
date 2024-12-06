PLUGIN.name = "German Passport"
PLUGIN.desc = "Nutscript roleplay scrtipt"
PLUGIN.author = "Dave01"

nut.util.include("cl_docgui.lua")
nut.util.include("cl_missingInfos.lua")
nut.util.include("sv_networking.lua")

charCharacteristics = {
  ["Age"] = "number",
  ["Date of Birth"] = "string",
  ["Place of Birth"] = "string",
  ["Height"] = "string",
  ["Hair Color"] = {valueType = "choice", choices={"Auburn", "Black", "Blond", "Brown", "Bald", "Grey"}},
  ["Eye Color"] = {valueType = "choice", choices={"Amber", "Blue", "Black", "Brown", "Green"}},
  ["Religion"] = "string",
  ["Blood Type"] = {valueType = "choice", choices={"O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"}},
  ["Ethnicity"] = {valueType = "choice", choices={"Danish", "Dutch", "Finnish", "French", "German", "Hungarian", "Italian", "Jewish", "Japanese", "Polish", "Romanian", "Russian", "Ukrainian", "Swedish"}},  ["Occupation"] = "string",
  ["Weight"] = "number"
}

nut.command.add("chareditpapers", {
	syntax = "",
	onRun = function(ply,args)
		netstream.Start(ply,"missingCharacteristics", "RED PANDA GAMING | PASSPORT IDENTIFICATION MODIFY MENU", true)
	end
})