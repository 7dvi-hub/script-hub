--// =========================================================
--// 7DVI HUB | ADMIN PANEL - OWN GAME ONLY
--// Single File | STABLE | CLEAN
--// =========================================================

--// CONFIG
local HUB_NAME = "7dvi hub"
local HUB_VERSION = "v1.3.0"
local VALID_KEY = "7dvi-2025-PREMIUM"

--// KEYBINDS
local TOGGLE_KEY = Enum.KeyCode.B

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local LP = Players.LocalPlayer

--// STATES
local Open = true
local ESP_ENABLED = false
local FLY = false
local SPEED = false
local NOCLIP = false
local AIMBOT = false
local SILENT = false

local FlySpeed = 60
local WalkSpeed = 16
local AimRadius = 150

--// =========================================================
--// UTILS
--// =========================================================
local function Char()
	return LP.Character or LP.CharacterAdded:Wait()
end

local function Hum()
	return Char():WaitForChild("Humanoid")
end

local function HRP(plr)
	return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
end

--// =========================================================
--// UI BASE
--// =========================================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "7DVI_HUB"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.45,0.6)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

-- SHADOW
local shadow = Instance.new("Frame", gui)
shadow.Size = main.Size
shadow.Position = main.Position
shadow.AnchorPoint = main.AnchorPoint
shadow.BackgroundColor3 = Color3.new(0,0,0)
shadow.BackgroundTransparency = 0.5
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0,18)
shadow.ZIndex = 0
main.ZIndex = 1

-- DRAG
do
	local drag, startPos, dragStart
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = true
			dragStart = i.Position
			startPos = main.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then drag = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			shadow.Position = main.Position
		end
	end)
end

-- CLOSE / MINIMIZE
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
minimize.BackgroundColor3 = Color3.fromRGB(50,50,50)
minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimize)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

minimize.MouseButton1Click:Connect(function()
	Open = not Open
	main.Visible = Open
	shadow.Visible = Open
end)

UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == TOGGLE_KEY then
		Open = not Open
		main.Visible = Open
		shadow.Visible = Open
	end
end)

--// =========================================================
--// KEY SYSTEM
--// =========================================================
local keyFrame = Instance.new("Frame", main)
keyFrame.Size = UDim2.fromScale(1,1)
keyFrame.BackgroundTransparency = 1

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.fromScale(0.6,0.1)
keyBox.Position = UDim2.fromScale(0.5,0.45)
keyBox.AnchorPoint = Vector2.new(0.5,0.5)
keyBox.PlaceholderText = "Digite a KEY"
keyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
keyBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keyBox)

local verify = Instance.new("TextButton", keyFrame)
verify.Size = UDim2.fromScale(0.3,0.08)
verify.Position = UDim2.fromScale(0.5,0.58)
verify.AnchorPoint = Vector2.new(0.5,0.5)
verify.Text = "Verificar"
verify.BackgroundColor3 = Color3.fromRGB(60,60,60)
verify.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", verify)

local hub = Instance.new("Frame", main)
hub.Size = UDim2.fromScale(1,1)
hub.Visible = false
hub.BackgroundTransparency = 1

verify.MouseButton1Click:Connect(function()
	if keyBox.Text == VALID_KEY then
		keyFrame.Visible = false
		hub.Visible = true
	end
end)

--// =========================================================
--// TABS
--// =========================================================
local tabs = {"Main","Player","Visual","Advantage","Settings"}
local frames = {}

local bar = Instance.new("Frame", hub)
bar.Size = UDim2.fromScale(1,0.12)
bar.BackgroundColor3 = Color3.fromRGB(15,15,15)

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

--// =========================================================
--// MAIN TAB (IMAGE PICKER)
--// =========================================================
local img = Instance.new("ImageLabel", frames.Main)
img.Size = UDim2.fromScale(0.5,0.5)
img.Position = UDim2.fromScale(0.25,0.2)
img.BackgroundTransparency = 1
img.Image = "rbxassetid://0"

local imgBox = Instance.new("TextBox", frames.Main)
imgBox.Size = UDim2.fromScale(0.5,0.08)
imgBox.Position = UDim2.fromScale(0.25,0.75)
imgBox.PlaceholderText = "ID da imagem"
imgBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
imgBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", imgBox)

imgBox.FocusLost:Connect(function()
	img.Image = "rbxassetid://"..imgBox.Text
end)

--// =========================================================
--// PLAYER TAB (TP + COPY CLOTHES + BUG)
--// =========================================================
local list = Instance.new("ScrollingFrame", frames.Player)
list.Size = UDim2.fromScale(0.5,0.7)
list.Position = UDim2.fromScale(0.05,0.15)
list.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UIListLayout", list)

