-- =============================================================================
-- INTERFACE E SISTEMA DE CHEATS CORRIGIDO - MOBILE PRODUCTION FINAL
-- =============================================================================
local CHAVE_CORRETA = "LUIS-DOORS-2026"
local ChaveInserida = "LUIS-DOORS-2026"

if ChaveInserida ~= CHAVE_CORRETA then return end

_G.DoorsHubMaster = {
    GodMode = false,
    ESP = false,
    Speed = false,
    SpeedValue = 22, -- Limiar de estabilidade para evitar lagback
    Fly = false,
    FlySpeed = 30,
    Noclip = false
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TargetGui = LocalPlayer:WaitForChild("PlayerGui")

if TargetGui:FindFirstChild("LuisDoorsMasterHub") then 
    TargetGui.LuisDoorsMasterHub:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui", TargetGui)
ScreenGui.Name = "LuisDoorsMasterHub"
ScreenGui.ResetOnSpawn = false

-- Janela Principal (Menu)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 440, 0, 280)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Barra de Título
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleLabel.Text = "  DOORS MASTER HUB - V2 FINAL"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", TitleLabel).CornerRadius = UDim.new(0, 8)

local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 110, 1, -45)
SideBar.Position = UDim2.new(0, 5, 0, 40)
SideBar.BackgroundTransparency = 1
local SideLayout = Instance.new("UIListLayout", SideBar)
SideLayout.Padding = UDim.new(0, 5)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -130, 1, -50)
ContentContainer.Position = UDim2.new(0, 120, 0, 45)
ContentContainer.BackgroundTransparency = 1

local Abas = {}
local AbaAtiva = nil

local function CriarAba(nome)
    local TabButton = Instance.new("TextButton", SideBar)
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TabButton.Text = nome
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextSize = 13
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 5)
    
    local TabContent = Instance.new("ScrollingFrame", ContentContainer)
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 350)
    TabContent.ScrollBarThickness = 2
    local ContentLayout = Instance.new("UIListLayout", TabContent)
    ContentLayout.Padding = UDim.new(0, 6)
    
    TabButton.MouseButton1Click:Connect(function()
        if AbaAtiva then
            AbaAtiva.Content.Visible = false
            AbaAtiva.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            AbaAtiva.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        AbaAtiva = {Button = TabButton, Content = TabContent}
    end)
    
    local function CreateToggle(texto, callback)
        local ativo = false
        local Button = Instance.new("TextButton", TabContent)
        Button.Size = UDim2.new(1, -5, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        Button.Text = texto .. " : [ OFF ]"
        Button.TextColor3 = Color3.fromRGB(220, 220, 220)
        Button.Font = Enum.Font.SourceSans
        Button.TextSize = 13
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
        
        Button.MouseButton1Click:Connect(function()
            ativo = not ativo
            Button.BackgroundColor3 = ativo and Color3.fromRGB(200, 40, 40) or Color3.fromRGB(55, 55, 55)
            Button.Text = texto .. (ativo and " : [ ON ]" or " : [ OFF ]")
            Button.TextColor3 = ativo and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 220, 220)
            callback(ativo)
        end)
    end
    
    table.insert(Abas, {Button = TabButton, Content = TabContent, CreateToggle = CreateToggle})
    return CreateToggle
end

local AddTogglePrincipal = CriarAba("🛡️ Principal")
local AddToggleMovimento = CriarAba("⚡ Movimento")
local AddToggleVisuais   = CriarAba("👁️ Visuais")

Abas[1].Content.Visible = true
Abas[1].Button.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
Abas[1].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
AbaAtiva = {Button = Abas[1].Button, Content = Abas[1].Content}

-- Botão de Minimizar (Abre/Fecha)
local MenuVisivel = true
local MobileTab = Instance.new("TextButton", ScreenGui)
MobileTab.Size = UDim2.new(0, 50, 0, 28)
MobileTab.Position = UDim2.new(0, 80, 0, 48)
MobileTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MobileTab.Text = "MENU"
MobileTab.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileTab.Font = Enum.Font.SourceSansBold
MobileTab.TextSize = 12
MobileTab.Draggable = true
Instance.new("UICorner", MobileTab).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", MobileTab).Color = Color3.fromRGB(200, 40, 40)

MobileTab.MouseButton1Click:Connect(function()
    MenuVisivel = not MenuVisivel
    MainFrame.Visible = MenuVisivel
end)

-- =============================================================================
-- LOGICAS DO MOTOR DE CHEATS
-- =============================================================================

-- 1. ESTRUTURA GOD MODE (RUSH/AMBUSH EXCLUSION VIA SAFESTATE)
AddTogglePrincipal("God Mode Inteligente", function(state)
    _G.DoorsHubMaster.GodMode = state
end)

