MySQL.ready(function(a)
  if a == 0 then
    print("[^5cloudfivem_whitelist^0] - Blacklist Refreshed!")
  else
    print("[^5cloudfivem_whitelist^0] - ^2" .. GetPlayerName(a) .. "^0 - Blacklist Refreshed!")
  end
end)
RegisterCommand(Config.RefreshBlacklistCommand, function(a)
  if a == 0 then
    va = true
    vb = {}
    MySQL.Async.fetchAll("SELECT * FROM dcwl", {}, function(a)
      if a[1] ~= nil then
        for fe = 1, #a do
          va[a[fe].hex] = a[fe].dcid
        end
        print("[^5cloudfivem_whitelist^0] - ^2" .. GetPlayerName(vb) .. "^0 - Whitelists Refreshed!")
        PerformHttpRequest(Config.DiscordWebhook, function(a, b, c)
        end, "POST", json.encode({
          username = Config.WebhookName,
          avatar_url = Config.WebhookAvatarUrl,
          embeds = {
            {
              author = {
                name = "Cloudfivem Whitelist",
                icon_url = "https://i.imgyukle.com/2020/05/11/r8k2GI.png"
              },
              footer = {
                text = "dev. by morpheause#3333 - cloudfivem.com"
              },
              color = 1942002,
              description = [[
Whitelist listesi yeniden yuklendi!
**Yeniden yukleyen**: ]] .. GetPlayerName(vb),
              timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
          }
        }), {
          ["Content-Type"] = "application/json"
        })
        vc = false
      end
    end)
  else
    va = true
    vb = {}
    MySQL.Async.fetchAll("SELECT * FROM dcwl", {}, function(a)
      if a[1] ~= nil then
        for fe = 1, #a do
          va[a[fe].hex] = a[fe].dcid
        end
        print("[^5cloudfivem_whitelist^0] - Whitelists Refreshed!")
        PerformHttpRequest(Config.DiscordWebhook, function(a, b, c)
        end, "POST", json.encode({
          username = Config.WebhookName,
          avatar_url = Config.WebhookAvatarUrl,
          embeds = {
            {
              author = {
                name = "Cloudfivem Whitelist",
                icon_url = "https://i.imgyukle.com/2020/05/11/r8k2GI.png"
              },
              footer = {
                text = "dev. by morpheause#3333 - cloudfivem.com"
              },
              color = 1942002,
              description = "Whitelist listesi yeniden yuklendi!",
              timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
          }
        }), {
          ["Content-Type"] = "application/json"
        })
        vb = false
      end
    end)
  end
end)
RegisterCommand(Config.RefreshCommand, function(a, b, c)
  for fn, fr in ipairs(GetPlayerIdentifiers(source)) do
    if not string.match(fr, "discord:") then
    end
    if not string.match(fr, "ip:") then
    end
  end
  c.defer()
  c.update(string.format(Config.Strings.WelcomeText, a))
  repeat
    Citizen.Wait(100)
  until not va
  c.update(Config.Strings.WelcomeText)
  for fn, fr in pairs(vb) do
    if fr.steamhex == fr and not Config.WhitelistForBlacklistedPlayers[fr] then
      c.done([[
Karalisteye eklendiginizden dolayi giris yapamiyorsunuz!
Sebep: ]] .. fr.reason .. [[

Eklendiginiz Sunucu: ]] .. fr.servername .. [[

Eklendiginiz Tarih: ]] .. fr.date .. [[

Bunun bir hata oldugunu dusunuyorsaniz destek talebi acabilirsiniz.]])
      PerformHttpRequest(Config.BlacklistWebhook, function(a, b, c)
      end, "POST", json.encode({
        username = Config.WebhookName,
        avatar_url = Config.WebhookAvatarUrl,
        embeds = {
          {
            author = {
              name = "Cloudfivem Whitelist Blacklist",
              icon_url = "https://i.imgyukle.com/2020/05/11/r8k2GI.png"
            },
            footer = {
              text = "dev. by morpheause#3333 - cloudfivem.com"
            },
            color = 15927612,
            description = [[
**Supheli oyuncu giris yapmaya calisti.
Steam Nicki: **]] .. a .. [[

**Steamhex:** ]] .. fr .. [[

**Baglandigi Discord:** <@]] .. string.sub(fr, 9) .. [[
>
**Kayitli Discord:** <@]] .. vc[fr] .. [[
>
**Eklendigi Sunucu**: ]] .. fr.servername .. [[

**Ekleyen:** <@]] .. fr.author .. [[
>
**Sebep:** ]] .. fr.reason,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
          }
        }
      }), {
        ["Content-Type"] = "application/json"
      })
      print("[^5cloudfivem_whitelist^0] - ^2" .. a .. "^0 cant connect! ^3Reason:^0 reject for ^1blacklisted player^0!")
      return
    end
  end
  if not vc[fr] then
    c.done()
    dclog(source, "Baglandi", "connect", fr, tonumber(string.sub(fr, 7), 16), fr, vc[fr], fr)
    print("[^5cloudfivem_whitelist^0] - ^2" .. a .. "^0 connected!")
  else
    if GetPlayerName(source) ~= nil then
      dclog(source, "Whitelist bulunamadi!", "nowl", fr, tonumber(string.sub(fr, 7), 16), fr, vc[fr], fr)
      print("[^5cloudfivem_whitelist^0] - ^2" .. a .. "^0 cant connect! ^3Reason:^0 Whitelist couldnt find!")
      Citizen.Wait(100)
    end
    c.done(Config.Strings.CouldntFind)
  end
end)
AddEventHandler("playerConnecting", function(a)
  for fm, fo in ipairs(GetPlayerIdentifiers(source)) do
    if not string.match(fo, "discord:") then
    end
    if not string.match(fo, "ip:") then
    end
  end
  print("[^5cloudfivem_whitelist^0] - ^2" .. GetPlayerName(source) .. "^0 disconnected!")
  dclog(source, "Ayrildi", "disconnect", fo, tonumber(string.sub(fo, 7), 16), fo, va[fo], fo, a)
end)
AddEventHandler("playerDropped", function(a, b, c, d, e, g, h, j, k)
  if GetPlayerName(a) ~= nil then
    if Config.DiscordWebhook == "" or Config.DiscordWebhook == nil then
      return
    end
    if c == "connect" then
      color = 1047645
    elseif c == "nowl" then
      color = 16181029
    elseif c == "disconnect" then
      color = 15927612
    end
    b = "**Steam Ismi:** " .. GetPlayerName(a)
    if d ~= nil then
      if k ~= nil then
        b = b .. [[

**Sebep**: ]] .. k
      end
      b = b .. [[

**SteamHex:** ]] .. d
      if e ~= nil and (Config.SteamApiKey ~= "" or Config.SteamApiKey ~= nil) then
        PerformHttpRequest("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. Config.SteamApiKey .. "&steamids=" .. e, function(a, b, c)
        end, "GET", "")
      else
        if g ~= nil then
          b = b .. [[

**Kayitli Discord:** <@]] .. g .. ">"
        end
        if h ~= nil then
          b = b .. [[

**Baglandigi Discord:** <@]] .. string.sub(h, 9) .. ">"
        end
        if j ~= nil then
          b = b .. [[

**Ip:** ]] .. string.sub(j, 4)
        end
        {
          username = Config.WebhookName,
          avatar_url = Config.WebhookAvatarUrl,
          embeds = {
            {
              thumbnail = {
                url = "https://i.hizliresim.com/Y7kyjS.png"
              },
              author = {name = b},
              footer = {
                text = "dev. by morpheause#3333 - cloudfivem.com"
              },
              color = color,
              timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
          }
        }.embeds[1].description = b
        PerformHttpRequest(Config.DiscordWebhook, function(a, b, c)
          resultData = json.decode(b)
          profileurl = resultData.response.players[1].profileurl
          profileavatar = resultData.response.players[1].avatarmedium
          profilecreatedate = resultData.response.players[1].timecreated
          if resultData.response.players[1].communityvisibilitystate == 1 or resultData.response.players[1].communityvisibilitystate == 2 then
            profilevisibility = "Gizli"
          elseif resultData.response.players[1].communityvisibilitystate == 3 then
            profilevisibility = "Herkese Acik"
          end
          if profileurl ~= nil then
            va = va .. [[

**Profil Linki:** ]] .. profileurl
            if profilevisibility ~= nil then
              va = va .. [[

**Profil Gizliligi:** ]] .. profilevisibility
            end
            if profilecreatedate ~= nil then
              va = va .. [[

**Hesap Olusturma Tarihi:** ]] .. os.date("%d-%m-%Y %H:%M:%S", profilecreatedate)
            end
            if profileavatar ~= nil then
              vb.embeds[1].thumbnail.url = profileavatar
            end
          end
          if vc ~= nil then
            va = va .. [[

**Baglandigi Discord:** <@]] .. string.sub(vc, 9) .. ">"
          end
          if vd ~= nil then
            va = va .. [[

**Kayitli Discord:** <@]] .. vd .. ">"
          end
          if ve ~= nil then
            va = va .. [[

**Ip:** ]] .. string.sub(ve, 4)
          end
          vb.embeds[1].description = va
          PerformHttpRequest(vg, function(a, b, c)
          end, "POST", json.encode(vb), vh)
        end, "POST", json.encode({
          username = Config.WebhookName,
          avatar_url = Config.WebhookAvatarUrl,
          embeds = {
            {
              thumbnail = {
                url = "https://i.hizliresim.com/Y7kyjS.png"
              },
              author = {name = b},
              footer = {
                text = "dev. by morpheause#3333 - cloudfivem.com"
              },
              color = color,
              timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
          }
        }), {
          ["Content-Type"] = "application/json"
        })
      end
    end
  end
end)
function dclog(a)
  return a:gsub([[
[&<>
]]], {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ["\n"] = "<br/>"
  }):gsub(" +", function(a)
    return " " .. ("&nbsp;"):rep(#a - 1)
  end)
end
Citizen.CreateThread(function()
  MySQL.Async.fetchAll("SELECT * FROM dcwl", {}, function(a, b, c)
    va = json.decode(b)
  end)
end)
