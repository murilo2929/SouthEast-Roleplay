addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),function()
	for _,v in ipairs(getResources())do
		local name = getResourceName(v)
		if string.find(name,"serp_")  then
			startResource(v)
		end
	end
end)

addEventHandler("onResourceStop",getResourceRootElement(getThisResource()),function()
	for _,v in ipairs(getResources())do
		local name = getResourceName(v)
		if string.find(name,"serp_") then
			stopResource(v)
		end
	end
end)