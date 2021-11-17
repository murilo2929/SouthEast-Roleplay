--MAXIME / 2015.1.22

local actions = { [0] = "preso", [1] = "kick", [2] = "ban", [3] = "app", [4] = "aviso", [5] = "autoban", [6] = "outro", [7] = "force-app", [8] = "punição"}
function getHistoryAction(input)
	if tonumber(input) then
		if actions[tonumber(input)] then
			return actions[tonumber(input)]
		else
			return "outro"
		end
	end
	return "outro"
end

function historyDuration( d, a )
	if a == 6 then
		return tostring(d)
	elseif a == 1 or a == 3 or a == 4 then
		return ""
	elseif a == 0 then
		return d .. " min"
	elseif (a == 5 or a == 2) and d ~= 0 then
		return d .. " hrs"
	elseif a == 8 then
		return d .. " pt"
	else
		return "perm"
	end
end

function getHistoryRecordFromId(records, id)
	for i, record in pairs(records) do
		if tonumber(record[7]) == tonumber(id) then
			return record
		end
	end
end
