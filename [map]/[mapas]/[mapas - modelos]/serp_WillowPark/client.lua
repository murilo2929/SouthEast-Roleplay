
-- SparroW MTA : https://sparrow-mta.blogspot.com
-- Facebook : https://www.facebook.com/sparrowgta/
-- İnstagram : https://www.instagram.com/sparrowmta/
-- Discord : https://discord.gg/DzgEcvy    <--- Sizi de aramız'da görmek isteriz.


addEventHandler('onClientResourceStart', resourceRoot,
function()

local txd = engineLoadTXD('ground2_las2.txd',true)
engineImportTXD(txd, 5116)
local dff = engineLoadDFF('las2stripbar1.dff', 0)
engineReplaceModel(dff, 5116)
local col = engineLoadCOL('las2stripbar1.col')
engineReplaceCOL(col, 5116)
engineSetModelLODDistance(5116, 500)
end)
