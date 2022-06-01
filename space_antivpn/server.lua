local function OnPlayerConnecting(name, setKickReason, deferrals)
    -- Deferrals
    deferrals.defer()
    local src = source
    local name = GetPlayerName(src)
    local ip = GetPlayerEndpoint(source)
    local t = 'Residential'

    if ip ~= nil then
        PerformHttpRequest('https://proxycheck.io/v2/' .. ip .. '?key=' .. Config.AntiVpn.Key .. '?vpn=1&asn=1', function(err, data, headers)
            local jdata = json.decode(data)
            for f, v in pairs(jdata) do 
                if (v ~= ('ok')) then 
                    if (f ~= ('denied')) then 
                        for k, i in pairs(v) do 
                            if (k == ('type')) then 
                                if (i ~= ('Residential')) then
                                    t = i
                                end 
                            end 
                            if (k == ('proxy')) then 
                                if (i ~= ('no')) then
                                    print('[^1SpaceShield^0] ^1Checks^0 > '.. name .. ' ^0is using a vpn ip: ' .. ip)
                                    if (Config.AntiVpn.Block) then
                                        deferrals.done(Config.AntiVpn.Text..", type: ".. t ..",\nBy https://spaceshield.one/")
                                    end 
                                else 
                                    print('[^4SpaceShield^0] ^4Checks^0 > '.. name .. ' ^0is using connection type: ' .. t)
                                    if (Config.AntiVpn.Block) then
                                        deferrals.done()
                                    end 
                                end 
                            end 
                        end 
                    end 
                end 
            end
        end)
    end
    if (Config.AntiVpn.Block == false) then
        deferrals.done()
    end 
end

AddEventHandler('playerConnecting', OnPlayerConnecting)