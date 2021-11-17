-- ******************************************* --
-- File: scripts\c.edit.lua
-- Type: client
-- Purpose: Provide a ingame attach editor
-- Author(s): iDannz
-- ******************************************* --

sW, sH = guiGetScreenSize()

Preview = {
    State = false,
    Window = nil,
    Offset = 0.05,
    Scale = 1,
    X = 0,
    Y = 0,
    Z = 0,
    RX = 0,
    RY = 0,
    RZ = 0,
    Bone = 3,
    Model = 1550,
    Object = false,
}

local ValidationString = "[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)"

addCommandHandler('attach', function()
    if (not EDITOR_SERIALS[getPlayerSerial(localPlayer)]) then
        return false
    end
    TogglePreview(not Preview.State)
end)


-- addEventHandler('onClientResourceStart', resourceRoot, function()
    -- setTimer(TogglePreview, 500, 1, true)
-- end)

TogglePreview = function(state)
    if (Preview.State == state) then
        return false
    end
    
    if isElement(Preview.Window) then
        destroyElement(Preview.Window)
    end
    
    if state then
        local w, h = 450, 450
        Preview.Window = guiCreateWindow(sW - w - 50, (sH - h) / 2, w, h, 'Attach Preview by iDannz', false)
        
        guiCreateLabel(0.05, 0.075, 0.25, 0.05, 'Model:', true, Preview.Window)
        Preview.EditModel = guiCreateEdit(0.05, 0.11, 0.15, 0.05, Preview.Model, true, Preview.Window)
        guiSetProperty(Preview.EditModel, "ValidationString", "[0-9]*")
        
        guiCreateLabel(0.25, 0.075, 0.25, 0.05, 'Bone:', true, Preview.Window)
        Preview.EditBone = guiCreateEdit(0.25, 0.11, 0.15, 0.05, Preview.Bone, true, Preview.Window)
        guiSetProperty(Preview.EditBone, "ValidationString", ValidationString)
        
        guiCreateLabel(0.45, 0.075, 0.25, 0.05, 'Offset:', true, Preview.Window)
        Preview.EditOffset = guiCreateEdit(0.45, 0.11, 0.15, 0.05, Preview.Offset, true, Preview.Window)
        guiSetProperty(Preview.EditOffset, "ValidationString", ValidationString)
        
        guiCreateLabel(0.65, 0.075, 0.25, 0.05, 'Scale:', true, Preview.Window)
        Preview.EditScale = guiCreateEdit(0.65, 0.11, 0.15, 0.05, Preview.Scale, true, Preview.Window)
        guiSetProperty(Preview.EditScale, "ValidationString", ValidationString)
        
        local lblX = guiCreateLabel(0.05, 0.2, 0.25, 0.05, 'X:', true, Preview.Window)
        guiLabelSetHorizontalAlign(lblX, 'center')
        Preview.EditX = guiCreateEdit(0.125, 0.235, 0.1, 0.05, Preview.X, true, Preview.Window)
        guiSetProperty(Preview.EditX, "ValidationString", ValidationString)
        Preview.AddX = guiCreateButton(0.05, 0.235, 0.075, 0.05, '+', true, Preview.Window)
        Preview.DecX = guiCreateButton(0.225, 0.235, 0.075, 0.05, '-', true, Preview.Window)
        
        local lblY = guiCreateLabel(0.35, 0.2, 0.25, 0.05, 'Y:', true, Preview.Window)
        guiLabelSetHorizontalAlign(lblY, 'center')
        Preview.EditY = guiCreateEdit(0.425, 0.235, 0.1, 0.05, Preview.Y, true, Preview.Window)
        guiSetProperty(Preview.EditY, "ValidationString", ValidationString)
        Preview.AddY = guiCreateButton(0.35, 0.235, 0.075, 0.05, '+', true, Preview.Window)
        Preview.DecY = guiCreateButton(0.525, 0.235, 0.075, 0.05, '-', true, Preview.Window)
        
        local lblZ = guiCreateLabel(0.65, 0.2, 0.25, 0.05, 'Z:', true, Preview.Window)
        guiLabelSetHorizontalAlign(lblZ, 'center')
        Preview.EditZ = guiCreateEdit(0.725, 0.235, 0.1, 0.05, Preview.Z, true, Preview.Window)
        guiSetProperty(Preview.EditZ, "ValidationString", ValidationString)
        Preview.AddZ = guiCreateButton(0.65, 0.235, 0.075, 0.05, '+', true, Preview.Window)
        Preview.DecZ = guiCreateButton(0.825, 0.235, 0.075, 0.05, '-', true, Preview.Window)
        
        Preview.LblRx = guiCreateLabel(0.05, 0.325, 0.9, 0.05, 'RX: ' .. Preview.RX, true, Preview.Window)
        guiLabelSetHorizontalAlign(Preview.LblRx, 'center')
        Preview.Rx = guiCreateScrollBar(0.05, 0.365, 0.9, 0.05, true, true, Preview.Window)
        guiScrollBarSetScrollPosition(Preview.Rx, Preview.RX * 100 / 360)
        
        Preview.LblRy = guiCreateLabel(0.05, 0.425, 0.9, 0.05, 'RY: ' .. Preview.RY, true, Preview.Window)
        guiLabelSetHorizontalAlign(Preview.LblRy, 'center')
        Preview.Ry = guiCreateScrollBar(0.05, 0.465, 0.9, 0.05, true, true, Preview.Window)
        guiScrollBarSetScrollPosition(Preview.Ry, Preview.RY * 100 / 360)
        
        Preview.LblRz = guiCreateLabel(0.05, 0.525, 0.9, 0.05, 'RZ: ' .. Preview.RZ, true, Preview.Window)
        guiLabelSetHorizontalAlign(Preview.LblRz, 'center')
        Preview.Rz = guiCreateScrollBar(0.05, 0.565, 0.9, 0.05, true, true, Preview.Window)
        guiScrollBarSetScrollPosition(Preview.Rz, Preview.RZ * 100 / 360)
        
        local lblOutput = guiCreateLabel(0.05, 0.635, 0.9, 0.05, 'Output:', true, Preview.Window)
        guiLabelSetHorizontalAlign(lblOutput, 'center')
        
        Preview.Output = guiCreateEdit(0.05, 0.675, 0.9, 0.05, '0, 0, 0, 0, 0, 0, 0', true, Preview.Window)
        guiEditSetReadOnly(Preview.Output, true)
        
        local lblHelp = guiCreateLabel(0.2, 0.775, 0.6, 0.05, 'Press "space" to toggle cursor.', true, Preview.Window)
        guiLabelSetHorizontalAlign(lblHelp, 'center')
        
        Preview.Copy = guiCreateButton(0.2, 0.85, 0.25, 0.1, 'Copiar Output', true, Preview.Window)
        Preview.Destroy = guiCreateButton(0.55, 0.85, 0.25, 0.1, 'Fechar Preview', true, Preview.Window)
        
        addEventHandler('onClientGUIClick', Preview.Window, Preview.OnClick)
        addEventHandler('onClientGUIChanged', Preview.Window, Preview.OnEdit)
        addEventHandler('onClientGUIScroll', Preview.Window, Preview.LoadOutput)
    
    end
    
    Preview.State = state
    
    showCursor(state)
    Preview.ToggleObject(state)
    
    _G[state and 'bindKey' or 'unbindKey']('space', 'both', ToggleCursor)
