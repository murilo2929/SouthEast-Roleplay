deletefiles =
{ "c_wearable_positioning.lua",
"c_wearable_gui.lua",
"g_wearable_globals.lua",
"Delete.lua", }

function onStartResourceDeleteFiles()
for i=1, #deletefiles do
fileDelete(deletefiles[i])
end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), onStartResourceDeleteFiles)
