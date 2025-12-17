--// KSX PREMIUM HUB 2025
--// Single File Script | Ready to Use

--// ===============================
--// CONFIGURAÇÕES PRINCIPAIS
--// ===============================
local HUB_NAME = "KSX Premium Hub"
local HUB_VERSION = "v1.0.0"
local VALID_KEY = "KSX-2025-PREMIUM"
local TOGGLE_KEY = Enum.KeyCode.RightShift

--// ===============================
--// SERVIÇOS
--// ===============================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// ===============================
--// VARIÁVEIS GLOBAIS
--// ===============================
local AnimationsEnabled = true
local MenuOpen = true
local FlyEnabled = false
local SpeedEnabled = false
local ESPEnabled = false
local FlySpeed = 60
local WalkSpeedValue = 16
local ESPObjects = {}

--// ===============================
--// FUNÇÕES ÚTEIS
--// ===============================
local function Tween(obj, time, props)
	if not AnimationsEnabled then
		for i,v in pairs(props) do obj[i] = v end
		return
	end
	local tw = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
	tw:Play()
end

local function GetCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHRP(char)
	return char:FindFirstChild("HumanoidRootPart")
end

--// ===============================
--// UI BASE
--// ===============================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "KSX_HUB"

local Shadow = Instance.new("Frame", ScreenGui)
Shadow.Size = UDim2.fromScale(0.42,0.55)
Shadow.Position = UDim2.fromScale(0.5,0.5)
Shadow.AnchorPoint = Vector2.new(0.5,0.5)
Shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
Shadow.BackgroundTransparency = 0.6
Shadow.ZIndex = 0
Instance.new("UICorner", Shadow).CornerRadius = UDim.new(0,20)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.fromScale(0.4,0.5)
MainFrame.Position = UDim2.fromScale(0.5,0.5)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.ZIndex = 1
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,20)

--// ===============================
--// BOTÃO FECHAR
--// ===============================
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.fromOffset(35,35)
CloseBtn.Position = UDim2.new(1,-45,0,10)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)

CloseBtn.MouseButton1Click:Connect(function()
	MenuOpen = not MenuOpen
	Tween(MainFrame,0.4,{Size = MenuOpen and UDim2.fromScale(0.4,0.5) or UDim2.fromScale(0,0)})
	Tween(Shadow,0.4,{Size = MenuOpen and UDim2.fromScale(0.42,0.55) or UDim2.fromScale(0,0)})
end)

UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == TOGGLE_KEY then
		CloseBtn:Activate()
	end
end)

--// ===============================
--// SISTEMA DE KEY
--// ===============================
local KeyFrame = Instance.new("Frame", MainFrame)
KeyFrame.Size = UDim2.fromScale(1,1)
KeyFrame.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.fromScale(0.6,0.12)
KeyBox.Position = UDim2.fromScale(0.5,0.4)
KeyBox.AnchorPoint = Vector2.new(0.5,0.5)
KeyBox.PlaceholderText = "Digite a KEY"
KeyBox.Text = ""
KeyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
KeyBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0,10)

local VerifyBtn = Instance.new("TextButton", KeyFrame)
VerifyBtn.Size = UDim2.fromScale(0.3,0.1)
VerifyBtn.Position = UDim2.fromScale(0.5,0.55)
VerifyBtn.AnchorPoint = Vector2.new(0.5,0.5)
VerifyBtn.Text = "Verificar Key"
VerifyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
VerifyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0,10)

local KeyMsg = Instance.new("TextLabel", KeyFrame)
KeyMsg.Size = UDim2.fromScale(1,0.1)
KeyMsg.Position = UDim2.fromScale(0,0.7)
KeyMsg.Text = ""
KeyMsg.BackgroundTransparency = 1
KeyMsg.TextColor3 = Color3.new(1,0,0)

--// ===============================
--// CONTAINER HUB
--// ===============================
local HubFrame = Instance.new("Frame", MainFrame)
HubFrame.Size = UDim2.fromScale(1,1)
HubFrame.Visible = false
HubFrame.BackgroundTransparency = 1

VerifyBtn.MouseButton1Click:Connect(function()
	if KeyBox.Text == VALID_KEY then
		KeyMsg.Text = "Key válida! Bem-vindo."
		KeyMsg.TextColor3 = Color3.fromRGB(0,255,0)
		wait(0.8)
		KeyFrame.Visible = false
		HubFrame.Visible = true
	else
		KeyMsg.Text = "Key inválida!"
		KeyMsg.TextColor3 = Color3.fromRGB(255,0,0)
	end
end)

--// ===============================
--// SISTEMA DE ABAS
--// ===============================
local Tabs = {"Main","Player","Visual","Settings"}
local TabButtons = {}
local TabFrames = {}

local TabBar = Instance.new("Frame", HubFrame)
TabBar.Size = UDim2.fromScale(1,0.12)
TabBar.BackgroundColor3 = Color3.fromRGB(20,20,20)

local Content = Instance.new("Frame", HubFrame)
Content.Size = UDim2.fromScale(1,0.88)
Content.Position = UDim2.fromScale(0,0.12)
Content.BackgroundTransparency = 1

