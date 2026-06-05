print("[Cream x TailsDoll] Now loading... Made by lil2kki <3")

local tar = game:GetService("ReplicatedStorage")
tar = tar:FindFirstChild("Characters", true)
tar = tar:FindFirstChild("TailsDoll", true)
tar = tar:FindFirstChild("Skins", true)

local OLD_THERE_ALR = tar:FindFirstChild("_OLD", true)
if OLD_THERE_ALR then
    warn("[Cream x TailsDoll] Restoring original skin")
    tar:FindFirstChild("Default", true):Destroy()
    OLD_THERE_ALR.Name = "Default"
end

tar = tar:FindFirstChild("Default", true)

local src = game:GetService("ReplicatedStorage")
src = src:FindFirstChild("Characters", true)
src = src:FindFirstChild("Cream", true)
src = src:FindFirstChild("Skins", true)
src = src:FindFirstChild("Default", true)

if not tar or not src then warn("models not found") return end

-- clone cream
local model = src:Clone()

model.Name = tar.Name
model.Parent = tar.Parent

tar.Name = "_OLD"

for _, v in ipairs(model:GetDescendants()) do
    if v:IsA("BasePart") then
        -- make rough material
        v.Material = (v.Material == Enum.Material.Fabric) and Enum.Material.Carpet or Enum.Material.Sandstone
    end
end

local function find(name)
    return model:FindFirstChild(name, true)
end

-- red dots :3
local function setupEye(eye)
    eye.Material = Enum.Material.Neon
	eye.Color = Color3.fromRGB(255,0,0)
	eye.Size = eye.Size / 1.3
end
local eye1 = find("eye1")
local eye2 = find("eye2")
if eye1 then setupEye(eye1) end
if eye2 then setupEye(eye2) end

-- eyes
local eyes = model:FindFirstChild("eyes", true)
if eyes and eyes:IsA("BasePart") then
    eyes.Color      = Color3.new(0, 0, 0)
    eyes.Material   = Enum.Material.SmoothPlastic
end

-- rename parts
local function rename(oldName, newName)
	local obj = find(oldName)
	while obj do
		-- print("renaming: "..obj.Name.." -> "..newName.." //"..obj.ClassName)
		obj.Name = newName
		obj = find(oldName)
	end 
end
rename("waist", "Waist")
rename("Body", "MainBody")

rename("eye1", "REye")
rename("eye2", "LEye")

rename("Right Sleeve", "RArm1")
rename("Cylinder.013", "RArm2")
rename("Cylinder.014", "RArm3")
rename("Cylinder.017", "RArm4")
rename("Right Hand", "RHand")

rename("Left Sleeve", "LArm1")
rename("Cylinder.023", "LArm2")
rename("Cylinder.022", "LArm3")
rename("Left Hand", "LHand")

rename("Right Leg", "RLeg1")
rename("Cylinder.001", "RLeg2")
rename("Cylinder", "RLeg3")
rename("Right Shoe", "RShoe")

rename("Left Leg", "LLeg1")
rename("Cylinder.034", "LLeg2")
rename("Cylinder.035", "LLeg3")
rename("Left Shoe", "LShoe")

rename("tail", "RTail")

-- blood on muzzle :3
local muzzle = model:FindFirstChild("muzzle", true)
if muzzle then
	local decal		= Instance.new("Decal")
	decal.Texture	= "rbxassetid://7321057974"
	decal.Parent	= muzzle
end

--- FUCKING SERVER SIDED PLAYER BUILD HOLY HELL

