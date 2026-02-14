local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Super Hub",
    Icon = "",
    Author = "by .ftgs and .ftgs",
    OpenButton = {
        Title = "Open Example UI",
        Icon = "monitor",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 2,
        Color = ColorSequence.new(
            Color3.fromHex("FF0F7B"),
            Color3.fromHex("F89B29")
        ),
        OnlyMobile = false,
        Enabled = true,
        Draggable = true,
    }
})

local Tab = Window:Tab({Title="Main",Icon="bird"})
Tab:Select()

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local normalSpeed = 16

-- RESET
Tab:Button({
Title="reset",
Callback=function()
if player.Character then player.Character:BreakJoints() end
end})

-- HACK SKY
Tab:Button({
Title="hack",
Callback=function()
for _,v in pairs(Lighting:GetChildren()) do
if v:IsA("Sky") then v:Destroy() end end
local sky=Instance.new("Sky")
local id="rbxassetid://77384233173949"
sky.SkyboxBk=id;sky.SkyboxDn=id;sky.SkyboxFt=id
sky.SkyboxLf=id;sky.SkyboxRt=id;sky.SkyboxUp=id
sky.Parent=Lighting
end})

-- SUPER SPEED
Tab:Button({
Title="วิ่งเร็วมาก",
Callback=function()
local char=player.Character or player.CharacterAdded:Wait()
local hum=char:WaitForChild("Humanoid")
hum.WalkSpeed=normalSpeed*100
task.wait(1)
hum.WalkSpeed=normalSpeed
end})

-- FLY
local flying=false;local flyBV;local flyBG;local flyCon
Tab:Button({
Title="บิน",
Callback=function()
flying=not flying
local char=player.Character or player.CharacterAdded:Wait()
local root=char:WaitForChild("HumanoidRootPart")
if flying then
flyBV=Instance.new("BodyVelocity",root)
flyBV.MaxForce=Vector3.new(1,1,1)*1e6
flyBG=Instance.new("BodyGyro",root)
flyBG.MaxTorque=Vector3.new(1,1,1)*1e6
flyCon=RunService.RenderStepped:Connect(function()
flyBG.CFrame=workspace.CurrentCamera.CFrame
flyBV.Velocity=workspace.CurrentCamera.CFrame.LookVector*80
end)
else
if flyBV then flyBV:Destroy() end
if flyBG then flyBG:Destroy() end
if flyCon then flyCon:Disconnect() end
end end})

-- NOCLIP
local noclip=false;local noclipCon
Tab:Button({
Title="ทะลุกำแพง",
Callback=function()
noclip=not noclip
if noclip then
noclipCon=RunService.Stepped:Connect(function()
if player.Character then
for _,p in pairs(player.Character:GetDescendants()) do
if p:IsA("BasePart") then p.CanCollide=false end end end end)
else
if noclipCon then noclipCon:Disconnect() end
if player.Character then
for _,p in pairs(player.Character:GetDescendants()) do
if p:IsA("BasePart") then p.CanCollide=true end end end end end})

-- AUTO WALK
local auto=false;local autoCon
Tab:Button({
Title="เดินเอง",
Callback=function()
auto=not auto
local char=player.Character or player.CharacterAdded:Wait()
local hum=char:WaitForChild("Humanoid")
if auto then
autoCon=RunService.RenderStepped:Connect(function()
hum:Move(Vector3.new(0,0,-1),true)
end)
else
if autoCon then autoCon:Disconnect() end
hum:Move(Vector3.new(),true)
end end})

-- HORROR
Tab:Button({
Title="my Horror",
Callback=function()
Lighting.Brightness=0
Lighting.FogEnd=150
Lighting.Ambient=Color3.fromRGB(255,0,0)
end})

-- INVISIBLE
local invisible=false;local saveT={};local saveS={}
Tab:Button({
Title="หายตัว",
Callback=function()
invisible=not invisible
local char=player.Character or player.CharacterAdded:Wait()
local hum=char:WaitForChild("Humanoid")
if invisible then
hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
for _,v in pairs(char:GetDescendants()) do
if v:IsA("BasePart") then saveT[v]=v.Transparency;v.Transparency=1;v.CastShadow=false end
if v:IsA("Sound") then saveS[v]=v.Volume;v.Volume=0 end end
else
hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.Viewer
for p,t in pairs(saveT) do if p then p.Transparency=t;p.CastShadow=true end end
for s,v in pairs(saveS) do if s then s.Volume=v end end
end end})

-- SUMMON BLOCK
Tab:Button({
Title="เสกบล็อก",
Callback=function()
local char=player.Character or player.CharacterAdded:Wait()
local root=char:WaitForChild("HumanoidRootPart")
local look=workspace.CurrentCamera.CFrame.LookVector
local dir=Vector3.new(look.X,0,look.Z).Unit
for i=1,10 do
local b=Instance.new("Part")
b.Size=Vector3.new(5,5,5)
b.Anchored=true
b.Material=Enum.Material.Neon
b.Color=Color3.fromRGB(0,255,255)
b.Position=root.Position+(dir*(i*6))
b.Parent=workspace
end end})

-- TSUNAMI (โดนแล้วตาย)
Tab:Button({
Title="สึนามิ",
Callback=function()

local char=player.Character or player.CharacterAdded:Wait()
local hum=char:WaitForChild("Humanoid")

Lighting.FogColor=Color3.fromRGB(0,170,255)
Lighting.FogEnd=500

local wave=Instance.new("Part")
wave.Size=Vector3.new(2000,500,150)
wave.Anchored=true
wave.CanCollide=false
wave.Material=Enum.Material.Neon
wave.Color=Color3.fromRGB(0,170,255)
wave.Transparency=0.15
wave.Position=Vector3.new(0,250,-2000)
wave.Parent=workspace

local sound=Instance.new("Sound",wave)
sound.SoundId="rbxassetid://1843529603"
sound.Volume=3
sound:Play()

wave.Touched:Connect(function(hit)
if hit.Parent==char then
hum.Health=0
end end)

local tween=TweenService:Create(wave,
TweenInfo.new(5,Enum.EasingStyle.Linear),
{Position=Vector3.new(0,250,2000)})

tween:Play()
tween.Completed:Connect(function()
wave:Destroy()
Lighting.FogEnd=100000
end)

Debris:AddItem(sound,6)

end})
