local Player = game.Players.LocalPlayer

----------------------------------------------------
-- GUI
----------------------------------------------------

local Gui = Instance.new("ScreenGui")
Gui.Name = "MelaScript"
Gui.ResetOnSpawn = false
Gui.Parent = Player:WaitForChild("PlayerGui")

----------------------------------------------------
-- Main
----------------------------------------------------

local Main = Instance.new("Frame")
Main.Parent = Gui
Main.Size = UDim2.new(0,650,0,320)
Main.Position = UDim2.new(.5,-325,.5,-160)
Main.BackgroundColor3 = Color3.fromRGB(170,170,170)
Main.BorderSizePixel = 4

----------------------------------------------------
-- Top Bar
----------------------------------------------------

local Top = Instance.new("Frame")
Top.Parent = Main
Top.Size = UDim2.new(1,0,0,40)
Top.BackgroundColor3 = Color3.fromRGB(80,80,80)

local Close = Instance.new("TextButton")
Close.Parent = Top
Close.Size = UDim2.new(0,40,0,30)
Close.Position = UDim2.new(1,-45,0,5)
Close.Text = "X"
Close.TextScaled = true

local Mini = Instance.new("TextButton")
Mini.Parent = Top
Mini.Size = UDim2.new(0,40,0,30)
Mini.Position = UDim2.new(1,-90,0,5)
Mini.Text = "_"
Mini.TextScaled = true

----------------------------------------------------
-- EditText
----------------------------------------------------

local Edit = Instance.new("TextBox")
Edit.Parent = Main
Edit.Position = UDim2.new(.04,0,.18,0)
Edit.Size = UDim2.new(.92,0,0,120)
Edit.MultiLine = true
Edit.ClearTextOnFocus = false
Edit.TextXAlignment = Enum.TextXAlignment.Left
Edit.TextYAlignment = Enum.TextYAlignment.Top
Edit.TextSize = 22
Edit.PlaceholderText = "Write Lua Script..."
Edit.BackgroundColor3 = Color3.new(1,1,1)

----------------------------------------------------
-- Buttons
----------------------------------------------------

local function Button(Name,Pos)

	local B = Instance.new("TextButton")
	B.Parent = Main
	B.Size = UDim2.new(0,180,0,70)
	B.Position = Pos
	B.BackgroundColor3 = Color3.fromRGB(255,255,0)
	B.Text = Name
	B.TextScaled = true

	return B

end

local Run = Button("Run code",UDim2.new(.04,0,.73,0))
local Copy = Button("Copy",UDim2.new(.36,0,.73,0))
local Clear = Button("Clear",UDim2.new(.68,0,.73,0))

----------------------------------------------------
-- Open Button
----------------------------------------------------

local Open = Instance.new("TextButton")
Open.Parent = Gui
Open.Size = UDim2.new(0,60,0,60)
Open.Position = UDim2.new(0,20,.5,-30)
Open.Text = "📝"
Open.TextScaled = true
Open.Visible = false

----------------------------------------------------
-- Sound
----------------------------------------------------

local Sound = Instance.new("Sound")
Sound.Parent = Gui
Sound.SoundId = "rbxassetid://120111045036748"
Sound.Volume = 1

----------------------------------------------------
-- Close/Open
----------------------------------------------------

Close.MouseButton1Click:Connect(function()

	Main.Visible = false
	Open.Visible = true

end)

Open.MouseButton1Click:Connect(function()

	Main.Visible = true
	Open.Visible = false

end)

----------------------------------------------------
-- Minimize
----------------------------------------------------

local Hide = false

Mini.MouseButton1Click:Connect(function()

	Hide = not Hide

	Edit.Visible = not Hide
	Run.Visible = not Hide
	Copy.Visible = not Hide
	Clear.Visible = not Hide

	if Hide then
		Main.Size = UDim2.new(0,650,0,40)
	else
		Main.Size = UDim2.new(0,650,0,320)
	end

end)

----------------------------------------------------
-- Run
----------------------------------------------------

Run.MouseButton1Click:Connect(function()

	Sound:Play()

	local Code = Edit.Text

	print("==========")
	print(Code)
	print("==========")

	-- Roblox Studio ไม่สามารถรันโค้ดจาก TextBox ได้

end)

----------------------------------------------------
-- Copy
----------------------------------------------------

Copy.MouseButton1Click:Connect(function()

	Edit:CaptureFocus()
	Edit.SelectionStart = 1
	Edit.CursorPosition = #Edit.Text + 1

	print("Copy:",Edit.Text)

end)

----------------------------------------------------
-- Clear
----------------------------------------------------

Clear.MouseButton1Click:Connect(function()

	Edit.Text = "codeLua();"

end)
----------------------------------------------------
-- Drag Window
----------------------------------------------------

local UIS = game:GetService("UserInputService")

local Dragging = false
local DragInput
local DragStart
local StartPos

local function Update(Input)
	local Delta = Input.Position - DragStart
	Main.Position = UDim2.new(
		StartPos.X.Scale,
		StartPos.X.Offset + Delta.X,
		StartPos.Y.Scale,
		StartPos.Y.Offset + Delta.Y
	)
end

Top.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
	or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = true
		DragStart = Input.Position
		StartPos = Main.Position

		Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				Dragging = false
			end
		end)
	end
end)

Top.InputChanged:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseMovement
	or Input.UserInputType == Enum.UserInputType.Touch then
		DragInput = Input
	end
end)

UIS.InputChanged:Connect(function(Input)
	if Dragging and Input == DragInput then
		Update(Input)
	end
end)
