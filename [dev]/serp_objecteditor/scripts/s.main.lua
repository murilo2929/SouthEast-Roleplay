Serverside = true

addEvent('Attach:RequestAttachments', true)
addEventHandler('Attach:RequestAttachments', root, function()
    triggerClientEvent(client, 'Attach:ReceiveAttachments', client, Attachments)
end)

ClearOnDestroy = function()
    DetachFromBone(source)
end
addEventHandler('onElementDestroy', root, ClearOnDestroy)

ClearPlayerAttachments = function(player)
    if (not PlayerAttachments[player]) then
        return false
    end
    for k in pairs(PlayerAttachments[player]) do
        DetachFromBone(k)
    end
    PlayerAttachments[player] = nil
end

ClearOnQuit = function()
    ClearPlayerAttachments(source)
end
addEventHandler('onPlayerQuit', root, ClearOnQuit)
