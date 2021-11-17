function error_404()
	error_page("Página não encontrada", "Este site não existe.")
end

function error_9001()
	error_page("Página bloqueada", "Seu empregador bloqueou esta página.\n\nEntre em contato com sua rede\nadministradora em caso de dúvida.")
end

function error_page(title, text)
	local page_width, page_length = guiGetSize(internet_pane, false)
	setPageTitle("Error - " .. title)

	bg = guiCreateStaticImage(0,0,page_width,page_length,"websites/colours/1.png",false,internet_pane)
	guiSetEnabled(bg, false)
	
	local s = 288
	local l, t = (page_width - s)/2, (page_length - s)/2
	local image = guiCreateStaticImage(l, t, s, s,"websites/images/dinosaur.png",false,bg)
	guiScrollPaneSetScrollBars(internet_pane, false, false)
end


