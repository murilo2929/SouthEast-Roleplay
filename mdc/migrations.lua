local migrations = {
    "alterar a tabela mdc_criminals modificar os detalhes do texto padrão \"Nenhum.\";",
}
addEventHandler('onResourceStart', resourceRoot,
    function ()
        exports.mysql:createMigrations(getResourceName(getThisResource()), migrations)
    end
)
