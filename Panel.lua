--// =====================================================
--// 7DVI HUB | PREMIUM PANEL 2025
--// SINGLE FILE | FULL FIX | STABLE
--// =====================================================

--// CONFIG
local HUB_NAME = "7dvi hub"
local HUB_VERSION = "v1.4.0"
local VALID_KEY = "7dvi-2025-PREMIUM"

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// STATES
local OPEN = true
local FLY = false
local SPEED = false
local FlySpeed = 60
local WalkSpeed = 16

local ESP_NAME = false
local ESP_LINE = false
local ESP_SIZE = 14
local ESP_COLOR = Color3.fromRGB(255,60,60)
local ESP_CACHE = {}

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

local shadow = Instance.new("Frame", gui)
shadow.Size = UDim2.fromScale(0.45,0.6)
shadow.Position = UDim2.fromScale(0.5,0.5)
shadow.AnchorPoint = Vector2.new(0.5,0.5)
shadow.BackgroundColor3 = Color3.new(0,0,0)
shadow.BackgroundTransparency = 0.45
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0,18)

local main = Instance.new("Frame", gui)
main.Size = shadow.Size
main.Position = shadow.Position
main.AnchorPoint = shadow.AnchorPoint
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

--// DRAG
do
	local dragging, startPos, startInput
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startInput = i.Position
			startPos = main.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - startInput
			main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
			shadow.Position = main.Position
		end
	end)
end

--// BUTTONS
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

--// KEY SYSTEM
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
verify.Position = UDim2.fromScale(0.5,0.57)
verify.AnchorPoint = Vector2.new(0.5,0.5)
verify.Text = "Verificar"
verify.BackgroundColor3 = Color3.fromRGB(60,60,60)
verify.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", verify)

local keyMsg = Instance.new("TextLabel", keyFrame)
keyMsg.Size = UDim2.fromScale(1,0.1)
keyMsg.Position = UDim2.fromScale(0,0.65)
keyMsg.BackgroundTransparency = 1
keyMsg.TextColor3 = Color3.new(1,1,1)

--// HUB
local hub = Instance.new("Frame", main)
hub.Size = UDim2.fromScale(1,1)
hub.BackgroundTransparency = 1
hub.Visible = false

verify.MouseButton1Click:Connect(function()
	if keyBox.Text == VALID_KEY then
		keyFrame.Visible = false
		hub.Visible = true
	else
		keyMsg.Text = "KEY INVÁLIDA"
		keyMsg.TextColor3 = Color3.fromRGB(255,60,60)
	end
end)

--// TABS
local tabs = {"Main","TP","Visual","Advanced"}
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

--// MAIN TAB
local img = Instance.new("ImageLabel", frames.Main)
img.Size = UDim2.fromScale(0.4,0.4)
img.Position = UDim2.fromScale(0.3,0.1)
img.BackgroundTransparency = 1

local imgBox = Instance.new("TextBox", frames.Main)
imgBox.Size = UDim2.fromScale(0.5,0.07)
imgBox.Position = UDim2.fromScale(0.25,0.55)
imgBox.PlaceholderText = "Cole URL ou AssetId da imagem"
imgBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
imgBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", imgBox)

local applyImg = Instance.new("TextButton", frames.Main)
applyImg.Size = UDim2.fromScale(0.3,0.07)
applyImg.Position = UDim2.fromScale(0.35,0.65)
applyImg.Text = "Atualizar Imagem"
applyImg.BackgroundColor3 = Color3.fromRGB(70,70,70)
applyImg.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", applyImg)

applyImg.MouseButton1Click:Connect(function()
	if imgBox.Text ~= "" then
		if imgBox.Text:find("rbxassetid://") or tonumber(imgBox.Text) then
			img.Image = "rbxassetid://"..imgBox.Text:gsub("%D","")
		elseif imgBox.Text:find("http") and getcustomasset then
			local data = game:HttpGet(imgBox.Text)
			local file = "7dvi_img.png"
			writefile(file,data)
			img.Image = getcustomasset(file)
		end
	end
end)

