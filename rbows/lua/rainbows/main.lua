
-- THC Rainbow Physics Guns and Players --
-- Copyright Top Hatted Cat 2014 --
-- Contact via Steam: http://steamcommunity.com/id/MKW9813/ --

-- Main Lua File --
-- Editing this file is not required --

local function checkGroupColour(ply)
	for k, v in pairs(thcRainbowsConfig.UserGroups) do
		if (v) and (ply:IsUserGroup(k)) then
			return true
		end
	end
	return false
end

local function shouldChangeColour(ply)
	if (ply.shouldChangeColour) then return true end
	if (checkGroupColour(ply)) then return true end
	if (thcRainbowsConfig.SteamIDs[ply:SteamID()]) then return true	end
	return false
end

local meta = FindMetaTable("Player")

if (meta) then
	function meta:SetRainbowColour(bool)
		if (bool) then
			bool = true
		else
			bool = false
		end
		self.shouldChangeColour = bool
	end

	function meta:HasRainbowColour()
		return self.shouldChangeColour or false
	end

	function meta:ToggleRainbowColour()
		self.shouldChangeColour = !self.shouldChangeColour
	end

	meta.SetRainbowColor = meta.SetRainbowColour
	meta.HasRainbowColor = meta.HasRainbowColour
	meta.ToggleRainbowColor = meta.ToggleRainbowColour
end


local CurTime = CurTime
local Vector = Vector
local sin = math.sin

hook.Remove("Tick", "THC_Rainbows")
local function thcRainbows()
	local freq = thcRainbowsConfig.changeTime or 3
	local counter = CurTime()
	local red = sin(freq * counter) * 127 + 128
	local green = sin(freq * counter + 2) * 127 + 128
	local blue = sin(freq * counter + 4) * 127 + 128
	local vec = Vector(red / 255, green / 255, blue / 255)
	for k, v in pairs(player.GetAll()) do
		if (thcRainbowsConfig.everyoneHasRainbow) or (shouldChangeColour(v)) then
			if (thcRainbowsConfig.physicsGun) then
				v:SetWeaponColor(vec)
			end
			
			if (thcRainbowsConfig.playerColour) then
				v:SetPlayerColor(vec)
			end
		end
	end
end
hook.Add("Tick", "THC_Rainbows", thcRainbows)

hook.Add("PlayerSpawn", "THC_Rainbows:CheckDB", function(player)
	if (player:GetPData("THC_R_HasRainbow", false)) then
		player.shouldChangeColour = true
	end
end)

local function playerByName(name)
	for k, v in pairs(player.GetAll()) do
		if (string.find(name:Nick(), name)) then
			return v
		end
	end
end

concommand.Add("rainbows_give", function(ply, cmd, args)
	if (ply:IsSuperAdmin()) then
		local target = playerByName(args[1])
		if (target) then
			target:SetPData("THC_R_HasRainbow", true)
			target:SetRainbowColour(true)
		end
	end
end)

concommand.Add("rainbows_take", function(ply, cmd, args)
	if (ply:IsSuperAdmin()) then
		local target = playerByName(args[1])
		if (target) then
			target:SetPData("THC_R_HasRainbow", false)
			target:SetRainbowColour(false)
		end
	end
end)