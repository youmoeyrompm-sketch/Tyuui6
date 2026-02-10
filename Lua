-- LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "CenterHackUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ================= Toggle UI Button =================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,120,0,40)
toggleBtn.Position = UDim2.new(0,10,0.8,0)
toggleBtn.Text = "เปิด / ปิด UI"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Parent = gui

-- ================= Main Frame =================
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,590,0,380)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui

-- ================= Scroll =================
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,900)
scroll.ScrollBarThickness = 8
scroll.Parent = frame

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,10)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- ================= Button Creator =================
local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-20,0,60)
	btn.Text = text
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = scroll
	return btn
end

-- ================= BUTTONS =================

-- 1️⃣ RESET
createButton("RESET").MouseButton1Click:Connect(function()
	humanoid.Health = 0
end)

-- 2️⃣ SPEED
local speedOn = false
local normalSpeed = 16
local fastSpeed = 80
local boostSpeed = 160

createButton("วิ่งเร็ว").MouseButton1Click:Connect(function()
	speedOn = not speedOn
end)

-- 8️⃣ SUPER SPEED (100x / 200x)
local superSpeedOn = false
local super100 = normalSpeed * 100
local super200 = normalSpeed * 200

createButton("วิ่งเร็วมาก ⚡").MouseButton1Click:Connect(function()
	superSpeedOn = not superSpeedOn
end)

RunService.Heartbeat:Connect(function()
	if superSpeedOn then
		humanoid.WalkSpeed = super100
	elseif speedOn then
		humanoid.WalkSpeed = fastSpeed
	else
		humanoid.WalkSpeed = normalSpeed
	end
end)

UIS.InputBegan:Connect(function(i,gp)
	if gp then return end

	-- SPEED ปกติ
	if speedOn and i.KeyCode == Enum.KeyCode.LeftShift then
		humanoid.WalkSpeed = boostSpeed
	end

	-- SUPER SPEED
	if superSpeedOn and i.KeyCode == Enum.KeyCode.LeftShift then
		humanoid.WalkSpeed = super200
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.LeftShift then
		if superSpeedOn then
			humanoid.WalkSpeed = super100
		elseif speedOn then
			humanoid.WalkSpeed = fastSpeed
		end
	end
end)

-- 3️⃣ NOCLIP
local noclip = false
createButton("ทะลุกำแพง").MouseButton1Click:Connect(function()
	noclip = not noclip
end)

RunService.Stepped:Connect(function()
	if noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- 4️⃣ FLY
local flying = false
local bv, bg

createButton("Fly 🐦").MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		bv = Instance.new("BodyVelocity", root)
		bv.MaxForce = Vector3.new(9e9,9e9,9e9)
		bv.Velocity = Vector3.new(0,50,0)

		bg = Instance.new("BodyGyro", root)
		bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

-- 5️⃣ SKYBOX
createButton("HACK").MouseButton1Click:Connect(function()
	local sky = Instance.new("Sky")
	for _,f in pairs({"Bk","Dn","Ft","Lf","Rt","Up"}) do
		sky["Skybox"..f] = "rbxassetid://77384233173949"
	end
	sky.Parent = game.Lighting
end)

-- 6️⃣ INVISIBLE
local invisible = false
local invisBtn = createButton("หายตัว 😶‍🌫️")
local savedVolumes = {}

local function setInvisible(state)
	for _,v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.Transparency = state and 1 or 0
			v.CastShadow = not state
		elseif v:IsA("Decal") then
			v.Transparency = state and 1 or 0
		elseif v:IsA("Sound") then
			if state then
				savedVolumes[v] = v.Volume
				v.Volume = 0
			else
				if savedVolumes[v] then
					v.Volume = savedVolumes[v]
				end
			end
		end
	end

	humanoid.DisplayDistanceType = state
		and Enum.HumanoidDisplayDistanceType.None
		or Enum.HumanoidDisplayDistanceType.Viewer
end

invisBtn.MouseButton1Click:Connect(function()
	invisible = not invisible
	setInvisible(invisible)
end)

-- 7️⃣ VR
createButton("VR 🥽").MouseButton1Click:Connect(function()
	loadstring(game:HttpGet(
		"https://rawscripts.net/raw/Universal-Script-fake-vr-USE-CURRENTANGLE-V2-46392"
	))()
end)