for i,name in ipairs(Tabs) do
	local btn = Instance.new("TextButton", TabBar)
	btn.Size = UDim2.fromScale(1/#Tabs,1)
	btn.Position = UDim2.fromScale((i-1)/#Tabs,0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.TextColor3 = Color3.new(1,1,1)
	TabButtons[name] = btn

	local frame = Instance.new("Frame", Content)
	frame.Size = UDim2.fromScale(1,1)
	frame.Visible = false
	frame.BackgroundTransparency = 1
	TabFrames[name] = frame

	btn.MouseButton1Click:Connect(function()
		for _,f in pairs(TabFrames) do f.Visible = false end
		frame.Visible = true
	end)
end
TabFrames["Main"].Visible = true

--// ===============================
--// ABA MAIN
--// ===============================
local MainLabel = Instance.new("TextLabel", TabFrames["Main"])
MainLabel.Size = UDim2.fromScale(1,0.3)
MainLabel.Text = "Bem-vindo ao "..HUB_NAME.."\n"..HUB_VERSION
MainLabel.BackgroundTransparency = 1
MainLabel.TextColor3 = Color3.new(1,1,1)
MainLabel.TextScaled = true

--// ===============================
--// ABA PLAYER (TP / FLY / SPEED)
--// ===============================
local PlayerFrame = TabFrames["Player"]

-- Dropdown simples
local PlayerList = Instance.new("TextBox", PlayerFrame)
PlayerList.PlaceholderText = "Nome do Player"
PlayerList.Size = UDim2.fromScale(0.6,0.1)
PlayerList.Position = UDim2.fromScale(0.2,0.1)
PlayerList.BackgroundColor3 = Color3.fromRGB(35,35,35)
PlayerList.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", PlayerList)

local TPBtn = Instance.new("TextButton", PlayerFrame)
TPBtn.Text = "Teleportar"
TPBtn.Size = UDim2.fromScale(0.3,0.1)
TPBtn.Position = UDim2.fromScale(0.35,0.22)
TPBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
TPBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", TPBtn)

TPBtn.MouseButton1Click:Connect(function()
	pcall(function()
		local target = Players:FindFirstChild(PlayerList.Text)
		if target and target.Character and GetHRP(target.Character) then
			GetHRP(GetCharacter()).CFrame = GetHRP(target.Character).CFrame * CFrame.new(0,0,-3)
		end
	end)
end)

-- Fly
local FlyBtn = Instance.new("TextButton", PlayerFrame)
FlyBtn.Text = "Toggle Fly"
FlyBtn.Size = UDim2.fromScale(0.4,0.1)
FlyBtn.Position = UDim2.fromScale(0.3,0.38)
FlyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
FlyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", FlyBtn)

local bv, bg
FlyBtn.MouseButton1Click:Connect(function()
	FlyEnabled = not FlyEnabled
	local char = GetCharacter()
	local hrp = GetHRP(char)
	if FlyEnabled then
		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bg = Instance.new("BodyGyro", hrp)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

RunService.RenderStepped:Connect(function()
	if FlyEnabled and bv and bg then
		local cam = workspace.CurrentCamera
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		bv.Velocity = dir * FlySpeed
		bg.CFrame = cam.CFrame
	end
end)

-- Speed
local SpeedBtn = Instance.new("TextButton", PlayerFrame)
SpeedBtn.Text = "Toggle Speed"
SpeedBtn.Size = UDim2.fromScale(0.4,0.1)
SpeedBtn.Position = UDim2.fromScale(0.3,0.52)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
SpeedBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", SpeedBtn)

SpeedBtn.MouseButton1Click:Connect(function()
	SpeedEnabled = not SpeedEnabled
	local hum = GetCharacter():FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = SpeedEnabled and 40 or 16
	end
end)

--// ===============================
--// ABA VISUAL (ESP)
--// ===============================
local VisualFrame = TabFrames["Visual"]

local ESPBtn = Instance.new("TextButton", VisualFrame)
ESPBtn.Text = "Toggle ESP Name"
ESPBtn.Size = UDim2.fromScale(0.5,0.15)
ESPBtn.Position = UDim2.fromScale(0.25,0.2)
ESPBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
ESPBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ESPBtn)

local function ClearESP()
	for _,v in pairs(ESPObjects) do v:Destroy() end
	ESPObjects = {}
end

ESPBtn.MouseButton1Click:Connect(function()
	ESPEnabled = not ESPEnabled
	ClearESP()
	if ESPEnabled then
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then
				pcall(function()
					local bill = Instance.new("BillboardGui", p.Character:WaitForChild("Head"))
					bill.Size = UDim2.fromOffset(100,30)
					bill.AlwaysOnTop = true
					local txt = Instance.new("TextLabel", bill)
					txt.Size = UDim2.fromScale(1,1)
					txt.BackgroundTransparency = 1
					txt.Text = p.Name
					txt.TextColor3 = Color3.new(1,0,0)
					table.insert(ESPObjects,bill)
				end)
			end
		end
	end
end)

--// ===============================
--// ABA SETTINGS
--// ===============================
local SettingsFrame = TabFrames["Settings"]

local DestroyBtn = Instance.new("TextButton", SettingsFrame)
DestroyBtn.Text = "Destruir UI"
DestroyBtn.Size = UDim2.fromScale(0.5,0.15)
DestroyBtn.Position = UDim2.fromScale(0.25,0.2)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
DestroyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", DestroyBtn)

DestroyBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local AnimBtn = Instance.new("TextButton", SettingsFrame)
AnimBtn.Text = "Toggle Animações"
AnimBtn.Size = UDim2.fromScale(0.5,0.15)
AnimBtn.Position = UDim2.fromScale(0.25,0.4)
AnimBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
AnimBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", AnimBtn)

AnimBtn.MouseButton1Click:Connect(function()
	AnimationsEnabled = not AnimationsEnabled
end)

local KeyInfo = Instance.new("TextLabel", SettingsFrame)
KeyInfo.Text = "Key ativa: "..VALID_KEY
KeyInfo.Size = UDim2.fromScale(1,0.15)
KeyInfo.Position = UDim2.fromScale(0,0.65)
KeyInfo.BackgroundTransparency = 1
KeyInfo.TextColor3 = Color3.new(1,1,1)
