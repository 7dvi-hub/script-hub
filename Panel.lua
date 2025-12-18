--// =========================================================
--// 7DVI HUB | PREMIUM PANEL 2025
--// Single File | FINAL | STABLE | CLIENT
--// =========================================================

--// ================= CONFIG =================
local HUB_NAME = "7DVI HUB"
local HUB_VERSION = "v1.0.0"
local VALID_KEY = "7dvi-2025-PREMIUM"
local TOGGLE_KEY = Enum.KeyCode.B

--// ================= SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// ================= STATES =================
local Open = true
local Minimized = false
local Fly = false
local SpeedOn = false
local ESPNames = false
local ESPLines = false

local FlySpeed = 60
local WalkSpeed = 40

--// ================= UTILS =================
local function Char()
	return LP.Character or LP.CharacterAdded:Wait()
end

local function Hum()
	return Char():WaitForChild("Humanoid")
end

local function HRP(p)
	return p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end

--// ================= UI BASE =================
local GUI = Instance.new("ScreenGui", game.CoreGui)
GUI.ResetOnSpawn = false

local Shadow = Instance.new("Frame", GUI)
Shadow.Size = UDim2.fromScale(0.42,0.55)
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

-- Drag
do
	local drag, start, pos
	Main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = true
			start = i.Position
			pos = Main.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then drag = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - start
			Main.Position = UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
			Shadow.Position = Main.Position
		end
	end)
end

-- Close / Minimize
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.fromOffset(30,30)
Close.Position = UDim2.new(1,-36,0,6)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(150,60,60)
Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Close)

local Min = Close:Clone()
Min.Parent = Main
Min.Position = UDim2.new(1,-72,0,6)
Min.Text = "-"

local Bubble = Instance.new("TextButton", GUI)
Bubble.Size = UDim2.fromOffset(50,50)
Bubble.Position = UDim2.fromScale(0.05,0.5)
Bubble.Text = "7"
Bubble.Visible = false
Bubble.TextScaled = true
Bubble.BackgroundColor3 = Color3.fromRGB(30,30,30)
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
			Open = not Open
			Main.Visible = Open
			Shadow.Visible = Open
		end
	end
end)

--// ================= KEY =================
local KeyFrame = Instance.new("Frame",Main)
KeyFrame.Size = UDim2.fromScale(1,1)
KeyFrame.BackgroundTransparency = 1

local Box = Instance.new("TextBox",KeyFrame)
Box.Size = UDim2.fromScale(0.6,0.12)
Box.Position = UDim2.fromScale(0.5,0.45)
Box.AnchorPoint = Vector2.new(0.5,0.5)
Box.PlaceholderText = "Digite a KEY"
Box.BackgroundColor3 = Color3.fromRGB(35,35,35)
Box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Box)

local Btn = Instance.new("TextButton",KeyFrame)
Btn.Size = UDim2.fromScale(0.3,0.1)
Btn.Position = UDim2.fromScale(0.5,0.6)
Btn.AnchorPoint = Vector2.new(0.5,0.5)
Btn.Text = "Verificar"
Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",Btn)

local Msg = Instance.new("TextLabel",KeyFrame)
Msg.Size = UDim2.fromScale(1,0.1)
Msg.Position = UDim2.fromScale(0,0.72)
Msg.BackgroundTransparency = 1
Msg.TextColor3 = Color3.new(1,1,1)

local Hub = Instance.new("Frame",Main)
Hub.Size = UDim2.fromScale(1,1)
Hub.Visible = false
Hub.BackgroundTransparency = 1

Btn.MouseButton1Click:Connect(function()
	if Box.Text == VALID_KEY then
		KeyFrame.Visible = false
		Hub.Visible = true
	else
		Msg.Text = "Key inválida"
	end
end)

--// ================= TABS =================
local Tabs = {"Main","TP","Visual","Movement"}
local Frames = {}

local TabBar = Instance.new("Frame",Hub)
TabBar.Size = UDim2.fromScale(1,0.12)
TabBar.BackgroundColor3 = Color3.fromRGB(18,18,18)

local Content = Instance.new("Frame",Hub)
Content.Size = UDim2.fromScale(1,0.88)
Content.Position = UDim2.fromScale(0,0.12)
Content.BackgroundTransparency = 1