for _,p in pairs(Players:GetPlayers()) do
	if p ~= LP then
		local b = Instance.new("TextButton", list)
		b.Size = UDim2.new(1,0,0,30)
		b.Text = p.Name
		b.BackgroundColor3 = Color3.fromRGB(50,50,50)
		b.TextColor3 = Color3.new(1,1,1)

		b.MouseButton1Click:Connect(function()
			local my = HRP(LP)
			local tg = HRP(p)
			if my and tg then my.CFrame = tg.CFrame * CFrame.new(0,0,-3) end
		end)
	end
end

-- COPY CLOTHES
local copy = Instance.new("TextButton", frames.Player)
copy.Size = UDim2.fromScale(0.35,0.08)
copy.Position = UDim2.fromScale(0.6,0.2)
copy.Text = "Copiar roupas (selecionado)"
copy.BackgroundColor3 = Color3.fromRGB(70,70,70)
copy.TextColor3 = Color3.new(1,1,1)

copy.MouseButton1Click:Connect(function()
	local target = Players:GetPlayers()[2]
	if target and target.Character then
		local desc = target.Character:WaitForChild("Humanoid"):GetAppliedDescription()
		Hum():ApplyDescription(desc)
	end
end)

-- BUG PLAYER (RAGDOLL LOCAL)
local bug = Instance.new("TextButton", frames.Player)
bug.Size = copy.Size
bug.Position = UDim2.fromScale(0.6,0.3)
bug.Text = "Bugar player (ragdoll)"
bug.BackgroundColor3 = Color3.fromRGB(100,60,60)
bug.TextColor3 = Color3.new(1,1,1)

bug.MouseButton1Click:Connect(function()
	for _,v in pairs(Char():GetDescendants()) do
		if v:IsA("Motor6D") then v:Destroy() end
	end
end)

--// =========================================================
--// VISUAL TAB (ESP NAME + LINES)
--// =========================================================
local function CreateESP(p)
	if p == LP then return end
	RunService.RenderStepped:Connect(function()
		if ESP_ENABLED and p.Character and p.Character:FindFirstChild("Head") then
			if not p.Character.Head:FindFirstChild("ESP") then
				local bb = Instance.new("BillboardGui", p.Character.Head)
				bb.Name = "ESP"
				bb.Size = UDim2.fromOffset(120,30)
				bb.AlwaysOnTop = true
				local t = Instance.new("TextLabel", bb)
				t.Size = UDim2.fromScale(1,1)
				t.BackgroundTransparency = 1
				t.Text = p.Name
				t.TextColor3 = Color3.new(1,0,0)
			end
		elseif p.Character and p.Character:FindFirstChild("Head") then
			local e = p.Character.Head:FindFirstChild("ESP")
			if e then e:Destroy() end
		end
	end)
end

for _,p in pairs(Players:GetPlayers()) do
	CreateESP(p)
end

local espBtn = Instance.new("TextButton", frames.Visual)
espBtn.Size = UDim2.fromScale(0.5,0.15)
espBtn.Position = UDim2.fromScale(0.25,0.3)
espBtn.Text = "Toggle ESP"
espBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
espBtn.TextColor3 = Color3.new(1,1,1)

espBtn.MouseButton1Click:Connect(function()
	ESP_ENABLED = not ESP_ENABLED
end)

--// =========================================================
--// ADVANTAGE TAB (FLY / SPEED / NOCLIP / AIM)
--// =========================================================
local adv = frames.Advantage

local function Toggle(text,y,callback)
	local b = Instance.new("TextButton", adv)
	b.Size = UDim2.fromScale(0.5,0.08)
	b.Position = UDim2.fromScale(0.25,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(55,55,55)
	b.TextColor3 = Color3.new(1,1,1)
	b.MouseButton1Click:Connect(callback)
end

Toggle("Fly",0.1,function() FLY = not FLY end)
Toggle("Speed",0.2,function()
	SPEED = not SPEED
	Hum().WalkSpeed = SPEED and 40 or WalkSpeed
end)
Toggle("Noclip",0.3,function() NOCLIP = not NOCLIP end)
Toggle("Aim Assist",0.4,function() AIMBOT = not AIMBOT end)
Toggle("Silent Assist",0.5,function() SILENT = not SILENT end)

RunService.Stepped:Connect(function()
	if NOCLIP then
		for _,v in pairs(Char():GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

--// =========================================================
--// FLY
--// =========================================================
RunService.RenderStepped:Connect(function()
	if FLY then
		local hrp = HRP(LP)
		if hrp then
			hrp.Velocity = Camera.CFrame.LookVector * FlySpeed
		end
	end
end)

--// =========================================================
--// END
--// =========================================================
