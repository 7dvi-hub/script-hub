--// =========================================================
--// 7DVI HUB | PREMIUM PANEL 2025
--// Single File Script | FULL FIXED & STABLE
--// =========================================================

--// CONFIG
local HUB_NAME = "7dvi hub"
local HUB_VERSION = "v1.2.1"
local VALID_KEY = "7dvi-2025-PREMIUM"

--// KEYBINDS (PADRÃO)
local TOGGLE_MENU_KEY = Enum.KeyCode.B
local FLY_KEY = Enum.KeyCode.F
local SPEED_KEY = Enum.KeyCode.G
local ESP_KEY = Enum.KeyCode.H

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// STATES
local MenuOpen = true
local FlyEnabled = false
local SpeedEnabled = false
local ESPEnabled = false
local FlySpeed = 60
local DefaultWalkSpeed = 16
local ESP_CACHE = {}
local LoadedTracks = {}
local FlyBV, FlyBG

--// =========================================================
--// UTILS
--// =========================================================
local function GetChar()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoid()
	return GetChar():FindFirstChildOfClass("Humanoid")
end

local function GetHRP(char)
	return char and char:FindFirstChild("HumanoidRootPart")
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
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X,startPos.Y.Scale,startPos.Y.Offset + delta.Y)
		Shadow.Position = Main.Position
	end
	Main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	Main.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

--// CLOSE BUTTON
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.fromOffset(36,36)
CloseBtn.Position = UDim2.new(1,-46,0,10)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",CloseBtn).CornerRadius = UDim.new(1,0)

local function ToggleMenu()
	MenuOpen = not MenuOpen
	Main.Visible = MenuOpen
	Shadow.Visible = MenuOpen
end

CloseBtn.MouseButton1Click:Connect(ToggleMenu)

--// KEY INPUT
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == TOGGLE_MENU_KEY then
		ToggleMenu()
	elseif i.KeyCode == FLY_KEY then
		FlyEnabled = not FlyEnabled
	elseif i.KeyCode == SPEED_KEY then
		SpeedEnabled = not SpeedEnabled
		local hum = GetHumanoid()
		if hum then hum.WalkSpeed = SpeedEnabled and 40 or DefaultWalkSpeed end
	elseif i.KeyCode == ESP_KEY then
		ESPEnabled = not ESPEnabled
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
local Tabs = {"Main","Player","Visual","Settings"}
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
--// MAIN TAB
--// =========================================================
local MainLabel = Instance.new("TextLabel",TabFrames.Main)
MainLabel.Size = UDim2.fromScale(1,0.3)
MainLabel.BackgroundTransparency = 1
MainLabel.TextScaled = true
MainLabel.TextColor3 = Color3.new(1,1,1)
MainLabel.Text = "Bem-vindo ao "..HUB_NAME.."\n"..HUB_VERSION

--// =========================================================
--// PLAYER TAB (TP + ANIMAÇÕES PADRÃO ROBLOX)
--// =========================================================
local PTab = TabFrames.Player

local Animations = {
	["Dance 1"] = 507771019,
	["Dance 2"] = 507776043,
	["Dance 3"] = 507777268,
	["Zombie"] = 616158929,
	["Stylish Walk"] = 616168032,
	["Ninja"] = 656118852,
	["Robot"] = 616088211,
	["Superhero"] = 616006778
}

local y = 0.05
for name,id in pairs(Animations) do
	local btn = Instance.new("TextButton",PTab)
	btn.Size = UDim2.fromScale(0.45,0.08)
	btn.Position = UDim2.fromScale(0.05,y)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",btn)
	y += 0.09

	btn.MouseButton1Click:Connect(function()
		local hum = GetHumanoid()
		if not hum then return end
		for _,tr in pairs(LoadedTracks) do tr:Stop() tr:Destroy() end
		LoadedTracks = {}
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://"..id
		local track = hum:LoadAnimation(anim)
		track:Play()
		table.insert(LoadedTracks,track)
	end)
end

--// =========================================================
--// VISUAL TAB (ESP)
--// =========================================================
local VTab = TabFrames.Visual

local ESPBtn = Instance.new("TextButton",VTab)
ESPBtn.Size = UDim2.fromScale(0.5,0.15)
ESPBtn.Position = UDim2.fromScale(0.25,0.2)
ESPBtn.Text = "Toggle ESP Name"
ESPBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
ESPBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",ESPBtn)

local function ClearESP()
	for _,v in pairs(ESP_CACHE) do v:Destroy() end
	ESP_CACHE = {}
end

ESPBtn.MouseButton1Click:Connect(function()
	ESPEnabled = not ESPEnabled
	ClearESP()
	if ESPEnabled then
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				local head = p.Character:FindFirstChild("Head")
				if head then
					local bb = Instance.new("BillboardGui",head)
					bb.Size = UDim2.fromOffset(120,30)
					bb.AlwaysOnTop = true
					local t = Instance.new("TextLabel",bb)
					t.Size = UDim2.fromScale(1,1)
					t.BackgroundTransparency = 1
					t.Text = p.Name
					t.TextColor3 = Color3.fromRGB(255,60,60)
					table.insert(ESP_CACHE,bb)
				end
			end
		end
	end
end)

--// =========================================================
--// FLY SYSTEM (FIXED)
--// =========================================================
RunService.RenderStepped:Connect(function()
	if FlyEnabled then
		local char = GetChar()
		local hrp = GetHRP(char)
		if not hrp then return end

		if not FlyBV then
			FlyBV = Instance.new("BodyVelocity",hrp)
			FlyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
			FlyBG = Instance.new("BodyGyro",hrp)
			FlyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
		end

		local cam = workspace.CurrentCamera
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += cam.CFrame.UpVector end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= cam.CFrame.UpVector end

		if dir.Magnitude > 0 then
			FlyBV.Velocity = dir.Unit * FlySpeed
		else
			FlyBV.Velocity = Vector3.zero
		end
		FlyBG.CFrame = cam.CFrame
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
