addEvent("computers:on", true)
addEventHandler("computers:on", root,
	function()
		triggerEvent("sendAme",  client, "liga o computador.")
	end
)
