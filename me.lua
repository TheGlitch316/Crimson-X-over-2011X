print("[Cream.LMS] Now loading... Made by lil2kki <3")

local function makeRough(model)
	for a, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Material = (part.Material == Enum.Material.Fabric)
				and Enum.Material.Carpet
				or  Enum.Material.Sandstone
		end
	end
end

local function setupEye(eye, origSize)
	eye.Material	= Enum.Material.Neon
	eye.Size		= origSize / 1.2
	task.spawn(function()
		local sz = origSize / 1.2
		while eye and eye.Parent do
			eye.Color = Color3.new(math.random(70, 100) / 100, 0, 0)
			eye.Size  = sz * (0.8 + math.random() * 0.2)
			task.wait(math.random(3, 15) / 100)
		end
	end)
end

local function customizeEyes(model)
	local whites = model:FindFirstChild("eyes", true)
	if whites and whites:IsA("BasePart") then
		whites.Color	= Color3.new(0, 0, 0)
		whites.Material	= Enum.Material.SmoothPlastic
	end
	local eye1 = model:FindFirstChild("eye1", true)
	local eye2 = model:FindFirstChild("eye2", true)
	if eye1 then setupEye(eye1, eye1.Size) end
	if eye2 then setupEye(eye2, eye2.Size) end
end

local function applyToPlayer(model)
	if not model then return end
	if model:GetAttribute("Character") ~= "Cream" then return end
	if model:GetAttribute("Cream.LMS_setupDone") then return end
	makeRough(model)
	customizeEyes(model)
	model:SetAttribute("Cream.LMS_setupDone", true)
end

local function onModelAdded(model)
	if not model:IsA("Model") then return end
	task.wait(1)
    applyToPlayer(model)
	model.AttributeChanged:Connect(function(attr)
		if attr == "Character" then
			task.wait(1)
			applyToPlayer(model) 
		end
	end)
end

for _, model in ipairs(workspace.Players:GetChildren()) do onModelAdded(model) end
workspace.Players.ChildAdded:Connect(onModelAdded)
