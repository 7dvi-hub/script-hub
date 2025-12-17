--// =====================================================
--// 7DVI HUB | PREMIUM PANEL 2025
--// SINGLE FILE | STABLE | OPTIMIZED
--// =====================================================

--// CONFIG
local HUB_NAME = "7dvi hub"
local HUB_VERSION = "v1.3.5"
local VALID_KEY = "7dvi-2025-PREMIUM"

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// STATES
local OPEN = true
local FLY = false
local SPEED = false
local FlySpeed = 60
local WalkSpeed = 16

--// UTILS
local function Char()
	return LP.Character or LP.CharacterAdded:Wait()
end
local function Hum()
	return Char():WaitForChild("Humanoid")
end
local function HRP(plr)
	return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
end

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "7DVI_HUB"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.45,0.6)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

-- SHADOW
local shadow = Instance.new("Frame", gui)
shadow.Size = main.Size
shadow.Position = main.Position
shadow.AnchorPoint = main.AnchorPoint
shadow.BackgroundColor3 = Color3.new(0,0,0)
shadow.BackgroundTransparency = 0.45
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0,18)

-- DRAG
do
	local dragging, startPos, startInput
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startInput = i.Position
			startPos = main.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - startInput
			main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
			shadow.Position = main.Position
		end
	end)
end

-- BUTTONS
local close = Instance.new("TextButton", main)
close.Size = UDim2.fromOffset(32,32)
close.Position = UDim2.new(1,-38,0,6)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(120,40,40)
close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", close)

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.fromOffset(32,32)
minimize.Position = UDim2.new(1,-76,0,6)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimize)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

minimize.MouseButton1Click:Connect(function()
	OPEN = not OPEN
	main.Visible = OPEN
	shadow.Visible = OPEN
end)

--// HUB
local hub = Instance.new("Frame", main)
hub.Size = UDim2.fromScale(1,1)
hub.BackgroundTransparency = 1

--// TAB BAR
local tabs = {"Main","TP","Advanced"}
local frames = {}

local bar = Instance.new("Frame", hub)
bar.Size = UDim2.fromScale(1,0.12)
bar.BackgroundColor3 = Color3.fromRGB(14,14,14)

local content = Instance.new("Frame", hub)
content.Size = UDim2.fromScale(1,0.88)
content.Position = UDim2.fromScale(0,0.12)
content.BackgroundTransparency = 1

for i,name in ipairs(tabs) do
	local b = Instance.new("TextButton", bar)
	b.Size = UDim2.fromScale(1/#tabs,1)
	b.Position = UDim2.fromScale((i-1)/#tabs,0)
	b.Text = name
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.new(1,1,1)

	local f = Instance.new("Frame", content)
	f.Size = UDim2.fromScale(1,1)
	f.Visible = false
	f.BackgroundTransparency = 1
	frames[name] = f

	b.MouseButton1Click:Connect(function()
		for _,v in pairs(frames) do v.Visible = false end
		f.Visible = true
	end)
end
frames.Main.Visible = true

--// MAIN (IMAGE)
local img = Instance.new("ImageLabel", frames.Main)
img.Size = UDim2.fromScale(0.4,0.4)
img.Position = UDim2.fromScale(0.3,0.15)
img.BackgroundTransparency = 1

local box = Instance.new("TextBox", frames.Main)
box.Size = UDim2.fromScale(0.5,0.08)
box.Position = UDim2.fromScale(0.25,0.6)
box.PlaceholderText = "Cole o AssetId da imagem"
box.BackgroundColor3 = Color3.fromRGB(35,35,35)
box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", box)

local apply = Instance.new("TextButton", frames.Main)
apply.Size = UDim2.fromScale(0.3,0.08)
apply.Position = UDim2.fromScale(0.35,0.72)
apply.Text = "Apply Image"
apply.BackgroundColor3 = Color3.fromRGB(70,70,70)
apply.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", apply)

apply.MouseButton1Click:Connect(function()
	if box.Text ~= "" then
		img.Image = "rbxassetid://"..box.Text
	end
end)

--// TP TAB
local tpList = Instance.new("ScrollingFrame", frames.TP)
tpList.Size = UDim2.fromScale(0.5,0.8)
tpList.Position = UDim2.fromScale(0.25,0.1)
tpList.CanvasSize = UDim2.new(0,0,0,0)
tpList.ScrollBarImageTransparency = 0.3
Instance.new("UIListLayout", tpList)

local function RefreshTP()
	for _,v in pairs(tpList:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LP then
			local b = Instance.new("TextButton", tpList)
			b.Size = UDim2.new(1,0,0,32)
			b.Text = p.Name
			b.BackgroundColor3 = Color3.fromRGB(45,45,45)
			b.TextColor3 = Color3.new(1,1,1)
			b.MouseButton1Click:Connect(function()
				local my = HRP(LP)
				local tg = HRP(p)
				if my and tg then my.CFrame = tg.CFrame * CFrame.new(0,0,-3) end
			end)
		end
	end
	task.wait()
	tpList.CanvasSize = UDim2.new(0,0,0,tpList.UIListLayout.AbsoluteContentSize.Y + 10)
end

Players.PlayerAdded:Connect(RefreshTP)
Players.PlayerRemoving:Connect(RefreshTP)
RefreshTP()

--// ADVANCED
local function Slider(text,y,min,max,callback)
	local lbl = Instance.new("TextLabel", frames.Advanced)
	lbl.Size = UDim2.fromScale(0.5,0.05)
	lbl.Position = UDim2.fromScale(0.25,y)
	lbl.Text = text
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.BackgroundTransparency = 1

	local s = Instance.new("TextBox", frames.Advanced)
	s.Size = UDim2.fromScale(0.3,0.06)
	s.Position = UDim2.fromScale(0.35,y+0.06)
	s.Text = tostring(min)
	s.BackgroundColor3 = Color3.fromRGB(40,40,40)
	s.TextColor3 = Color3.new(1,1,1)

	s.FocusLost:Connect(function()
		local v = tonumber(s.Text)
		if v then
			v = math.clamp(v,min,max)
			callback(v)
		end
	end)
end

Slider("Fly Speed (1-1000)",0.15,1,1000,function(v) FlySpeed = v end)
Slider("Walk Speed (1-1000)",0.35,1,1000,function(v)
	WalkSpeed = v
	if SPEED then Hum().WalkSpeed = v end
end)

-- FLY
RunService.RenderStepped:Connect(function()
	if FLY then
		local hrp = HRP(LP)
		if hrp then
			local dir = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
			hrp.Velocity = dir.Magnitude > 0 and dir.Unit * FlySpeed or Vector3.zero
		end
	end
end)

-- TOGGLES
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.F then FLY = not FLY end
	if i.KeyCode == Enum.KeyCode.G then
		SPEED = not SPEED
		Hum().WalkSpeed = SPEED and WalkSpeed or 16
	end
end)
