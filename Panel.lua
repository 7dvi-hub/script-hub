--[[ 
MEU PAINEL PREMIUM (VERSÃO ESTÁVEL)
UI Premium | Tabs | Key Online | Config Save | Debug Safe
ESP/Aim = PLACEHOLDER (não ativo)
]]

-- ================= CONFIG =================
local PANEL_NAME = "MeuPainel"
local TOGGLE_KEY = Enum.KeyCode.RightShift
local KEY_URL = "https://raw.githubusercontent.com/7dvi-hub/script-hub/main/key.txt"
local KEY_FILE = "meupainel_key.txt"
local CONFIG_FILE = "meupainel_config.json"

-- ================= SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

-- ================= UTILS =================
local function notify(msg)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "PAINEL PREMIUM",
			Text = msg,
			Duration = 3
		})
	end)
end

-- ================= CONFIG SAVE =================
local Config = {
	ESP_Skeleton = false,
	ESP_Health = false,
	ESP_Distance = false,
	Aim_FOV = 120,
	Aim_Smooth = 0.15
}

local function saveConfig()
	if writefile then
		writefile(CONFIG_FILE, HttpService:JSONEncode(Config))
	end
end

local function loadConfig()
	if isfile and isfile(CONFIG_FILE) then
		local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
		for k,v in pairs(data) do
			Config[k] = v
		end
	end
end
loadConfig()

-- ================= PROTEÇÃO =================
if game.CoreGui:FindFirstChild(PANEL_NAME) then
	game.CoreGui[PANEL_NAME]:Destroy()
end

-- ================= KEY SYSTEM =================
local function getOnlineKey()
	local ok,res = pcall(function()
		return game:HttpGet(KEY_URL)
	end)
	if ok then
		return res:gsub("%s+","")
	end
end

local function keyValid(input)
	local raw = getOnlineKey()
	if not raw then return false end
	local k = raw:match("([^|]+)")
	return input == k
end

-- ================= GUI BASE =================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = PANEL_NAME

-- ================= KEY FRAME =================
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0,320,0,180)
KeyFrame.Position = UDim2.new(0.5,-160,0.5,-90)
KeyFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
KeyFrame.Active = true
KeyFrame.Draggable = true

local KT = Instance.new("TextLabel", KeyFrame)
KT.Size = UDim2.new(1,0,0,40)
KT.BackgroundTransparency = 1
KT.Text = "KEY PREMIUM"
KT.TextColor3 = Color3.new(1,1,1)
KT.Font = Enum.Font.GothamBold
KT.TextSize = 18

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(0,240,0,36)
KeyBox.Position = UDim2.new(0.5,-120,0,60)
KeyBox.PlaceholderText = "Digite sua key"
KeyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
KeyBox.TextColor3 = Color3.new(1,1,1)

local Confirm = Instance.new("TextButton", KeyFrame)
Confirm.Size = UDim2.new(0,180,0,36)
Confirm.Position = UDim2.new(0.5,-90,0,115)
Confirm.Text = "CONFIRMAR"
Confirm.BackgroundColor3 = Color3.fromRGB(45,45,45)
Confirm.TextColor3 = Color3.new(1,1,1)

-- ================= MAIN PANEL =================
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,520,0,340)
Frame.Position = UDim2.new(0.5,-260,0.5,-170)
Frame.BackgroundColor3 = Color3.fromRGB(14,14,14)
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,44)
Title.BackgroundTransparency = 1
Title.Text = "MEU PAINEL PREMIUM"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- ================= TABS =================
local Tabs = Instance.new("Frame", Frame)
Tabs.Size = UDim2.new(0,120,1,-44)
Tabs.Position = UDim2.new(0,0,0,44)
Tabs.BackgroundColor3 = Color3.fromRGB(20,20,20)

local Pages = Instance.new("Folder", Frame)

local function newPage(name)
	local p = Instance.new("Frame")
	p.Name = name
	p.Parent = Pages
	p.Size = UDim2.new(1,-130,1,-54)
	p.Position = UDim2.new(0,130,0,54)
	p.Visible = false
	p.BackgroundTransparency = 1
	return p
end

local function newTab(text, order, page)
	local b = Instance.new("TextButton", Tabs)
	b.Size = UDim2.new(1,0,0,40)
	b.Position = UDim2.new(0,0,0,(order-1)*42)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.TextColor3 = Color3.new(1,1,1)
	b.MouseButton1Click:Connect(function()
		for _,pg in ipairs(Pages:GetChildren()) do
			pg.Visible = false
		end
		page.Visible = true
	end)
end

local Combat = newPage("Combat")
local Visuals = newPage("Visuals")
local PlayerTab = newPage("Player")

newTab("Combat",1,Combat)
newTab("Visuals",2,Visuals)
newTab("Player",3,PlayerTab)
Combat.Visible = true

-- ================= COMPONENTS =================
local function toggle(parent, text, y, cfgKey)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0,220,0,36)
	b.Position = UDim2.new(0,20,0,y)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)

	local on = Config[cfgKey]
	b.Text = text .. (on and " : ON" or " : OFF")

	b.MouseButton1Click:Connect(function()
		on = not on
		Config[cfgKey] = on
		b.Text = text .. (on and " : ON" or " : OFF")
		saveConfig()
		notify(text.." alterado")
	end)
end

-- ================= TABS CONTENT =================
toggle(PlayerTab,"Speed (placeholder)",20,"ESP_Distance")
toggle(PlayerTab,"Fly (placeholder)",70,"ESP_Health")

toggle(Combat,"Aimlock (placeholder)",20,"ESP_Skeleton")

toggle(Visuals,"ESP Skeleton",20,"ESP_Skeleton")
toggle(Visuals,"ESP Health",70,"ESP_Health")
toggle(Visuals,"ESP Distance",120,"ESP_Distance")

-- ================= TOGGLE TECLA =================
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == TOGGLE_KEY then
		Frame.Visible = not Frame.Visible
	end
end)

-- ================= KEY CHECK =================
Confirm.MouseButton1Click:Connect(function()
	if keyValid(KeyBox.Text) then
		if writefile then writefile(KEY_FILE, KeyBox.Text) end
		KeyFrame:Destroy()
		Frame.Visible = true
		notify("Key válida! Bem-vindo.")
	else
		KeyBox.Text = "KEY INVÁLIDA"
	end
end)

-- ================= AUTO LOGIN =================
if isfile and isfile(KEY_FILE) then
	if readfile(KEY_FILE) == getOnlineKey():match("([^|]+)") then
		KeyFrame:Destroy()
		Frame.Visible = true
		notify("Key carregada automaticamente")
	end
end
