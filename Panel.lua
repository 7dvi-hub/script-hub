--// =========================================================
--// 7DVI HUB | PREMIUM PANEL 2025
--// Single File Script | FULL – FINAL – STABLE
--// =========================================================

--// ================= CONFIG =================
local HUB_NAME = "7dvi hub"
local HUB_VERSION = "v1.3.0"
local VALID_KEY = "7dvi-2025-PREMIUM"

local TOGGLE_KEY = Enum.KeyCode.RightShift

--// ================= SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// ================= STATES =================
local MenuOpen = true
local FlyEnabled = false
local SpeedEnabled = false
local ESPNames = false
local ESPLines = false
local AimbotEnabled = false
local SilentEnabled = false

local FlySpeed = 60
local WalkSpeed = 16
local AimSmooth = 0.15
local SilentRadius = 12
local ESPNameSize = 14
local ESPColor = Color3.fromRGB(255,60,60)

--// ================= UTILS =================
local function Char() return LP.Character or LP.CharacterAdded:Wait() end
local function Hum() return Char():FindFirstChildOfClass("Humanoid") end
local function HRP(plr)
	return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
end

--// ================= UI BASE =================
local GUI = Instance.new("ScreenGui", game.CoreGui)
GUI.Name = "7DVI_HUB"
GUI.ResetOnSpawn = false

local Shadow = Instance.new("Frame", GUI)
Shadow.Size = UDim2.fromScale(0.42,0.56)
Shadow.Position = UDim2.fromScale(0.5,0.5)
Shadow.AnchorPoint = Vector2.new(0.5,0.5)
Shadow.BackgroundColor3 = Color3.new(0,0,0)
Shadow.BackgroundTransparency = 0.5
Instance.new("UICorner",Shadow).CornerRadius = UDim.new(0,20)

local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.fromScale(0.4,0.52)
Main.Position = UDim2.fromScale(0.5,0.5)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,20)

--// DRAG
do
	local dragging, dragStart, startPos
	Main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = i.Position
			startPos = Main.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
			Shadow.Position = Main.Position
		end
	end)
end

--// CLOSE / MINIMIZE
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromOffset(30,30)
Close.Position = UDim2.new(1,-36,0,6)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(120,50,50)
Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Close)

local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.fromOffset(30,30)
Min.Position = UDim2.new(1,-72,0,6)
Min.Text = "-"
Min.BackgroundColor3 = Color3.fromRGB(60,60,60)
Min.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Min)

Close.MouseButton1Click:Connect(function()
	GUI:Destroy()
end)

Min.MouseButton1Click:Connect(function()
	MenuOpen = not MenuOpen
	Main.Visible = MenuOpen
	Shadow.Visible = MenuOpen
end)

UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == TOGGLE_KEY then
		MenuOpen = not MenuOpen
		Main.Visible = MenuOpen
		Shadow.Visible = MenuOpen
	end
end)

--// ================= KEY SYSTEM =================
local KeyFrame = Instance.new("Frame",Main)
KeyFrame.Size = UDim2.fromScale(1,1)
KeyFrame.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox",KeyFrame)
KeyBox.Size = UDim2.fromScale(0.6,0.12)
KeyBox.Position = UDim2.fromScale(0.5,0.45)
KeyBox.AnchorPoint = Vector2.new(0.5,0.5)
KeyBox.PlaceholderText = "Digite a KEY"
KeyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
KeyBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",KeyBox)

local Verify = Instance.new("TextButton",KeyFrame)
Verify.Size = UDim2.fromScale(0.3,0.1)
Verify.Position = UDim2.fromScale(0.5,0.6)
Verify.AnchorPoint = Vector2.new(0.5,0.5)
Verify.Text = "Verificar"
Verify.BackgroundColor3 = Color3.fromRGB(55,55,55)
Verify.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Verify)

local Msg = Instance.new("TextLabel",KeyFrame)
Msg.Size = UDim2.fromScale(1,0.1)
Msg.Position = UDim2.fromScale(0,0.72)
Msg.BackgroundTransparency = 1
Msg.TextColor3 = Color3.new(1,1,1)

