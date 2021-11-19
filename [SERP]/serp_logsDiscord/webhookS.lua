-- created by zsenel

local adminlogs = "https://discord.com/api/webhooks/910555968910278658/FsOM2eTFcHqSua-fVlLvLInuma4lMzrqry4sh7Dmhs2D7JmLPCbq15D2zrL_bzd7cbR6"
local interior_managerLogs = "https://discord.com/api/webhooks/910633052345073695/0_5mEcvcdd0lObqO9wTvfcUkbt4-ZG11nSIp8Ttej4NkNA-d_oTqX0GqUOwnqw0xumPt"
local makeveh_logs = "https://discord.com/api/webhooks/910558320451010570/g32MAnB97TNuTdywsEqHdbgKT87i_vzds_KsrCfaZoAeGt30IuIwP0U6iKe1pepCfDLC"

function adminlogsMessage(message)
sendOptions = {
    formFields = {
        content="```"..message.."```"
    },
}
fetchRemote ( adminlogs, sendOptions, WebhookCallback )
end

function adminlogsInterior(message)
sendOptions = {
    formFields = {
        content="```"..message.."```"
    },
}
fetchRemote ( interior_managerLogs, sendOptions, WebhookCallback )
end

function adminlogsMakeveh(message)
sendOptions = {
    formFields = {
        content="```"..message.."```"
    },
}
fetchRemote ( makeveh_logs, sendOptions, WebhookCallback )
end

-- 2 arguments (responseData gives back the response or "ERROR" )
function WebhookCallback(responseData) 
outputDebugString("(Discord webhook callback): responseData: "..responseData)
end