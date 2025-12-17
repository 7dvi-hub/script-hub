--[[
MEU PAINEL PREMIUM ULTIMATE
ESP Completo | Aimlock Real | Tabs | HWID Lock | Key por Tempo | Dark Premium UI
AVISO: Recursos dependem do executor (Drawing / writefile / readfile / gethwid)
]]

-- ================= CONFIG =================
local CONFIG_FILE = "meupainel_config.json"

local Config = {
    ESP_Skeleton = false,
    ESP_Health = false,
    ESP_Distance = false,
    Aim_FOV = 120,
    Aim_Smooth = 0.15
}

local HttpService = game:GetService("HttpService")

local function saveConfig()
    if writefile then
        writefile(CONFIG_FILE, HttpService:JSONEncode(Config))
    end
end

local function loadConfig()
    if isfile and isfile(CONFIG_FILE) then
        local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
        for i,v in pairs(data) do
            Config[i] = v
        end
    end
end

loadConfig()

-- ================= UTILS =================
local function notify(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title="PAINEL PREMIUM", Text=msg, Duration=3})
    end)
end

local function getHWID()
    if typeof(gethwid) == "function" then
        return tostring(gethwid())
    end
    return tostring(Player.UserId) -- fallback
end

-- ================= PROTEÇÃO =================
if game.CoreGui:FindFirstChild(PANEL_NAME) then
    game.CoreGui[PANEL_NAME]:Destroy()
end

-- ================= KEY ONLINE (TEMPO + HWID) =================
-- Formato do key.txt: 7dvi
-- KEY|EXPIRY_UNIX|HWID (HWID opcional, use * para liberar)
-- Ex: ABC-123|1893456000|*
local function parseKey(raw)
    local k,e,h = raw:match("([^|]+)|([^|]+)|?(.*)")
    return k, tonumber(e), h
end

local function getOnlineKey()
    local ok,res = pcall(function() return game:HttpGet(KEY_URL) end)
    if not ok then return end
    return res:gsub("%s+","")
end

local function keyValid(input)
    local raw = getOnlineKey()
    if not raw then return false,"Sem conexão" end
    local k,exp,hw = parseKey(raw)
    if input ~= k then return false,"Key inválida" end
    if exp and os.time() > exp then return false,"Key expirada" end
    if hw and hw ~= "" and hw ~= "*" and hw ~= getHWID() then return false,"HWID inválido" end
    return true
end

-- ================= GUI BASE =================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = PANEL_NAME

-- ================= KEY FRAME =================
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0,340,0,190)
KeyFrame.Position = UDim2.new(0.5,-170,0.5,-95)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
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
KeyBox.Size = UDim2.new(0,260,0,38)
KeyBox.Position = UDim2.new(0.5,-130,0,70)
KeyBox.PlaceholderText = "Digite sua key"
KeyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
KeyBox.TextColor3 = Color3.new(1,1,1)

local Confirm = Instance.new("TextButton", KeyFrame)
Confirm.Size = UDim2.new(0,200,0,38)
Confirm.Position = UDim2.new(0.5,-100,0,125)
Confirm.Text = "CONFIRMAR"
Confirm.BackgroundColor3 = Color3.fromRGB(45,45,45)
Confirm.TextColor3 = Color3.new(1,1,1)

-- ================= MAIN PANEL =================
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,520,0,360)
Frame.Position = UDim2.new(0.5,-260,0.55,-180)
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
Tabs.BackgroundColor3 = Color3.fromRGB(18,18,18)

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
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function()
        for _,pg in ipairs(Pages:GetChildren()) do pg.Visible=false end
        page.Visible=true
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
local function toggle(parent, text, y, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,220,0,36)
    b.Position = UDim2.new(0,20,0,y)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    local on=false
    b.Text=text.." : OFF"
    b.MouseButton1Click:Connect(function()
        on=not on; b.Text=text..(on and " : ON" or " : OFF"); cb(on)
    end)
end

-- ================= PLAYER =================
local Humanoid
local function bindChar()
    local c = Player.Character or Player.CharacterAdded:Wait()
    Humanoid = c:WaitForChild("Humanoid")
end
bindChar()
Player.CharacterAdded:Connect(bindChar)

toggle(PlayerTab,"Speed",20,function(v) Humanoid.WalkSpeed = v and 50 or 16 end)

local flying=false
toggle(PlayerTab,"Fly",70,function(v) flying=v end)
RunService.RenderStepped:Connect(function()
    if flying and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.Velocity = Vector3.new(0,45,0)
    end
end)

-- ================= AIMLOCK REAL =================
local aim=false
local function closestToMouse()
    local closest,dist
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=Player and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos,vis = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if vis then
                local d = (Vector2.new(pos.X,pos.Y)-UIS:GetMouseLocation()).Magnitude
                if not dist or d<dist then dist=d; closest=plr end
            end
        end
    end
    return closest
end

toggle(Combat,"Aimlock",20,function(v) aim=v end)
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.UserInputType==AIM_KEY and aim then
        local t = closestToMouse()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end
end)

-- ================= ESP COMPLETO =================
local function drawLine(a,b,color)
    local l = Drawing.new("Line")
    l.From = a
    l.To = b
    l.Color = color
    l.Thickness = 1
    return l
end

RunService.RenderStepped:Connect(function()
    if not esp or not Drawing then return end
    clearESP()

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local char = plr.Character
            local hrp = char.HumanoidRootPart
            local hum = char:FindFirstChildOfClass("Humanoid")

            local pos,vis = Camera:WorldToViewportPoint(hrp.Position)
            if not vis then continue end

            -- BOX
            local box = Drawing.new("Square")
            box.Size = Vector2.new(60,90)
            box.Position = Vector2.new(pos.X-30,pos.Y-45)
            box.Color = Color3.fromRGB(255,0,0)
            box.Filled = false
            table.insert(drawings,box)

            -- NAME + DISTANCE
            local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
            local name = Drawing.new("Text")
            name.Text = plr.Name.." ["..dist.."m]"
            name.Position = Vector2.new(pos.X,pos.Y-60)
            name.Center = true
            name.Outline = true
            name.Size = 13
            table.insert(drawings,name)

            -- HEALTH BAR
            if Config.ESP_Health and hum then
                local hp = hum.Health / hum.MaxHealth
                local bar = Drawing.new("Line")
                bar.From = Vector2.new(pos.X-35,pos.Y+45)
                bar.To = Vector2.new(pos.X-35,pos.Y+45-(90*hp))
                bar.Color = Color3.fromRGB(0,255,0)
                bar.Thickness = 3
                table.insert(drawings,bar)
            end

            -- SKELETON
            if Config.ESP_Skeleton then
                local parts = {
                    {"Head","UpperTorso"},
                    {"UpperTorso","LowerTorso"},
                    {"UpperTorso","LeftUpperArm"},
                    {"UpperTorso","RightUpperArm"},
                    {"LowerTorso","LeftUpperLeg"},
                    {"LowerTorso","RightUpperLeg"}
                }
                for _,p in pairs(parts) do
                    if char:FindFirstChild(p[1]) and char:FindFirstChild(p[2]) then
                        local a = Camera:WorldToViewportPoint(char[p[1]].Position)
                        local b = Camera:WorldToViewportPoint(char[p[2]].Position)
                        local l = drawLine(Vector2.new(a.X,a.Y),Vector2.new(b.X,b.Y),Color3.new(1,1,1))
                        table.insert(drawings,l)
                    end
                end
            end
        end
    end
end)