for i,n in ipairs(Tabs) do
	local b = Instance.new("TextButton",TabBar)
	b.Size = UDim2.fromScale(1/#Tabs,1)
	b.Position = UDim2.fromScale((i-1)/#Tabs,0)
	b.Text = n
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.new(1,1,1)

	local f = Instance.new("Frame",Content)
	f.Size = UDim2.fromScale(1,1)
	f.Visible = false
	f.BackgroundTransparency = 1
	Frames[n] = f

	b.MouseButton1Click:Connect(function()
		for _,v in pairs(Frames) do v.Visible=false end
		f.Visible=true
	end)
end
Frames.Main.Visible = true

--// ================= MAIN =================
local L = Instance.new("TextLabel",Frames.Main)
L.Size = UDim2.fromScale(1,0.3)
L.BackgroundTransparency = 1
L.TextScaled = true
L.TextColor3 = Color3.new(1,1,1)
L.Text = HUB_NAME.." | "..HUB_VERSION

--// ================= TP =================
local Scroll = Instance.new("ScrollingFrame",Frames.TP)
Scroll.Size = UDim2.fromScale(0.6,0.75)
Scroll.Position = UDim2.fromScale(0.2,0.12)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner",Scroll)

local Layout = Instance.new("UIListLayout",Scroll)
Layout.Padding = UDim.new(0,6)

local function RefreshTP()
	for _,c in pairs(Scroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LP then
			local b = Instance.new("TextButton",Scroll)
			b.Size = UDim2.new(1,-10,0,32)
			b.Text = p.Name
			b.BackgroundColor3 = Color3.fromRGB(50,50,50)
			b.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner",b)
			b.MouseButton1Click:Connect(function()
				if HRP(LP) and HRP(p) then
					HRP(LP).CFrame = HRP(p).CFrame * CFrame.new(0,0,-3)
				end
			end)
		end
	end
	task.wait()
	Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+10)
end
Players.PlayerAdded:Connect(RefreshTP)
Players.PlayerRemoving:Connect(RefreshTP)
RefreshTP()

--// ================= VISUAL =================
local ESPBtn = Instance.new("TextButton",Frames.Visual)
ESPBtn.Size = UDim2.fromScale(0.5,0.12)
ESPBtn.Position = UDim2.fromScale(0.25,0.2)
ESPBtn.Text = "ESP Nomes"
ESPBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
ESPBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",ESPBtn)

ESPBtn.MouseButton1Click:Connect(function()
	ESPNames = not ESPNames
end)

RS.RenderStepped:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LP and p.Character and p.Character:FindFirstChild("Head") then
			if ESPNames then
				if not p.Character.Head:FindFirstChild("ESP") then
					local bb = Instance.new("BillboardGui",p.Character.Head)
					bb.Name="ESP"
					bb.Size=UDim2.fromOffset(120,30)
					bb.AlwaysOnTop=true
					local t=Instance.new("TextLabel",bb)
					t.Size=UDim2.fromScale(1,1)
					t.BackgroundTransparency=1
					t.Text=p.Name
					t.TextColor3=Color3.fromRGB(255,60,60)
				end
			else
				if p.Character.Head:FindFirstChild("ESP") then
					p.Character.Head.ESP:Destroy()
				end
			end
		end
	end
end)

--// ================= MOVEMENT =================
local FlyBtn = Instance.new("TextButton",Frames.Movement)
FlyBtn.Size = UDim2.fromScale(0.5,0.12)
FlyBtn.Position = UDim2.fromScale(0.25,0.2)
FlyBtn.Text="Fly"
FlyBtn.BackgroundColor3=Color3.fromRGB(60,60,60)
FlyBtn.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",FlyBtn)

FlyBtn.MouseButton1Click:Connect(function()
	Fly = not Fly
end)

local SpeedBtn = FlyBtn:Clone()
SpeedBtn.Parent=Frames.Movement
SpeedBtn.Position=UDim2.fromScale(0.25,0.36)
SpeedBtn.Text="WalkSpeed"

SpeedBtn.MouseButton1Click:Connect(function()
	SpeedOn = not SpeedOn
	Hum().WalkSpeed = SpeedOn and WalkSpeed or 16
end)

local BV,BG
RS.RenderStepped:Connect(function()
	if Fly and HRP(LP) then
		if not BV then
			BV=Instance.new("BodyVelocity",HRP(LP))
			BV.MaxForce=Vector3.new(1e5,1e5,1e5)
			BG=Instance.new("BodyGyro",HRP(LP))
			BG.MaxTorque=Vector3.new(1e5,1e5,1e5)
		end
		local d=Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then d+=Camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then d-=Camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then d-=Camera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then d+=Camera.CFrame.RightVector end
		BV.Velocity=d.Magnitude>0 and d.Unit*FlySpeed or Vector3.zero
		BG.CFrame=Camera.CFrame
	else
		if BV then BV:Destroy() BV=nil end
		if BG then BG:Destroy() BG=nil end
	end
end)
