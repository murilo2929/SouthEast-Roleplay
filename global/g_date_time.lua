--MAXIME / THIS FILE IS WORKAROUND FUNCTIONS FOR ANY KIND OF DATE TIME FORMAT

function getPlayerDoB(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		local year = getElementData(thePlayer, "year")
		local month = getElementData(thePlayer, "month")
		local day = getElementData(thePlayer, "day")
		return numberToMonth(month).." "..formatDate(day)..", "..year
	else
		return false
	end
end

function isThisYearLeap(year)
	if not year or not tonumber(year) then
		return false
	else
		year = tonumber(year)
	end

	if (year%4) == 0 then
		return true
	else
		return false
	end
end

function monthToNumber(monthName)
	if not monthName then
		return 1
	else
		if monthName == "Janeiro" then
			return 1
		elseif monthName == "Fevereiro" then
			return 2
		elseif monthName == "Março" then
			return 3
		elseif monthName == "Abril" then
			return 4
		elseif monthName == "Maio" then
			return 5
		elseif monthName == "Junho" then
			return 6
		elseif monthName == "Julho" then
			return 7
		elseif monthName == "Agosto" then
			return 8
		elseif monthName == "Setembro" then
			return 9
		elseif monthName == "Outubro" then
			return 10
		elseif monthName == "Novembro" then
			return 11
		elseif monthName == "Dezembro" then
			return 12
		else
			return 1
		end
	end
end

function numberToMonth(monthNumber)
	if not monthNumber or not tonumber(monthNumber) then
		return "Janeiro"
	else
		monthNumber = tonumber(monthNumber)
		if monthNumber == 1 then
			return "Janeiro"
		elseif monthNumber == 2 then
			return "Fevereiro"
		elseif monthNumber == 3 then
			return "Março"
		elseif monthNumber == 4 then
			return "Abril"
		elseif monthNumber == 5 then
			return "Maio"
		elseif monthNumber == 6 then
			return "Junho"
		elseif monthNumber == 7 then
			return "Julho"
		elseif monthNumber == 8 then
			return "Agosto"
		elseif monthNumber == 9 then
			return "Setembro"
		elseif monthNumber == 10 then
			return "Outubro"
		elseif monthNumber == 11 then
			return "Novembro"
		elseif monthNumber == 12 then
			return "Dezembro"
		else
			return "Janeiro"
		end
	end
end

function daysInMonth(month, year)
	if not month or not year or not tonumber(month) or not tonumber(year) then
		return 31
	else
		month = tonumber(month)
		year = tonumber(year)
	end

	if month == 1 then
		return 31
	elseif month == 2 then
		if isThisYearLeap(year) then
			return 29
		else
			return 28
		end
	elseif month == 3 then
		return 31
	elseif month == 4 then
		 return 30
	elseif month == 5 then
		return 31
	elseif month == 6 then
		return 30
	elseif month == 7 then
		return 31
	elseif month == 8 then
		return 31
	elseif month == 9 then
		return 30
	elseif month == 10 then
		return 31
	elseif month == 11 then
		return 30
	elseif month == 12 then
		return 31
	else
		return 31
	end
end

function formatDate(day)
	if not day or not tonumber(day) then
		return "1st"
	else
		day = tonumber(day)
		if day == 1 or day == 21 or day == 31 then
			return day.."st"
		elseif day == 2 or day == 22 then
			return day.."nd"
		elseif day == 3 or day == 23 then
			return day.."rd"
		else
			return day.."th"
		end
	end
end
