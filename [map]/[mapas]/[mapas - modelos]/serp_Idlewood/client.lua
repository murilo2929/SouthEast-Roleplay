
addEventHandler('onClientResourceStart', resourceRoot,
function()

local txd = engineLoadTXD('lasroads_las.txd',true)
engineImportTXD(txd, 4895)
local dff = engineLoadDFF('lstrud_las.dff', 0)
engineReplaceModel(dff, 4895)
engineSetModelLODDistance(4895, 500)

local txd = engineLoadTXD('ground5_las.txd',true)
engineImportTXD(txd, 4858)
local dff = engineLoadDFF('snpedland1_LAS.dff', 0)
engineReplaceModel(dff, 4858)
local col = engineLoadCOL('snpedland1_LAS.col')
engineReplaceCOL(col, 4858)
engineSetModelLODDistance(4858, 500)

local txd = engineLoadTXD('wiresetc2_las.txd',true)
engineImportTXD(txd, 4981)
local dff = engineLoadDFF('snpedteew1_las.dff', 0)
engineReplaceModel(dff, 4981)
engineSetModelLODDistance(4981, 500)

local txd = engineLoadTXD('wiresetc2_las.txd',true)
engineImportTXD(txd, 5084)
local dff = engineLoadDFF('alphbrk2_las.dff', 0)
engineReplaceModel(dff, 5084)
engineSetModelLODDistance(17677, 500)

local txd = engineLoadTXD('lasroads_las.txd',true)
engineImportTXD(txd, 5052)
local dff = engineLoadDFF('btoroad1vb_las.dff', 0)
engineReplaceModel(dff, 5052)
engineSetModelLODDistance(5052, 500)
end)