local Hub = Instance.new("Frame",Main)
Hub.Size = UDim2.fromScale(1,1)
Hub.Visible = false
Hub.BackgroundTransparency = 1

Verify.MouseButton1Click:Connect(function()
	if KeyBox.Text == VALID_KEY then
		Msg.Text = "Key válida!"
		Msg.TextColor3 = Color3.fromRGB(0,255,0)
		task.wait(0.4)
		KeyFrame.Visible = false
		Hub.Visible = true
	else
		Msg.Text = "Key inválida!"
		Msg.TextColor3 = Color3.fromRGB(255,0,0)
	end
end)

--// ================= TABS =================
local Tabs = {"Main","TP","Visual","Advanced","Settings"}
local Frames = {}

local TabBar = Instance.new("Frame",Hub)
TabBar.Size = UDim2.fromScale(1,0.12)
TabBar.BackgroundColor3 = Color3.fromRGB(18,18,18)

local Content = Instance.new("Frame",Hub)
Content.Size = UDim2.fromScale(1,0.88)
Content.Position = UDim2.fromScale(0,0.12)
Content.BackgroundTransparency = 1

for i,name in ipairs(Tabs) do
	local b = Instance.new("TextButton",TabBar)
	b.Size = UDim2.fromScale(1/#Tabs,1)
	b.Position = UDim2.fromScale((i-1)/#Tabs,0)
	b.Text = name
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.new(1,1,1)

	local f = Instance.new("Frame",Content)
	f.Size = UDim2.fromScale(1,1)
	f.Visible = false
	f.BackgroundTransparency = 1
	Frames[name] = f

	b.MouseButton1Click:Connect(function()
		for _,v in pairs(Frames) do v.Visible = false end
		f.Visible = true
	end)
end
Frames.Main.Visible = true

--// ================= MAIN TAB =================
local ML = Instance.new("TextLabel",Frames.Main)
ML.Size = UDim2.fromScale(1,0.25)
ML.BackgroundTransparency = 1
ML.TextScaled = true
ML.TextColor3 = Color3.new(1,1,1)
ML.Text = HUB_NAME.." - "..HUB_VERSION

--// ================= TP TAB =================
local TPScroll = Instance.new("ScrollingFrame",Frames.TP)
TPScroll.Size = UDim2.fromScale(0.6,0.7)
TPScroll.Position = UDim2.fromScale(0.2,0.15)
TPScroll.CanvasSize = UDim2.new(0,0,0,0)
TPScroll.ScrollBarImageTransparency = 0.2
TPScroll.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner",TPScroll)

local TPList = Instance.new("UIListLayout",TPScroll)
TPList.Padding = UDim.new(0,6)

local function RefreshTP()
	for _,c in pairs(TPScroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LP then
			local bt = Instance.new("TextButton",TPScroll)
			bt.Size = UDim2.new(1,-10,0,32)
			bt.Text = p.Name
			bt.BackgroundColor3 = Color3.fromRGB(50,50,50)
			bt.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner",bt)
			bt.MouseButton1Click:Connect(function()
				if HRP(LP) and HRP(p) then
					HRP(LP).CFrame = HRP(p).CFrame * CFrame.new(0,0,-3)
				end
			end)
		end
	end
	task.wait()
	TPScroll.CanvasSize = UDim2.new(0,0,0,TPList.AbsoluteContentSize.Y+10)
end
Players.PlayerAdded:Connect(RefreshTP)
Players.PlayerRemoving:Connect(RefreshTP)
RefreshTP()

--// ================= VISUAL TAB =================
local ESPNamesBtn = Instance.new("TextButton",Frames.Visual)
ESPNamesBtn.Size = UDim2.fromScale(0.5,0.12)
ESPNamesBtn.Position = UDim2.fromScale(0.25,0.2)
ESPNamesBtn.Text = "ESP Nomes"
ESPNamesBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
ESPNamesBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",ESPNamesBtn)

local ESPLinesBtn = ESPNamesBtn:Clone()
ESPLinesBtn.Parent = Frames.Visual
ESPLinesBtn.Position = UDim2.fromScale(0.25,0.36)
ESPLinesBtn.Text = "ESP Lines"

ESPNamesBtn.MouseButton1Click:Connect(function()
	ESPNames = not ESPNames
end)

ESPLinesBtn.MouseButton1Click:Connect(function()
	ESPLines = not ESPLines
end)

--// ESP LOOP
RS.RenderStepped:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
			if ESPNames then
				if not p.Character.Head:FindFirstChild("ESP") then
					local bb = Instance.new("BillboardGui",p.Character.Head)
					bb.Name = "ESP"
					bb.Size = UDim2.fromOffset(120,30)
					bb.AlwaysOnTop = true
					local t = Instance.new("TextLabel",bb)
					t.Size = UDim2.fromScale(1,1)
					t.BackgroundTransparency = 1
					t.Text = p.Name
					t.TextSize = ESPNameSize
					t.TextColor3 = ESPColor
				end
			else
				if p.Character.Head:FindFirstChild("ESP") then
					p.Character.Head.ESP:Destroy()
				end
			end
		end
	end
end)

--// ================= ADVANCED TAB =================
local function ToggleButton(parent,text,y,callback)
	local b = Instance.new("TextButton",parent)
	b.Size = UDim2.fromScale(0.5,0.1)
	b.Position = UDim2.fromScale(0.25,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",b)
	b.MouseButton1Click:Connect(callback)
end

ToggleButton(Frames.Advanced,"Fly",0.15,function() FlyEnabled = not FlyEnabled end)
ToggleButton(Frames.Advanced,"SpeedWalker",0.28,function()
	SpeedEnabled = not SpeedEnabled
	Hum().WalkSpeed = SpeedEnabled and WalkSpeed or 16
end)
ToggleButton(Frames.Advanced,"Aimbot",0.41,function() AimbotEnabled = not AimbotEnabled end)
ToggleButton(Frames.Advanced,"Silent",0.54,function() SilentEnabled = not SilentEnabled end)

--// ================= FLY =================
local BV,BG
RS.RenderStepped:Connect(function()
	if FlyEnabled and HRP(LP) then
		if not BV then
			BV = Instance.new("BodyVelocity",HRP(LP))
			BV.MaxForce = Vector3.new(1e5,1e5,1e5)
			BG = Instance.new("BodyGyro",HRP(LP))
			BG.MaxTorque = Vector3.new(1e5,1e5,1e5)
		end
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
		BV.Velocity = dir.Magnitude > 0 and dir.Unit * FlySpeed or Vector3.zero
		BG.CFrame = Camera.CFrame
	else
		if BV then BV:Destroy() BV=nil end
		if BG then BG:Destroy() BG=nil end
	end
end)

--// ================= AIMBOT =================
local function Closest()
	local best,dist=nil,math.huge
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LP and HRP(p) then
			local pos,vis = Camera:WorldToViewportPoint(HRP(p).Position)
			if vis then
				local d=(Vector2.new(pos.X,pos.Y)-UIS:GetMouseLocation()).Magnitude
				if d<dist then dist=d best=p end
			end
		end
	end
	return best
end

RS.RenderStepped:Connect(function()
	if AimbotEnabled then
		local t=Closest()
		if t and HRP(t) then
			Camera.CFrame = Camera.CFrame:Lerp(
				CFrame.new(Camera.CFrame.Position,HRP(t).Position),
				AimSmooth
			)
		end
	end
end)

--// ================= SILENT =================
RS.Stepped:Connect(function()
	if SilentEnabled then
		for _,p in pairs(Players:GetPlayers()) do
			if p~=LP and HRP(p) then
				HRP(p).Size = Vector3.new(SilentRadius,SilentRadius,SilentRadius)
				HRP(p).CanCollide = false
			end
		end
	end
end)

--// ================= SETTINGS =================
local KL = Instance.new("TextLabel",Frames.Settings)
KL.Size = UDim2.fromScale(1,0.15)
KL.Position = UDim2.fromScale(0,0.4)
KL.BackgroundTransparency = 1
KL.TextColor3 = Color3.new(1,1,1)
KL.Text = "Key ativa: "..VALID_KEY