local function replaceCharacter(playerName)
	local plrModel = workspace.Players:FindFirstChild(playerName)
	if not plrModel then return end

	if plrModel:GetAttribute("Character") ~= "TailsDoll" then return end
    
	local hrp = plrModel:FindFirstChild("HumanoidRootPart", true)
	if not hrp then return end

    for _, v in ipairs(plrModel:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then 
            if string.find(v.Name, "Claw") then v:Destroy() end
            v.Transparency = 1
        end
    end
    
    local src = game:GetService("ReplicatedStorage")
    src = src:FindFirstChild("Characters", true)
    src = src:FindFirstChild("TailsDoll", true)
    src = src:FindFirstChild("Skins", true)
    src = src:FindFirstChild("Default", true)

    local mdl = src:Clone()
	mdl.Parent = plrModel

	local newHrp = mdl:FindFirstChild("HumanoidRootPart", true)
	if not newHrp then mdl:Destroy() return end

	for _, v in ipairs(mdl:GetDescendants()) do
		if v:IsA("Humanoid") then v:Destroy() end
		if v:IsA("Animator") then v:Destroy() end
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
	end

	local hrpOffset = Vector3.new(0, -1, 0)

	_G.CreamOnTailsDollSkinUpdateConnection = _G.CreamOnTailsDollSkinUpdateConnection or nil
    if _G.CreamOnTailsDollSkinUpdateConnection then
        _G.CreamOnTailsDollSkinUpdateConnection:Disconnect()
        _G.CreamOnTailsDollSkinUpdateConnection = nil
        print("[Cream x TailsDoll] Previous update connection destroyed")
    end
    _G.CreamOnTailsDollSkinUpdateConnection = game:GetService("RunService").Heartbeat:Connect(function()
		if not mdl or not mdl.Parent then
			warn("[Cream x TailsDoll] Model destroyed, restarting overlay")
			_G.CreamOnTailsDollSkinUpdateConnection:Disconnect()
        	_G.CreamOnTailsDollSkinUpdateConnection = nil
			replaceCharacter(playerName)
			return
		end
		
		if plrModel:GetAttribute("Character") ~= "TailsDoll" then
			_G.CreamOnTailsDollSkinUpdateConnection:Disconnect()
        	_G.CreamOnTailsDollSkinUpdateConnection = nil
			mdl:Destroy()
			return
		end
		
		newHrp.CFrame = hrp.CFrame + hrpOffset
	end)

    return plrModel
end

local function walkPlayers()
    task.wait(1)
    for _, model in ipairs(workspace:WaitForChild("Players"):GetChildren()) do
    	if not model:IsA("Model") then continue end
    	if model:GetAttribute("Character") ~= "TailsDoll" then continue end
    	replaceCharacter(model.Name)
    end
end

walkPlayers()

_G.CreamOnTailsDollSkinGameStateConnection = _G.CreamOnTailsDollSkinGameStateConnection or nil
if _G.CreamOnTailsDollSkinGameStateConnection then
	_G.CreamOnTailsDollSkinGameStateConnection:Disconnect()
	_G.CreamOnTailsDollSkinGameStateConnection = nil
	print("[Cream x TailsDoll] Previous game state connection destroyed")
end
_G.CreamOnTailsDollSkinGameStateConnection = workspace:WaitForChild("GameProperties"):WaitForChild("State").Changed:Connect(function(newState)
    if newState ~= "ING" then return end
	walkPlayers()
end)

-- custom sounds..
local function loadCustomAsset(fileName)
    local cachePath = "cache/cream-on-doll/" .. fileName
    if isfile(cachePath) then return getcustomasset(cachePath) end
    local success, result = pcall(
        function()
            return game:HttpGet(
                "https://github.com/thaLILNIKKI/Cream.LMS-for-TailsDoll-Outcome-Memories/releases/download/"
                .. "assets/" .. fileName
            )
        end
    )
    if success and result then
        writefile(cachePath, result)
        return getcustomasset(cachePath)
    else
        warn("[Cream x TailsDoll] failed to load " .. fileName)
        return nil
    end
end

local assigns = {
    [80901931085615] = loadCustomAsset("NormalChaseFix.mp3"),
    [129416111545242] = loadCustomAsset("TerrorRadius.mp3"),
    [112879248941055] = loadCustomAsset("LastLifeChase3.mp3"),
	
    [112976135484851] = loadCustomAsset("Unleashed1.mp3"),
    [106071428647005]  = loadCustomAsset("Unleashed2.mp3"),
    [87302988643016]  = loadCustomAsset("Unleashed3.mp3"),
    [131820864449998] = loadCustomAsset("Retract.mp3"), -- giggle or smth here ~

	[97101227703333] = "rbxassetid://139116822099909",  -- .Hit1]  2011x Hit2
	[93465914238963] = "rbxassetid://88164444698409",  -- Lilith.Hit2] 
	[113251186335660] = "rbxassetid://5507830073",  -- Lilith.Hit3] 
	
    [73636680793269] = "rbxassetid://77110140707717",  -- basic Swing
    [108753423324802] = "rbxassetid://77110140707717",  -- basic Swing
    [134998846301914] = "rbxassetid://77110140707717",  -- basic Swing
}

_G.CreamOnTailsDollSkinDescendantAddedConnection = _G.CreamOnTailsDollSkinDescendantAddedConnection or nil
if _G.CreamOnTailsDollSkinDescendantAddedConnection then
	_G.CreamOnTailsDollSkinDescendantAddedConnection:Disconnect()
	_G.CreamOnTailsDollSkinDescendantAddedConnection = nil
	print("[Cream x TailsDoll] Previous DescendantAdded connection destroyed")
end
_G.CreamOnTailsDollSkinDescendantAddedConnection = game.DescendantAdded:Connect(function(desc)
    if desc:IsA("Sound") then
        task.wait(0.001)
        local id = tonumber(desc.SoundId:match("rbxassetid://(%d+)"))
        if id and assigns[id] then desc.SoundId = assigns[id] end
        local group = "na"
        if desc.SoundGroup then group = desc.SoundGroup.Name end
        --print(desc.Name .. ": " .. desc.Volume .. ", at group " .. group)
    end
end)

local HIT_SOUNDS = {
	"rbxassetid://97101227703333",
	"rbxassetid://93465914238963",
	"rbxassetid://113251186335660"
}
_G.CreamOnTailsDollSkinCharacterFXConnection = _G.CreamOnTailsDollSkinCharacterFXConnection or nil
if _G.CreamOnTailsDollSkinCharacterFXConnection then
	_G.CreamOnTailsDollSkinCharacterFXConnection:Disconnect()
	_G.CreamOnTailsDollSkinCharacterFXConnection = nil
	print("[Cream x TailsDoll] Previous CharacterFX connection destroyed")
end
_G.CreamOnTailsDollSkinCharacterFXConnection = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CharacterFX").OnClientEvent:Connect(
    function(action, target)
        local name = tostring(target)
        if action == "alertsurvivors" then
            for _, model in ipairs(workspace:WaitForChild("Players"):GetChildren()) do
                if not model:IsA("Model") then continue end
	            if model:GetAttribute("Character") ~= "TailsDoll" then continue end
                local sound = Instance.new("Sound")
                sound.Name = "TailsDollHit"
                sound.SoundId = HIT_SOUNDS[math.random(1, #HIT_SOUNDS)]
                sound.Volume = 1
                sound.RollOffMaxDistance = 115
                sound.RollOffMinDistance = 10
                sound.SoundGroup = game.ReplicatedStorage.ClientAssets.Sounds.sfx
                sound.Parent = model
                sound:Play()
                game:GetService("Debris"):AddItem(sound, sound.TimeLength + 0.5)
            end
        end
    end
)
