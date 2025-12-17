--// ===============================
--// 7DVI HUB | PREMIUM PANEL 2025
--// Single File Script (FIXED)
--// ===============================

--// CONFIG
local HUB_NAME = "7dvi hub"
local HUB_VERSION = "v1.2.0"
local VALID_KEY = "7dvi-2025-PREMIUM"

-- KEYBINDS (PADRÃO)
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
local AnimationsEnabled = true
local FlyEnabled = false
local SpeedEnabled = false
local ESPEnabled = false
local FlySpeed = 60
local DefaultWalkSpeed = 16
local ESP_CACHE = {}
local LoadedTracks = {}
local FlyBV, FlyBG

--// ===============================
--// UTILS
--// ===============================
local function Tween(obj,t,props)
	if not AnimationsEnabled then
		for i,v in pairs(props) do obj[i]=v end
		return
	end
	TweenService:Create(obj,TweenInfo.new(t,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props):Play()
end

local function GetChar()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoid()
	local char = GetChar()
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetHRP(char)
	return char and char:FindFirstChild("HumanoidRootPart")
end

--// ===============================
--// UI BASE
--// ===============================
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

--// BOTÃO X
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.fromOffset(36,36)
CloseBtn.Position = UDim2.new(1,-46,0,10)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",CloseBtn).CornerRadius = UDim.new(1,0)

local function ToggleMenu()
	MenuOpen = not MenuOpen
	Tween(Main,0.35,{Size = MenuOpen and UDim2.fromScale(0.4,0.52) or UDim2.fromScale(0,0)})
	Tween(Shadow,0.35,{Size = MenuOpen and UDim2.fromScale(0.42,0.56) or UDim2.fromScale(0,0)})
end

CloseBtn.MouseButton1Click:Connect(ToggleMenu)

UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == TOGGLE_MENU_KEY then
		ToggleMenu()
	elseif i.KeyCode == FLY_KEY then
		FlyEnabled = not FlyEnabled
	elseif i.KeyCode == SPEED_KEY then
		SpeedEnabled = not SpeedEnabled
		local hum = GetHumanoid()
		if hum then
			hum.WalkSpeed = SpeedEnabled and 40 or DefaultWalkSpeed
		end
	elseif i.KeyCode == ESP_KEY then
		ESPEnabled = not ESPEnabled
	end
end)

--// ===============================
--// KEY SYSTEM
--// ===============================
local KeyFrame = Instance.new("Frame",Main)
KeyFrame.Size = UDim2.fromScale(1,1)
KeyFrame.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox",KeyFrame)
KeyBox.Size = UDim2.fromScale(0.6,0.12)
KeyBox.Position = UDim2.fromScale(0.5,0.42)
KeyBox.AnchorPoint = Vector2.new(0.5,0.5)
KeyBox.PlaceholderText = "Digite a KEY"
KeyBox.Text = ""
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
		task.wait(0.5)
		KeyFrame.Visible = false
		Hub.Visible = true
	else
		KeyMsg.Text = "Key inválida!"
		KeyMsg.TextColor3 = Color3.fromRGB(255,0,0)
	end
end)

--// ===============================
--// TABS
--// ===============================
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

--// ===============================
--// MAIN TAB
--// ===============================
local MainLabel = Instance.new("TextLabel",TabFrames.Main)
MainLabel.Size = UDim2.fromScale(1,0.3)
MainLabel.BackgroundTransparency = 1
MainLabel.TextScaled = true
MainLabel.TextColor3 = Color3.new(1,1,1)
MainLabel.Text = "Bem-vindo ao "..HUB_NAME.."\n"..HUB_VERSION

--// ===============================
--// PLAYER TAB (TP + ANIMAÇÕES)
--// ===============================
local PTab = TabFrames.Player

-- TP POR NOME (LISTA AUTOMÁTICA)
local PlayerList = Instance.new("ScrollingFrame",PTab)
PlayerList.Size = UDim2.fromScale(0.6,0.4)
PlayerList.Position = UDim2.fromScale(0.2,0.05)
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
PlayerList.ScrollBarImageTransparency = 0.5
PlayerList.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner",PlayerList)

local UIList = Instance.new("UIListLayout",PlayerList)
UIList.Padding = UDim.new(0,6)

local function RefreshPlayers()
	for _,c in pairs(PlayerList:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local btn = Instance.new("TextButton",PlayerList)
			btn.Size = UDim2.new(1,-6,0,30)
			btn.Text = p.Name
			btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
			btn.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner",btn)
			btn.MouseButton1Click:Connect(function()
				pcall(function()
					local myhrp = GetHRP(GetChar())
					local thrp = GetHRP(p.Character)
					if myhrp and thrp then
						myhrp.CFrame = thrp.CFrame * CFrame.new(0,0,-3)
					end
				end)
			end)
		end
	end
	task.wait()
	PlayerList.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y+10)
end
Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)
RefreshPlayers()

--// ===============================
--// VISUAL TAB (ESP)
--// ===============================
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

--// ===============================
--// SETTINGS TAB
--// ===============================
local STab = TabFrames.Settings

local ClosePanelBtn = Instance.new("TextButton",STab)
ClosePanelBtn.Size = UDim2.fromScale(0.6,0.1)
ClosePanelBtn.Position = UDim2.fromScale(0.2,0.2)
ClosePanelBtn.Text = "Abrir / Fechar Painel (B)"
ClosePanelBtn.BackgroundColor3 = Color3.fromRGB(120,60,60)
ClosePanelBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",ClosePanelBtn)

ClosePanelBtn.MouseButton1Click:Connect(ToggleMenu)

local KeyInfo = Instance.new("TextLabel",STab)
KeyInfo.Size = UDim2.fromScale(1,0.1)
KeyInfo.Position = UDim2.fromScale(0,0.8)
KeyInfo.BackgroundTransparency = 1
KeyInfo.TextColor3 = Color3.new(1,1,1)
KeyInfo.Text = "Key ativa: "..VALID_KEY
