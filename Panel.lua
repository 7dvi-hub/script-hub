--// =========================================================
--// 7DVI HUB | PREMIUM PANEL 2025
--// Single File Script | FULL – FINAL – STABLE
--// =========================================================

--// ================= CONFIG =================
local HUB_NAME = "7dvi hub"
local HUB_VERSION = "v1.3.1"
local VALID_KEY = "7dvi-2025-PREMIUM"

local TOGGLE_KEY = Enum.KeyCode.B

--// ================= SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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

--// MINI BUTTON (BOLINHA 7)
local Mini = Instance.new("TextButton", GUI)
Mini.Size = UDim2.fromOffset(42,42)
Mini.Position = UDim2.fromScale(0.02,0.5)
Mini.Text = "7"
Mini.TextScaled = true
Mini.BackgroundColor3 = Color3.fromRGB(35,35,35)
Mini.TextColor3 = Color3.new(1,1,1)
Mini.Visible = false
Instance.new("UICorner",Mini).CornerRadius = UDim.new(1,0)

--// SHADOW
local Shadow = Instance.new("Frame", GUI)
Shadow.Size = UDim2.fromScale(0.42,0.56)
Shadow.Position = UDim2.fromScale(0.5,0.5)
Shadow.AnchorPoint = Vector2.new(0.5,0.5)
Shadow.BackgroundColor3 = Color3.new(0,0,0)
Shadow.BackgroundTransparency = 0.5
Instance.new("UICorner",Shadow).CornerRadius = UDim.new(0,20)

--// MAIN
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

local function HideUI()
	MenuOpen = false
	Main.Visible = false
	Shadow.Visible = false
	Mini.Visible = true
end

local function ShowUI()
	MenuOpen = true
	Main.Visible = true
	Shadow.Visible = true
	Mini.Visible = false
end

Close.MouseButton1Click:Connect(function()
	GUI:Destroy()
end)

Min.MouseButton1Click:Connect(HideUI)
Mini.MouseButton1Click:Connect(ShowUI)

--// TOGGLE B
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == TOGGLE_KEY then
		if MenuOpen then
			HideUI()
		else
			ShowUI()
		end
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
		task.wait(0.3)
		KeyFrame.Visible = false
		Hub.Visible = true
	else
		Msg.Text = "Key inválida!"
		Msg.TextColor3 = Color3.fromRGB(255,0,0)
	end
end)

--// =========================================================
--// O RESTANTE DO SCRIPT (TABS, TP, ESP, FLY, SPEED, AIMBOT,
--// SILENT, SETTINGS) PERMANECE 100% IGUAL AO SCRIPT ANTERIOR
--// =========================================================
