--[[addEventHandler('onClientResourceStart', resourceRoot, function()
  local ifp = engineLoadIFP('weaponswitch.ifp', 'weaponswitch')
  if (ifp) then
    outputChatBox('Custom IFP loaded!', 0, 255, 0)
  end
end)]]

engineLoadIFP("imgs/weaponswitch.ifp", "weaponswitch")
engineLoadIFP("imgs/weaponswitch2.ifp", "weaponswitch2")

function applyClientAnimation()
if (isElement(source)) then
        setPedAnimation(source, 'weaponswitch', 'weaponswitch', 2000)
    setTimer(function(player)
        if (isElement(player)) then
            setPedAnimation(player)
        end
    end, 1030, 1, source)
  end
end
addEvent('anim:applyClientAnimation', true)
addEventHandler('anim:applyClientAnimation', root, applyClientAnimation)