Workspace.DescendantAdded:Connect(function(descendant)
    if not _G.DoorsHubMaster.GodMode then return end
    if descendant.Name:find("Rush") or descendant.Name:find("Ambush") then
        task.wait(0.1)
        pcall(function()
            for _, child in ipairs(descendant:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.CanCollide = false
                    if child:FindFirstChild("TouchBoxes") then
                        child.TouchBoxes:Destroy()
                    end
                end
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    if not _G.DoorsHubMaster.GodMode then return end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name ~= "Figure" and obj.Name ~= "Seek" and (obj:IsA("TouchTransmitter") or obj:IsA("TouchInterest")) then
                local p = obj.Parent
                if p and p:IsA("BasePart") and LocalPlayer:DistanceFromCharacter(p.Position) < 25 then
                    p.CanTouch = false
                end
            end
        end
    end
end)

-- 2. AJUSTE DE VELOCIDADE ESTÁVEL
AddToggleMovimento("Velocidade Segura", function(state)
    _G.DoorsHubMaster.Speed = state
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if _G.DoorsHubMaster.Speed then
            hum.WalkSpeed = _G.DoorsHubMaster.SpeedValue
        else
            hum.WalkSpeed = 16
        end
    end
end)

-- 3. MECÂNICA NOCLIP
AddToggleMovimento("Noclip Seguro", function(state)
    _G.DoorsHubMaster.Noclip = state
end)

RunService.Stepped:Connect(function()
    if _G.DoorsHubMaster.Noclip and LocalPlayer.Character then
        for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CanCollide = false
            end
        end
    end
end)

-- 4. CONTROLE DE VOO VIA VELOCIDADE LINEAR (FLY)
local flyAttachment, flyVelocity
AddToggleMovimento("Fly Funcional Mobile", function(state)
    _G.DoorsHubMaster.Fly = state
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if not state then
        if flyAttachment then flyAttachment:Destroy() flyAttachment = nil end
        if flyVelocity then flyVelocity:Destroy() flyVelocity = nil end
        if char and char:FindFirstChildOfClass("Humanoid") then 
            char:FindFirstChildOfClass("Humanoid").PlatformStand = false 
        end
        return
    end
    
    if root then
        char:FindFirstChildOfClass("Humanoid").PlatformStand = true
        flyAttachment = Instance.new("Attachment", root)
        flyVelocity = Instance.new("LinearVelocity", root)
        flyVelocity.Attachment0 = flyAttachment
        flyVelocity.MaxForce = 9e9
        flyVelocity.VectorVelocity = Vector3.new(0, 0, 0)
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.DoorsHubMaster.Fly and flyVelocity and LocalPlayer.Character then
        local camera = Workspace.CurrentCamera
        if camera then
            flyVelocity.VectorVelocity = camera.CFrame.LookVector * _G.DoorsHubMaster.FlySpeed
        end
    else
        if flyVelocity and not _G.DoorsHubMaster.Fly then
            flyVelocity.VectorVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- 5. VISUAIS (PLAYER ESP)
local espBoxes = {}
AddToggleVisuais("Box ESP", function(state)
    _G.DoorsHubMaster.ESP = state

            for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CanCollide = false
            end
        end
    end
end)

-- 4. CONTROLE DE VOO VIA VELOCIDADE LINEAR (FLY)
local flyAttachment, flyVelocity
AddToggleMovimento("Fly Funcional Mobile", function(state)
    _G.DoorsHubMaster.Fly = state
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if not state then
        if flyAttachment then flyAttachment:Destroy() flyAttachment = nil end
        if flyVelocity then flyVelocity:Destroy() flyVelocity = nil end
        if char and char:FindFirstChildOfClass("Humanoid") then 
            char:FindFirstChildOfClass("Humanoid").PlatformStand = false 
        end
        return
    end
    
    if root then
        char:FindFirstChildOfClass("Humanoid").PlatformStand = true
        flyAttachment = Instance.new("Attachment", root)
        flyVelocity = Instance.new("LinearVelocity", root)
        flyVelocity.Attachment0 = flyAttachment
        flyVelocity.MaxForce = 9e9
        flyVelocity.VectorVelocity = Vector3.new(0, 0, 0)
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.DoorsHubMaster.Fly and flyVelocity and LocalPlayer.Character then
        local camera = Workspace.CurrentCamera
        if camera then
            flyVelocity.VectorVelocity = camera.CFrame.LookVector * _G.DoorsHubMaster.FlySpeed
        end
    else
        if flyVelocity and not _G.DoorsHubMaster.Fly then
            flyVelocity.VectorVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- 5. VISUAIS (PLAYER ESP)
local espBoxes = {}
AddToggleVisuais("Box ESP", function(state)
    _G.DoorsHubMaster.ESP = state
    if not state then
        for _, box in pairs(espBoxes) do box:Destroy() end
        table.clear(espBoxes)
    end
end)

RunService.RenderStepped:Connect(function()
    if not _G.DoorsHubMaster.ESP then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            if not espBoxes[p] then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(4, 6, 4)
                box.Color3 = Color3.fromRGB(200, 40, 40)
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Adornee = root
                box.Parent = ScreenGui
                espBoxes[p] = box
            end
        elseif espBoxes[p] and (not p.Character or not p.Character:Parent()) then
            espBoxes[p]:Destroy()
            espBoxes[p] = nil
        end
    end
end)
