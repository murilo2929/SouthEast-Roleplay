function getJobTitleFromID(jobID)
	if (tonumber(jobID)==1) then
		return "Motorista de Entrega"
	elseif (tonumber(jobID)==2) then
		return "Taxista"
	elseif  (tonumber(jobID)==3) then
		return "Motorista de Onibus"
	elseif (tonumber(jobID)==4) then
		return "Manutenção da Cidade"
	elseif (tonumber(jobID)==5) then
		return "Mecânico"
	elseif (tonumber(jobID)==6) then
		return "Locksmith"
	elseif (tonumber(jobID)==7) then
		return "Motorista de Caminhão de Longa Distância"
	else
		return "Desempregado"
	end
end