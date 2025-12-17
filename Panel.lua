--[[
7DVI HUB | PREMIUM SCRIPT HUB
Key ONLINE + Dark Premium UI + Abas + Blur + Toggle por Tecla
]]

-- ================= CONFIG =================
local HUB_NAME = "7DVI HUB"
local KEY_URL = "https://raw.githubusercontent.com/7dvi-hub/script-hub/main/key.txt"
local TOGGLE_KEY = Enum.KeyCode.RightShift -- MUDE AQUI A TECLA

-- ================= SERVICES =================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer

-- ================= CLEAN =================
if game.CoreGui:FindFirstChild(HUB_NAME) then
    game.CoreGui[HUB_NAME]:Destroy()
end

-- ================= BLUR =================
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

local function tweenBlur(v)
    TweenService:Create(Blur, TweenInfo.new(0.35), {Size = v}):Play()
end

-- ================= GET ONLINE KEY =================
local function getOnlineKey()
    local ok, result = pcall(function()
        return game:HttpGet(KEY_URL)
    end)
    if ok then
        return result:gsub("%s+", "")
    end
    return nil
end

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = HUB_NAME

-- ================= DRAG =================
local function drag(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