-- COLOR NUI
local rBox = Instance.new("TextBox", frames.Main)
rBox.Size = UDim2.fromScale(0.15,0.06)
rBox.Position = UDim2.fromScale(0.25,0.75)
rBox.PlaceholderText = "R"
local gBox = rBox:Clone(); gBox.Parent = frames.Main; gBox.Position = UDim2.fromScale(0.42,0.75); gBox.PlaceholderText="G"
local bBox = rBox:Clone(); bBox.Parent = frames.Main; bBox.Position = UDim2.fromScale(0.59,0.75); bBox.PlaceholderText="B"
for _,bx in pairs({rBox,gBox,bBox}) do
	bx.BackgroundColor3 = Color3.fromRGB(35,35,35)
	bx.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", bx)
end

local applyColor = Instance.new("TextButton", frames.Main)
applyColor.Size = UDim2.fromScale(0.3,0.06)
applyColor.Position = UDim2.fromScale(0.35,0.83)
applyColor.Text = "Aplicar Cor UI"
applyColor.BackgroundColor3 = Color3.fromRGB(70,70,70)
applyColor.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", applyColor)

applyColor.MouseButton1Click:Connect(function()
	local r = tonumber(rBox.Text)
	local g = tonumber(gBox.Text)
	local b = tonumber(bBox.Text)
	if r and g and b then
		main.BackgroundColor3 = Color3.fromRGB(r,g,b)
	end
end)

--// VISUAL TAB (ESP)
local function ClearESP()
	for _,v in pairs(ESP_CACHE) do v:Destroy() end
	ESP_CACHE = {}
end

RunService.RenderStepped:Connect(function()
	ClearESP()
	if ESP_NAME or ESP_LINE then
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
				local head = p.Character.Head
				if ESP_NAME then
					local bb = Instance.new("BillboardGui", head)
					bb.Size = UDim2.fromOffset(200,40)
					bb.AlwaysOnTop = true
					local t = Instance.new("TextLabel", bb)
					t.Size = UDim2.fromScale(1,1)
					t.BackgroundTransparency = 1
					t.Text = p.Name
					t.TextSize = ESP_SIZE
					t.TextColor3 = ESP_COLOR
					table.insert(ESP_CACHE, bb)
				end
				if ESP_LINE and HRP(p) then
					local beam = Instance.new("Beam")
					local a0 = Instance.new("Attachment", HRP(LP))
					local a1 = Instance.new("Attachment", HRP(p))
					beam.Attachment0 = a0
					beam.Attachment1 = a1
					beam.Color = ColorSequence.new(ESP_COLOR)
					beam.Width0 = 0.1
					beam.Width1 = 0.1
					beam.Parent = HRP(LP)
					table.insert(ESP_CACHE, beam)
				end
			end
		end
	end
end)

local function ToggleBtn(parent,text,y,callback)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.fromScale(0.4,0.08)
	b.Position = UDim2.fromScale(0.3,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(callback)
end

ToggleBtn(frames.Visual,"ESP NAMES",0.15,function() ESP_NAME = not ESP_NAME end)
ToggleBtn(frames.Visual,"ESP LINES",0.27,function() ESP_LINE = not ESP_LINE end)

local sizeBox = Instance.new("TextBox", frames.Visual)
sizeBox.Size = UDim2.fromScale(0.3,0.06)
sizeBox.Position = UDim2.fromScale(0.35,0.4)
sizeBox.PlaceholderText = "Tamanho Nome"
sizeBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
sizeBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", sizeBox)

sizeBox.FocusLost:Connect(function()
	local v = tonumber(sizeBox.Text)
	if v then ESP_SIZE = math.clamp(v,10,40) end
end)

--// ADVANCED (FLY + SPEED)
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

UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.F then FLY = not FLY end
	if i.KeyCode == Enum.KeyCode.G then
		SPEED = not SPEED
		Hum().WalkSpeed = SPEED and WalkSpeed or 16
	end
end)
