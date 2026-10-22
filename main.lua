-- =============================================================================
-- 1. SISTEMA DE KEYS INTEGRADO
-- =============================================================================
local CHAVE_CORRETA = "LUIS-DOORS-2026"
local ChaveInserida = "LUIS-DOORS-2026"

if ChaveInserida ~= CHAVE_CORRETA then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Acesso Negado!",
        Text = "Chave inválida. Script encerrado.",
        Duration = 5
    })
    return
end

-- =============================================================================
-- 2. CONFIGURAÇÕES E ESTADOS GLOBAIS
-- =============================================================================
_G.DoorsHubMaster = {
    GodMode = false,
    ESP = false,
    Speed = false,
    SpeedValue = 32,
    Fly = false,
    FlySpeed = 50,
    Noclip = false
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("LuisDoorsMasterHub") then
    CoreGui.LuisDoorsMasterHub:Destroy()
end

-- =============================================================================
-- 3. INTERFACE GRÁFICA DO ZERO COM ABAS (GUI NATIVA)
-- =============================================================================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "LuisDoorsMasterHub"
ScreenGui.ResetOnSpawn = false

-- Janela Principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.3, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true -- Começa aberto por padrão
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Barra de Título Topo
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.Text = "  DOORS MASTER HUB - COMPLETO MULTI-ABAS"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
local TitleCorner = Instance.new("UICorner", TitleLabel)

-- Painel Lateral Esquerdo (Menu de Abas)
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0, 130, 1, -45)
SideBar.Position = UDim2.new(0, 5, 0, 45)
SideBar.BackgroundTransparency = 1

local SideLayout = Instance.new("UIListLayout", SideBar)
SideLayout.Padding = UDim.new(0, 5)

-- Container Direita (Exibe o Conteúdo da Aba Ativa)
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -150, 1, -55)
ContentContainer.Position = UDim2.new(0, 140, 0, 50)
ContentContainer.BackgroundTransparency = 1

-- =============================================================================
-- GERENCIADOR DE ABAS DINÂMICO
-- =============================================================================
local Abas = {}
local AbaAtiva = nil

local function CriarAba(nome)
    local TabButton = Instance.new("TextButton", SideBar)
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButton.Text = nome
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextSize = 14
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
    
    local TabContent = Instance.new("ScrollingFrame", ContentContainer)
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 400)
    TabContent.ScrollBarThickness = 2
    
    local ContentLayout = Instance.new("UIListLayout", TabContent)
    ContentLayout.Padding = UDim.new(0, 8)
    
    TabButton.MouseButton1Click:Connect(function()
        if AbaAtiva then
            AbaAtiva.Content.Visible = false
            AbaAtiva.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            AbaAtiva.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30) -- Cor ativa alterada para combinar com o botão flutuante
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        AbaAtiva = {Button = TabButton, Content = TabContent}
    end)
    
    local function CreateToggle(texto, callback)
        local ativo = false
        local Button = Instance.new("TextButton", TabContent)
        Button.Size = UDim2.new(1, -5, 0, 38)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Button.Text = texto .. " : [ OFF ]"
        Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        Button.Font = Enum.Font.SourceSans
        Button.TextSize = 14
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)
        
        Button.MouseButton1Click:Connect(function()
            ativo = not ativo
            Button.BackgroundColor3 = ativo and Color3.fromRGB(180, 30, 30) or Color3.fromRGB(45, 45, 45)
            Button.Text = texto .. (ativo and " : [ ON ]" or " : [ OFF ]")
            Button.TextColor3 = ativo and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
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
Abas[1].Button.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
Abas[1].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
AbaAtiva = {Button = Abas[1].Button, Content = Abas[1].Content}

-- =============================================================================
-- 4. BOTÃO FLUTUANTE EXCLUSIVO PARA MOBILE (CORREÇÃO DE TELA)
-- =============================================================================
local MenuVisivel = true

local MobileTab = Instance.new("TextButton", ScreenGui)
MobileTab.Name = "MobileToggleBtn"
MobileTab.Size = UDim2.new(0, 60, 0, 60)
MobileTab.Position = UDim2.new(0, 15, 0, 120) -- Posicionado na lateral esquerda, fácil de alcançar
MobileTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MobileTab.Text = "OPEN"
MobileTab.TextColor3 = Color3.fromRGB(180, 30, 30)
MobileTab.Font = Enum.Font.SourceSansBold
MobileTab.TextSize = 14
MobileTab.BorderSizePixel = 0
MobileTab.Active = true
MobileTab.Draggable = true -- Você pode arrastar o botão para onde quiser se ele atrapalhar o jogo

local MobileCorner = Instance.new("UICorner", MobileTab)
MobileCorner.CornerRadius = UDim.new(0, 30) -- Deixa o botão perfeitamente redondo

-- Efeito visual de borda brilhante para o botão flutuante
local UIStroke = Instance.new("UIStroke", MobileTab)
UIStroke.Color = Color3.fromRGB(180, 30, 30)
UIStroke.Thickness = 2

MobileTab.MouseButton1Click:Connect(function()
    MenuVisivel = not MenuVisivel
    MainFrame.Visible = MenuVisivel
    MobileTab.Text = MenuVisivel and "CLOSE" or "OPEN"
end)

-- Mantém o suporte ao teclado (Teça L) caso esteja em emulador
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.L then
        MenuVisivel = not MenuVisivel
        MainFrame.Visible = MenuVisivel
        MobileTab.Text = MenuVisivel and "CLOSE" or "OPEN"
    end
end)

-- =============================================================================
-- 5. ATRIBUIÇÃO DAS FUNÇÕES DENTRO DAS RESPECTIVAS ABAS
-- =============================================================================

-- --- ABA 1: PRINCIPAL ---
AddTogglePrincipal("God Mode (Exceto Figure/Seek)", function(state)
    _G.DoorsHubMaster.GodMode = state
end)

RunService.Heartbeat:Connect(function()
    if not _G.DoorsHubMaster.GodMode then return end
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name ~= "Figure" and obj.Name ~= "Seek" then
            if obj:IsA("TouchTransmitter") or obj:IsA("TouchInterest") then
                local parent = obj.Parent
                if parent and parent:IsA("BasePart") and LocalPlayer:DistanceFromCharacter(parent.Position) < 20 then
                    parent.CanTouch = false
                end
            end
        end
    end
end)

-- --- ABA 2: MOVIMENTAÇÃO ---
AddToggleMovimento("Velocidade Rápida (Speed)", function(state)
    _G.DoorsHubMaster.Speed = state
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and _G.DoorsHubMaster.Speed then
        hum.WalkSpeed = _G.DoorsHubMaster.SpeedValue
    end
end)

AddToggleMovimento("Atravessar Paredes (Noclip)", function(state)
    _G.DoorsHubMaster.Noclip = state
end)

RunService.Stepped:Connect(function()
    if _G.DoorsHubMaster.Noclip and LocalPlayer.Character then
        for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") then child.CanCollide = false end
        end
    end
end)

local flyBodyPos, flyBodyGyro
AddToggleMovimento("Modo de Voo (Fly)", function(state)
    _G.DoorsHubMaster.Fly = state
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
