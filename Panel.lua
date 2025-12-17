--// =========================================================
--// 7DVI HUB | PREMIUM PANEL 2025
--// Single File Script | FULL FIXED | STABLE
--// =========================================================

--// CONFIG
local HUB_NAME = "7dvi hub"
local HUB_VERSION = "v1.3.1"
local VALID_KEY = "7dvi-2025-PREMIUM"

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// STATES
local MenuOpen = true
local Minimized = false
local FlyEnabled = false
local SpeedEnabled = false
local ESPEnabled = false
local NoclipEnabled = false

local FlySpeed = 60
local WalkSpeedValue = 16

local FlyBV, FlyBG
local ESP_CACHE = {}

--// =========================================================
--// UTILS
--// =========================================================
local function GetChar()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoid()
	local c = GetChar()
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function GetHRP()
	local c = GetChar()
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function Tween(obj,time,props)
	TweenService:Create(obj,TweenInfo.new(time,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props):Play()
end

--// =========================================================
--// UI BASE
--// =========================================================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "7DVI_HUB"
ScreenGui.ResetOnSpawn = false

local Shadow = Instance.new("Frame", ScreenGui)
Shadow.Size = UDim2.fromScale(0.42,0.56)
Shadow.Position = UDim2.fromScale(0.5,0.5)
Shadow.AnchorPoint = Vector2.new(0.5,0.5)
Shadow.BackgroundColor3 = Color3.new(0,0,0)
Shadow.BackgroundTransparency = 0.55
Instance.new("UICorner",Shadow).CornerRadius = UDim.new(0,22)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromScale(0.4,0.52)
Main.Position = UDim2.fromScale(0.5,0.5)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,22)

--// DRAG
do
	local dragging, dragStart, startPos
	Main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = i.Position
			startPos = Main.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
			Shadow.Position = Main.Position
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

--// TOP BUTTONS
local CloseAll = Instance.new("TextButton",Main)
CloseAll.Size = UDim2.fromOffset(32,32)
CloseAll.Position = UDim2.new(1,-38,0,8)
CloseAll.Text = "X"
CloseAll.BackgroundColor3 = Color3.fromRGB(120,60,60)
CloseAll.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",CloseAll)

local MinBtn = Instance.new("TextButton",Main)
MinBtn.Size = UDim2.fromOffset(32,32)
MinBtn.Position = UDim2.new(1,-76,0,8)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
MinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",MinBtn)

CloseAll.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
	Minimized = not Minimized
	if Minimized then
		Tween(Main,0.25,{Size = UDim2.fromScale(0.4,0.08)})
		Tween(Shadow,0.25,{Size = UDim2.fromScale(0.42,0.1)})
	else
		Tween(Main,0.25,{Size = UDim2.fromScale(0.4,0.52)})
		Tween(Shadow,0.25,{Size = UDim2.fromScale(0.42,0.56)})
	end
end)

--// =========================================================
--// KEY SYSTEM
--// =========================================================
local KeyFrame = Instance.new("Frame",Main)
KeyFrame.Size = UDim2.fromScale(1,1)
KeyFrame.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox",KeyFrame)
KeyBox.Size = UDim2.fromScale(0.6,0.12)
KeyBox.Position = UDim2.fromScale(0.5,0.42)
KeyBox.AnchorPoint = Vector2.new(0.5,0.5)
KeyBox.PlaceholderText = "Digite a KEY"
KeyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
KeyBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",KeyBox)

local Verify = Instance.new("TextButton",KeyFrame)
Verify.Size = UDim2.fromScale(0.3,0.1)
Verify.Position = UDim2.fromScale(0.5,0.56)
Verify.AnchorPoint = Vector2.new(0.5,0.5)
Verify.Text = "Verificar Key"
Verify.BackgroundColor3 = Color3.fromRGB(55,55,55)
Verify.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Verify)

local KeyMsg = Instance.new("TextLabel",KeyFrame)
KeyMsg.Size = UDim2.fromScale(1,0.1)
KeyMsg.Position = UDim2.fromScale(0,0.7)
KeyMsg.BackgroundTransparency = 1
KeyMsg.Text = ""

local Hub = Instance.new("Frame",Main)
Hub.Size = UDim2.fromScale(1,1)
Hub.Visible = false
Hub.BackgroundTransparency = 1

Verify.MouseButton1Click:Connect(function()
	if KeyBox.Text == VALID_KEY then
		KeyMsg.Text = "Key válida!"
		KeyMsg.TextColor3 = Color3.fromRGB(0,255,0)
		task.wait(0.4)
		KeyFrame.Visible = false
		Hub.Visible = true
	else
		KeyMsg.Text = "Key inválida!"
		KeyMsg.TextColor3 = Color3.fromRGB(255,0,0)
	end
end)

--// =========================================================
--// TABS
--// =========================================================
local Tabs = {"Main","Player","Visual","Advantage","Settings"}
local TabFrames = {}

local TabBar = Instance.new("Frame",Hub)
TabBar.Size = UDim2.fromScale(1,0.12)
TabBar.BackgroundColor3 = Color3.fromRGB(18,18,18)

