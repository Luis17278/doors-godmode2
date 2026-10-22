-- =============================================================================
-- FUNDAÇÃO MODULAR - DOORS HUB DE ESTUDOS
-- =============================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tabela Global de Configurações (Centraliza o estado do Script)
_G.DoorsHubConfig = {
    GodModeStyle = false,
    VisualBright = false,
    AutoScreechClear = false,
    CurrentFloor = 1
}

-- =============================================================================
-- DETECÇÃO DINÂMICA DE FLOORS (HOTEL VS. MINES)
-- =============================================================================
local function DetectFloor()
    -- Analisa o cenário atual para determinar o comportamento do script
    if Workspace:FindFirstChild("CurrentRooms") then
        local firstRoom = Workspace.CurrentRooms:FindFirstChild("0")
        if firstRoom and firstRoom:FindFirstChild("Minecart") or Workspace:FindFirstChild("Mines") then
            _G.DoorsHubConfig.CurrentFloor = 2 -- Andar 2: The Mines
        else
            _G.DoorsHubConfig.CurrentFloor = 1 -- Andar 1: The Hotel
        end
    end
end
DetectFloor()

-- =============================================================================
-- MÓDULO DE INTERFACES NATIVAS (ESTRUTURA DE BOTÕES)
-- =============================================================================
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("DoorsHubMaster") then CoreGui.DoorsHubMaster:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DoorsHubMaster"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 360, 0, 250)
MainFrame.Position = UDim2.new(0.5, -180, 0.4, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "  DOORS MASTER HUB - FLOOR " .. tostring(_G.DoorsHubConfig.CurrentFloor)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Container para organizar os Toggles
local List = Instance.new("Frame", MainFrame)
List.Size = UDim2.new(1, -20, 1, -60)
List.Position = UDim2.new(0, 10, 0, 50)
List.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", List)
Layout.Padding = UDim.new(0, 8)

-- Função auxiliar para gerar opções no Menu
local function CreateToggle(name, callback)
    local active = false
    local btn = Instance.new("TextButton", List)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    
    local btnCorner = Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(50, 50, 50)
        btn.Text = name .. (active and " [ON]" or " [OFF]")
        btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        callback(active)
    end)
end

-- =============================================================================
-- LOGIC SUB-SYSTEMS (EVENT-BASED)
-- =============================================================================

-- Controle de Iluminação Ambiente Local
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.DoorsHubConfig.VisualBright then
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
    end
end)

-- Inclusão dos Toggles Funcionais na Interface
CreateToggle("Modo de Iluminação (FullBright)", function(state)
    _G.DoorsHubConfig.VisualBright = state
end)

CreateToggle("Remover Limitações Locais (Character State)", function(state)
    _G.DoorsHubConfig.GodModeStyle = state
    local char = LocalPlayer.Character
    if char and state then
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            -- Exemplo de desativação de estado de queda/morte local
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    end
end)

CreateToggle("Limpeza de Entidades Clientes (Screech)", function(state)
    _G.DoorsHubConfig.AutoScreechClear = state
end)

-- Ouvinte de instâncias para lidar com o comportamento do Screech
Workspace.DescendantAdded:Connect(function(descendant)
    if _G.DoorsHubConfig.AutoScreechClear and descendant.Name == "Screech" then
        task.wait()
        descendant:Destroy()
    end
end)
