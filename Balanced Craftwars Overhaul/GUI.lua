local lPlayer = game.Players.LocalPlayer
local oreFolder = workspace:FindFirstChild("Mine") or workspace:FindFirstChild("Ores", true)
for i, v in pairs(game.Workspace:GetChildren()) do -- delete anticheat mob
	if v.Name == "f3sA+m5j6lJawxHjxJgW/LzLlhhZVGEh1ZdWucC2ZIs=" then
		v:Destroy()
	end
end

-- This is patched, fix it yourself
local mobFarmEnabled = false
local mobFarmBossOnly = false
local function mobFarm()
	local list = {} -- cheap fix for 999999 ping after turning on
	while mobFarmEnabled do
		task.wait()
		for _, mob in ipairs(workspace:GetChildren()) do
			coroutine.wrap(function() -- coroutine makes the rest of this code run without stopping the for loop
				if mob:FindFirstChild("EnemyMain") then
					if table.find(list, mob) then
						return
					else
						table.insert(list, mob)
					end
					local humanoid = mob:WaitForChild("Humanoid")
					while humanoid.Health > 0 and mobFarmEnabled do -- loop until mob is dead
						task.wait()
						if mobFarmBossOnly and not mob:FindFirstChild("Boss") then
							repeat -- fixes the mob farm breaking after toggling boss only while it's trying to kill a mob
								task.wait()
							until not mobFarmBossOnly or humanoid.Health <= 0
						end
						local character = lPlayer.Character or lPlayer.CharacterAdded:Wait()
                        -- get any sword in your backpack or character
						local sword = lPlayer.Backpack:FindFirstChild("SwordControl", true) or character:FindFirstChild("SwordControl", true)
						if sword then
							sword = sword.Parent
							coroutine.wrap(function()
								pcall(function() -- fixes breaking after you die
									if sword.Parent ~= character then
										sword.Parent = character -- force equip it
									end
									sword.RemoteFunction:InvokeServer("hit", { humanoid, sword.Damage.Value })
								end)
							end)()
						end
					end
					table.remove(list, table.find(list, mob))
				end
			end)()
		end
	end
end

-- This is supposedly patched, fix it yourself
local oreList = {}
local oreListMode = "Whitelist"
local oreFarmEnabled = false
local function oreFarm()
	while oreFarmEnabled do
		task.wait()
		local function mine(ore)
			if ore:IsA("Model") and ore:FindFirstChild("MineralMain") then
                -- all this crap to make sure the ore is loaded before trying to mine it
				local properties = ore:WaitForChild("Properties")
				local hitpoints = properties:WaitForChild("Hitpoint")
				local toughness = properties:WaitForChild("Toughness")
				local owner = properties:WaitForChild("Owner")
                -- get any pickaxe in your backpack or character
				local pickaxe = lPlayer.Backpack:FindFirstChild("PickaxeControl", true) or lPlayer.Character:FindFirstChild("PickaxeControl", true)
				local character = lPlayer.Character or lPlayer.CharacterAdded:Wait()
				local rPart = character:WaitForChild("HumanoidRootPart")
				if pickaxe then
					pickaxe = pickaxe.Parent
					local power = pickaxe:WaitForChild("Power")
					if toughness.Value <= power.Value then -- can't mine ores higher than your pickaxe level
						local oldPosition = rPart.CFrame -- save old position
						workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable -- freeze camera
						while hitpoints.Value > 0 do -- loop until ore is mined
							task.wait()
							coroutine.wrap(function()
								if pickaxe.Parent ~= character then
									pickaxe.Parent = character -- force equip it
								end
								rPart.CFrame = ore.Base.CFrame - Vector3.new(0, 5, 0) -- tp to the ore
								pickaxe.RemoteFunction:InvokeServer("hit", { hitpoints, toughness, owner })
							end)()
						end
						workspace.CurrentCamera.CameraType = Enum.CameraType.Custom -- unfreeze the camera
						pickaxe.Parent = lPlayer.Backpack -- unequip it
						rPart.CFrame = oldPosition -- go back to old position
					end
				end
			end
		end
        -- this is self-explanatory
		for _, ore in pairs(oreFolder:GetChildren()) do
			if oreListMode == "Whitelist" then
				if table.find(oreList, ore.Name) then
					mine(ore)
				end
			elseif oreListMode == "Blacklist" then
				if not table.find(oreList, ore.Name) then
					mine(ore)
				end
			end
		end
	end
end

local godmodeHealEnabled = false
local function godmodeHeal()
	while godmodeHealEnabled do
		task.wait()
		while lPlayer.Backpack:FindFirstChild("Heal", true) or lPlayer.Character:FindFirstChild("Heal", true) do -- if any healing item is found then start
			task.wait()
			if not godmodeHealEnabled then
				return
			end
            -- get any healing item
			local heal = lPlayer.Backpack:FindFirstChild("Heal", true) or lPlayer.Character:FindFirstChild("Heal", true)
			if heal then -- I realize this is redundant because of the loop condition but whatever I was tired
				heal = heal.Parent
				coroutine.wrap(function() -- coroutine to do it as fast as the loop loops
					heal.RemoteFunction:InvokeServer("hit", {lPlayer.Character:WaitForChild("Humanoid"), heal.Heal.Value, lPlayer.Character:WaitForChild("Torso")})
				end)()
			end
		end
	end
end

