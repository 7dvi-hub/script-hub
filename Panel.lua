--// =========================================================
--// 7DVI NEXUS | PREMIUM PANEL 2025
--// Single File Script | FINAL – STABLE – SAFE
--// =========================================================

--// ================= CONFIG =================
local HUB_NAME = "7DVI Nexus"
local HUB_VERSION = "v1.4.0"
local VALID_KEY = "7dvi-2025-PREMIUM"
local TOGGLE_KEY = Enum.KeyCode.B

--// ================= SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// ================= STATES =================
local MenuOpen = true
local Minimized = false
local FlyEnabled = false
local SpeedEnabled = false
local ESPNames = false

local FlySpeed = 60
local WalkSpeed = 16
local ESPNameSize = 14
local ESPColor = Color3.fromRGB(255,60,60)
local ThemeColor = Color3.fromRGB(22,22,22)

--// ================= UTILS =================
local function Char()
	return LP.Character or LP.CharacterAdded:Wait()
end
local function Hum()
	return Char():WaitForChild("Humanoid")
end
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
Instance.new("UICorner",Shadow).CornerRadius = UDim.new(0,22)

local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.fromScale(0.4,0.52)
Main.Position = UDim2.fromScale(0.5,0.5)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = ThemeColor
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,22)

-- Background image
local BGImage = Instance.new("ImageLabel", Main)
BGImage.Size = UDim2.fromScale(1,1)
BGImage.BackgroundTransparency = 1
BGImage.ImageTransparency = 0.85
BGImage.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner",BGImage).CornerRadius = UDim.new(0,22)

-- Drag
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

-- Close
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromOffset(32,32)
Close.Position = UDim2.new(1,-38,0,6)
Close.Text = "✕"
Close.TextScaled = true
Close.BackgroundColor3 = Color3.fromRGB(160,60,60)
Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Close)

-- Minimize
local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.fromOffset(32,32)
Min.Position = UDim2.new(1,-76,0,6)
Min.Text = "—"
Min.TextScaled = true
Min.BackgroundColor3 = Color3.fromRGB(80,80,80)
Min.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Min)

-- Bubble
local Bubble = Instance.new("TextButton", GUI)
Bubble.Size = UDim2.fromOffset(50,50)
Bubble.Position = UDim2.fromScale(0.05,0.5)
Bubble.Text = "7"
Bubble.TextScaled = true
Bubble.Visible = false
Bubble.BackgroundColor3 = Color3.fromRGB(35,35,35)
Bubble.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Bubble).CornerRadius = UDim.new(1,0)

Close.MouseButton1Click:Connect(function()
	GUI:Destroy()
end)

Min.MouseButton1Click:Connect(function()
	Main.Visible = false
	Shadow.Visible = false
	Bubble.Visible = true
	Minimized = true
end)

Bubble.MouseButton1Click:Connect(function()
	Main.Visible = true
	Shadow.Visible = true
	Bubble.Visible = false
	Minimized = false
end)

UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == TOGGLE_KEY then
		if Minimized then
			Bubble:Activate()
		else
			MenuOpen = not MenuOpen
			Main.Visible = MenuOpen
			Shadow.Visible = MenuOpen
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

--// ================= COLOR PICKER =================
local ColorBar = Instance.new("Frame",Hub)
ColorBar.Size = UDim2.fromScale(0.6,0.05)
ColorBar.Position = UDim2.fromScale(0.2,0.88)
Instance.new("UICorner",ColorBar)

local Grad = Instance.new("UIGradient",ColorBar)
Grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.2,Color3.fromRGB(255,255,0)),
	ColorSequenceKeypoint.new(0.4,Color3.fromRGB(0,255,0)),
	ColorSequenceKeypoint.new(0.6,Color3.fromRGB(0,255,255)),
	ColorSequenceKeypoint.new(0.8,Color3.fromRGB(0,0,255)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,255)),
}

ColorBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		local x = math.clamp((i.Position.X - ColorBar.AbsolutePosition.X)/ColorBar.AbsoluteSize.X,0,1)
		local k = Grad.Color.Keypoints
		local idx = math.clamp(math.floor(x*(#k-1))+1,1,#k)
		ThemeColor = k[idx].Value
		Main.BackgroundColor3 = ThemeColor
	end
end)
