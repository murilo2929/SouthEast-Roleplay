local function checkLength( value )
	return value and #value >= 0 and #value <= 165
end

local allowedImageHosts = {
	["imgur.com"] = true,
}
local imageExtensions = {
	[".jpg"] = true,
	[".png"] = true,
	[".gif"] = true,
}
function verifyImageURL(url, notEmpty)
	if not notEmpty then
		if not url or url == "" then
			return true
		end
	end
	if string.find(url, "http://", 1, true) or string.find(url, "https://", 1, true) then
		local domain = url:match("[%w%.]*%.(%w+%.%w+)") or url:match("^%w+://([^/]+)")
		if allowedImageHosts[domain] then
			local _extensions = ""
			for extension, _ in pairs(imageExtensions) do
				if _extensions ~= "" then
					_extensions = _extensions..", "..extension
				else
					_extensions = extension
				end
				if string.find(url, extension, 1, true) then
					return true
				end
			end			
		end
	end
	return false
end

editables = {
	{ name = "Peso", index = "weight", verify = function( v ) return tonumber( v ) and tonumber( v ) >= 30 and tonumber( v ) <= 200 end, instructions = "Insira o peso em kg, entre 30 e 200." },
	{ name = "Altura", index = "height", verify = function( v ) return tonumber( v ) and tonumber( v ) >= 70 and tonumber( v ) <= 220 end, instructions = "Insira a altura em cm, entre 70 e 220." },
	{ name = "Cor de cabelo", index = 1, verify = checkLength },
	{ name = "Penteado", index = 2, verify = checkLength },
	{ name = "Características faciais", index = 3, verify = checkLength },
	{ name = "Características físicas", index = 4, verify = checkLength },
	{ name = "Roupa", index = 5, verify = checkLength },
	{ name = "Acessorios", index = 6, verify = checkLength },
	{ name = "Foto", index = 7, verify = verifyImageURL, instructions = "Insira um link IMGUR para uma imagem mostrando a aparência do seu personagem." }
}