local Content = Instance.new("Frame",Hub)
Content.Size = UDim2.fromScale(1,0.88)
Content.Position = UDim2.fromScale(0,0.12)
Content.BackgroundTransparency = 1

for i,name in ipairs(Tabs) do
	local btn = Instance.new("TextButton",TabBar)
	btn.Size = UDim2.fromScale(1/#Tabs,1)
	btn.Position = UDim2.fromScale((i-1)/#Tabs,0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.TextColor3 = Color3.new(1,1,1)

	local frame = Instance.new("Frame",Content)
	frame.Size = UDim2.fromScale(1,1)
	frame.Visible = false
	frame.BackgroundTransparency = 1
	TabFrames[name] = frame

	btn.MouseButton1Click:Connect(function()
		for _,f in pairs(TabFrames) do f.Visible = false end
		frame.Visible = true
	end)
end
TabFrames.Main.Visible = true

--// =========================================================
--// MAIN TAB (IMAGE PICKER)
--// =========================================================
local MTab = TabFrames.Main

local ImageBox = Instance.new("TextBox",MTab)
ImageBox.Size = UDim2.fromScale(0.6,0.12)
ImageBox.Position = UDim2.fromScale(0.2,0.25)
ImageBox.PlaceholderText = "ImageId (rbxassetid://)"
ImageBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
ImageBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",ImageBox)

local SetImage = Instance.new("TextButton",MTab)
SetImage.Size = UDim2.fromScale(0.3,0.12)
SetImage.Position = UDim2.fromScale(0.2,0.4)
SetImage.Text = "Aplicar Imagem"
SetImage.BackgroundColor3 = Color3.fromRGB(60,60,60)
SetImage.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",SetImage)

local Preview = Instance.new("ImageLabel",MTab)
Preview.Size = UDim2.fromScale(0.25,0.25)
Preview.Position = UDim2.fromScale(0.6,0.25)
Preview.BackgroundTransparency = 1

SetImage.MouseButton1Click:Connect(function()
	Preview.Image = ImageBox.Text
end)

--// =========================================================
--// PLAYER TAB (ANIM SCROLL FIXED)
--// =========================================================
local PTab = TabFrames.Player
local Scroll = Instance.new("ScrollingFrame",PTab)
Scroll.Size = UDim2.fromScale(0.9,0.9)
Scroll.Position = UDim2.fromScale(0.05,0.05)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarImageTransparency = 0
Scroll.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner",Scroll)

local UIList = Instance.new("UIListLayout",Scroll)
UIList.Padding = UDim.new(0,6)

for i=1,10000 do
	local b = Instance.new("TextButton",Scroll)
	b.Size = UDim2.new(1,-10,0,28)
	b.Text = "Animation "..i
	b.BackgroundColor3 = Color3.fromRGB(55,55,55)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",b)
end
task.wait()
Scroll.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y+10)

--// =========================================================
--// ADVANTAGE TAB
--// =========================================================
local ATab = TabFrames.Advantage
local function ToggleBtn(txt,y,cb)
	local b = Instance.new("TextButton",ATab)
	b.Size = UDim2.fromScale(0.6,0.08)
	b.Position = UDim2.fromScale(0.2,y)
	b.Text = txt
	b.BackgroundColor3 = Color3.fromRGB(70,70,70)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",b)
	b.MouseButton1Click:Connect(cb)
end

ToggleBtn("Fly",0.05,function() FlyEnabled = not FlyEnabled end)
ToggleBtn("Speed",0.15,function()
	SpeedEnabled = not SpeedEnabled
	local h = GetHumanoid()
	if h then h.WalkSpeed = SpeedEnabled and WalkSpeedValue or 16 end
end)
ToggleBtn("Noclip",0.25,function() NoclipEnabled = not NoclipEnabled end)

--// =========================================================
--// FLY + NOCLIP FIXED
--// =========================================================
RunService.RenderStepped:Connect(function()
	local char = GetChar()
	if NoclipEnabled then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
	if FlyEnabled then
		local hrp = GetHRP()
		if not hrp then return end
		if not FlyBV then
			FlyBV = Instance.new("BodyVelocity",hrp)
			FlyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
			FlyBG = Instance.new("BodyGyro",hrp)
			FlyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
		end
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
		FlyBV.Velocity = dir * FlySpeed
		FlyBG.CFrame = Camera.CFrame
	else
		if FlyBV then FlyBV:Destroy() FlyBV=nil end
		if FlyBG then FlyBG:Destroy() FlyBG=nil end
	end
end)

--// =========================================================
--// SETTINGS TAB
--// =========================================================
local STab = TabFrames.Settings
local KeyInfo = Instance.new("TextLabel",STab)
KeyInfo.Size = UDim2.fromScale(1,0.15)
KeyInfo.Position = UDim2.fromScale(0,0.4)
KeyInfo.BackgroundTransparency = 1
KeyInfo.TextColor3 = Color3.new(1,1,1)
KeyInfo.Text = "Key ativa: "..VALID_KEY