local godmodeShieldEnabled = false
local function godmodeShield()
	while godmodeShieldEnabled do
		task.wait()
		while lPlayer.Backpack:FindFirstChild("Sea's Revenge", true) or lPlayer.Character:FindFirstChild("Sea's Revenge", true) do -- if sea's revenge is found then start
			if not godmodeShieldEnabled then
				return
			end
			local revenge = lPlayer.Backpack:FindFirstChild("Sea's Revenge", true) or lPlayer.Character:FindFirstChild("Sea's Revenge", true)
			if revenge then -- I realize this is redundant because of the loop condition but whatever I was tired
				coroutine.wrap(function()
					pcall(function()
						revenge.RemoteFunction:InvokeServer("shield", game:GetService("Players").LocalPlayer.Character)
					end)
				end)()
			end
			task.wait(1) -- lag fix
		end
	end
end

-- this is in _G because of obfuscation, I would remove this code before obfuscating and then put it at the top of the obfuscated file
_G.noAbilityCooldownsEnabled = false
_G.noCooldowns = function()
	while _G.noAbilityCooldownsEnabled do
		task.wait()
		pcall(function() -- Some items insert this into your player after using an ability
			game.Players.LocalPlayer.AbilityCD1:Destroy() -- so delete it :D
		end)
		for _, b in pairs(getreg()) do -- this was why it lags if it was obfuscated
            -- I'm not gonna explain the rest of this code because it's not patched yet
            -- any competent dev knows what this does
			if type(b) == "function" then
				if getfenv(b).script == game.Players.LocalPlayer.Character:FindFirstChild("SwordControl", true) or game.Players.LocalPlayer.Character:FindFirstChild("SpearControl", true) then
					local sus = getupvalues(b)
					for i, v in pairs(sus) do
						if i == 3 and v == false then
							setupvalue(b, i, true)
						end
					end
				elseif getfenv(b).script == game.Players.LocalPlayer.Character:FindFirstChild("BalefireScript", true) or getfenv(b).script == game.Players.LocalPlayer.Character:FindFirstChild("HornScript", true) or game.Players.LocalPlayer.Character:FindFirstChild("NecklaceScript", true) or game.Players.LocalPlayer.Character:FindFirstChild("StaffScript", true) or getfenv(b).script == game.Players.LocalPlayer.Character:FindFirstChild("SpellMain", true) or getfenv(b).script == game.Players.LocalPlayer.Character:FindFirstChild("SummonMain", true) then
					local sus = getupvalues(b)
					for i, v in pairs(sus) do
						if i == 2 and v == false then
							setupvalue(b, i, true)
						end
					end
				end
			end
		end
	end
end

local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)() -- big mcThankies to uncle Pepsi's UI Lib

local mainWindow = library:CreateWindow({
	Name = "Furry Hack Cheat Exploits | RCtrl to toggle GUI", -- change this to change the title
	Themeable = false,
})
library.configuration.hideKeybind = Enum.KeyCode.RightControl

local mainTab = mainWindow:CreateTab({ Name = "Main" })

local mobFarmSection = mainTab:CreateSection({ Name = "Mob Farm", Side = "Left" })
local mobFarmToggle = mobFarmSection:CreateToggle({
	Name = "Enabled",
	Callback = function(v)
		mobFarmEnabled = v
		if v then
			coroutine.wrap(mobFarm)()
		end
	end,
})
local mobFarmBossOnlyToggle = mobFarmSection:CreateToggle({
	Name = "Boss Only",
	Callback = function(v)
		if v then
			mobFarmBossOnly = true
		else
			mobFarmBossOnly = false
		end
	end,
})

local oreFarmSection = mainTab:CreateSection({ Name = "Ore Farm", Side = "Left" })
local oreFarmToggle = oreFarmSection:CreateToggle({
	Name = "Enabled",
	Callback = function(v)
		oreFarmEnabled = v
		if v then
			coroutine.wrap(oreFarm)()
		end
	end,
})
local oreFarmListMode = oreFarmSection:AddDropdown({
	Name = "List Mode",
	List = { "Whitelist", "Blacklist" },
	Callback = function(v)
		oreListMode = v
	end,
})
local oreFarmList = oreFarmSection:AddDropdown({
	Name = "Ore List",
	Multi = true,
	List = {
		"Crystal",
		"Iron",
		"Gold",
		"Diamond",
		"Cobalt",
		"Viridis",
		"Oureclasium",
		"Tungsten",
		"Titanium",
		"Mithril",
		"Adamantine",
		"Titanstone",
		"Gemstone of Purity",
		"Gemstone of Hatred",
		"Purite",
		"Hatrite",
		"Hevenite",
		"Moonstone",
		"Hellite",
		"Forbidden Crystal",
	},
	Callback = function(v)
		oreList = v
	end,
})

local miscSection = mainTab:CreateSection({ Name = "Misc", Side = "Right" })
local miscnoCooldownsToggle = miscSection:CreateToggle({
	Name = "No Ability Cooldown",
	Callback = function(v)
		_G.noAbilityCooldownsEnabled = v
		if v then
			coroutine.wrap(_G.noCooldowns)()
		end
	end,
})
local miscFunny = miscSection:CreateLabel({
    -- lol half the cheat is patched what's the point
	Name = "\n\n\n\n\n\n\n\n\n\n\nI don't recommend using\nthis in public servers anymore\nIt's really easy to catch\ncheaters in this game\nsince the update on\n3/19/2022 which made a\nbunch of stuff serversided",
})

local godmodeSection = mainTab:CreateSection({ Name = "Godmodes", Side = "Left" })
local godmodeHealToggle = godmodeSection:CreateToggle({
	Name = "Any Healing Staff",
	Callback = function(v)
		godmodeHealEnabled = v
		if v then
			coroutine.wrap(godmodeHeal)()
		end
	end,
})
local godmodeShieldToggle = godmodeSection:CreateToggle({
	Name = "Sea's Revenge Shield",
	Callback = function(v)
		godmodeShieldEnabled = v
		if v then
			coroutine.wrap(godmodeShield)()
		end
	end,
})

for _, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
	v:Disable() -- anti afk
end