end

Preview.ToggleObject = function(state)
    if isElement(Preview.Object) then
        destroyElement(Preview.Object)
    end
    
    if state then
        Preview.Object = createObject(Preview.Model, getElementPosition(localPlayer))
        AttachToBone(localPlayer, Preview.Object, Preview.Bone, Preview.X, Preview.Y, Preview.Z, Preview.RX, Preview.RY, Preview.RZ)
        Preview.LoadOutput()
    end
end

Preview.LoadOutput = function()
    if (not Preview.State) then
        return false
    end
    
    local x = tonumber(guiGetText(Preview.EditX))
    local y = tonumber(guiGetText(Preview.EditY))
    local z = tonumber(guiGetText(Preview.EditZ))
    
    local bone = tonumber(guiGetText(Preview.EditBone))
    local offset = tonumber(guiGetText(Preview.EditOffset))
    local scale = tonumber(guiGetText(Preview.EditScale))
    
    local rx = ToFixed(guiScrollBarGetScrollPosition(Preview.Rx) / 100 * 360, 2)
    local ry = ToFixed(guiScrollBarGetScrollPosition(Preview.Ry) / 100 * 360, 2)
    local rz = ToFixed(guiScrollBarGetScrollPosition(Preview.Rz) / 100 * 360, 2)
    
    guiSetText(Preview.LblRx, 'RX: ' .. rx)
    guiSetText(Preview.LblRy, 'RY: ' .. ry)
    guiSetText(Preview.LblRz, 'RZ: ' .. rz)
    
    guiSetText(Preview.Output, table.concat({bone, x, y, z, rx, ry, rz, scale}, ', '))
    
    setObjectScale(Preview.Object, scale)

    UpdateAttachmentInfo(Preview.Object, {
        bone = bone,
        x = x,
        y = y,
        z = z,
        rx = rx,
        ry = ry,
        rz = rz,
    })
    
    Preview.Model = getElementModel(Preview.Object)
    Preview.Bone = bone
    Preview.X = x
    Preview.Y = y
    Preview.Z = z
    Preview.RX = rx
    Preview.RY = ry
    Preview.RZ = rz
    Preview.Offset = offset
    Preview.Scale = scale
    
    return true
end

Preview.OnEdit = function()
    local new = guiGetText(source)
    
    if (source == Preview.EditModel) then
        if (not setElementModel(Preview.Object, tonumber(new))) then
            return false
        end
    elseif (source == Preview.EditBone) then
        if (not VALID_BONES[tonumber(new)]) then
            return false
        end
    end
    
    Preview.LoadOutput()
end

Preview.OnClick = function()
    local offset = guiGetText(Preview.EditOffset)
    
    if (guiGetText(source) == '-') then
        offset = -offset
    end
    
    if (source == Preview.AddX) or (source == Preview.DecX) then
        guiSetText(Preview.EditX, tonumber(guiGetText(Preview.EditX)) + offset)
    
    elseif (source == Preview.AddY) or (source == Preview.DecY) then
        guiSetText(Preview.EditY, tonumber(guiGetText(Preview.EditY)) + offset)
    
    elseif (source == Preview.AddZ) or (source == Preview.DecZ) then
        guiSetText(Preview.EditZ, tonumber(guiGetText(Preview.EditZ)) + offset)
    
    elseif (source == Preview.Copy) then
        local text = guiGetText(Preview.Output)
        outputChatBox(('The text: "%s" has been copied to clipboard.'):format(text), 255, 255, 0)
        setClipboard(text)
    
    elseif (source == Preview.Destroy) then
        TogglePreview(false)
    end
end

ToggleCursor = function()
    showCursor(not isCursorShowing())
end

ToFixed = function(number, decimals)
    return tonumber(('%.' .. decimals .. 'f'):format(number))
end
