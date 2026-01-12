-- [[ CONFIGURAÇÕES DA LIBRARY ]]
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ INTERFACE MODERNA ROXO/PRETO ]]
local Library = {
    Theme = {
        Background = Color3.fromRGB(0, 0, 0),
        Secondary = Color3.fromRGB(25, 10, 40),
        Accent = Color3.fromRGB(160, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(60, 20, 100),
        CloseHover = Color3.fromRGB(255, 100, 100)
    }
}

function Library:MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "InkzinSea1"

    local ToggleBtn = Instance.new("ImageButton", ScreenGui)
    ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    ToggleBtn.Position = UDim2.new(0, 20, 0, 150)
    ToggleBtn.BackgroundColor3 = self.Theme.Secondary
    ToggleBtn.Image = "rbxassetid://10734893112"
    ToggleBtn.ImageColor3 = self.Theme.Accent
    Instance.new("UICorner", ToggleBtn)
    self:MakeDraggable(ToggleBtn)

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 450, 0, 320)
    Main.Position = UDim2.new(0.5, -225, 0.5, -160)
    Main.BackgroundColor3 = self.Theme.Background
    Instance.new("UICorner", Main)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = self.Theme.Border; Stroke.Thickness = 2
    self:MakeDraggable(Main)

    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Text = "✕"; CloseBtn.TextColor3 = self.Theme.Text; CloseBtn.TextSize = 20
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    local Content = Instance.new("ScrollingFrame", Main)
    Content.Position = UDim2.new(0, 10, 0, 40)
    Content.Size = UDim2.new(1, -20, 1, -50)
    Content.BackgroundTransparency = 1
    Content.ScrollBarThickness = 2
    local Layout = Instance.new("UIListLayout", Content)
    Layout.Padding = UDim.new(0, 8)

    return Content
end

-- [[ LÓGICA DE FARM E DADOS ]]
_G.AutoFarm = false
_G.AutoStats = false

local Quests = {
    {0, "BanditQuest1", "Bandit Recruiter", "Bandit", CFrame.new(1059, 15, 1549), CFrame.new(1184, 16, 1625)},
    {10, "JungleQuest", "Adventurer", "Monkey", CFrame.new(-1598, 36, 153), CFrame.new(-1600, 37, 160)},
    {15, "JungleQuest", "Adventurer", "Gorilla", CFrame.new(-1598, 36, 153), CFrame.new(-1204, 28, -510)},
    {30, "PirateVillageQuest", "Quest Giver", "Pirate", CFrame.new(-1922, 7, 3934), CFrame.new(-1890, 22, 3950)},
    {60, "DesertQuest", "Quest Giver", "Desert Bandit", CFrame.new(894, 6, 4390), CFrame.new(990, 6, 4425)},
    {90, "SnowQuest", "Quest Giver", "Snow Bandit", CFrame.new(1384, 15, -1318), CFrame.new(1280, 20, -1280)},
    {120, "MarineQuest", "Quest Giver", "Chief Petty Officer", CFrame.new(-4800, 20, 4320), CFrame.new(-4850, 22, 4350)},
    {150, "SkyQuest", "Quest Giver", "Sky Bandit", CFrame.new(-1143, 843, -4467), CFrame.new(-1150, 845, -4520)},
    {190, "PrisonQuest", "Quest Giver", "Prisoner", CFrame.new(5300, 0, 500), CFrame.new(5350, 2, 530)},
    {250, "MagmaQuest", "Quest Giver", "Military Soldier", CFrame.new(-5250, 8, 8500), CFrame.new(-5300, 10, 8550)},
    {450, "UpperSkyQuest1", "Quest Giver", "God's Guard", CFrame.new(-4700, 915, -18850), CFrame.new(-4750, 920, -18900)},
    {625, "FountainQuest", "Quest Giver", "Galley Pirate", CFrame.new(5250, 38, 4050), CFrame.new(5300, 40, 4100)}
}

function GetBestQuest()
    local lvl = LocalPlayer.Data.Level.Value
    local best = Quests[1]
    for _, q in pairs(Quests) do if lvl >= q[1] then best = q end end
    return best
end

-- [[ CRIAÇÃO DAS SEÇÕES NA UI ]]
local Container = Library:CreateWindow("INKZIN HUB | SEA 1")

local function AddButton(parent, text, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Library.Theme.Secondary
    b.Text = text; b.TextColor3 = Library.Theme.Text; b.Font = Enum.Font.Gotham
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- ABA FARM
AddButton(Container, "Auto Farm Level: OFF", function(self)
    _G.AutoFarm = not _G.AutoFarm
    self.Text = "Auto Farm Level: " .. (_G.AutoFarm and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoFarm do
            local q = GetBestQuest()
            -- Aqui entraria sua lógica de Tween para q[5] (Quest) e q[6] (Monstros)
            task.wait(1)
        end
    end)
end)

-- ABA BOSS
AddButton(Container, "Farm Bosses (Sea 1)", function() print("Procurando Bosses...") end)

-- ABA BAGAS (FRUTAS)
AddButton(Container, "Coletar Frutas no Chão", function()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name:find("Fruit") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
        end
    end
end)

-- ABA BAÚS
AddButton(Container, "Auto Farm Baús", function()
    _G.AutoChest = not _G.AutoChest
    task.spawn(function()
        while _G.AutoChest do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") then LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame end
            end
            task.wait(0.5)
        end
    end)
end)

-- [[ ANTI-AFK ]]
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- [[ SEÇÃO DE FRUTAS (SEA 1) ]]
local FruitSection = Container:AddSection("Fruits & Bagas")

-- Lista de Frutas para Identificação (Opcional para filtros)
local FruitList = {
    "Rocket", "Spin", "Chop", "Spring", "Bomb", "Smoke", "Spike", "Flame", "Falcon", "Ice", 
    "Sand", "Dark", "Diamond", "Light", "Rubber", "Barrier", "Ghost", "Magma", "Quake", 
    "Buddha", "Love", "Spider", "Sound", "Phoenix", "Portal", "Rumble", "Pain", "Blizzard", 
    "Gravity", "Mammoth", "T-Rex", "Dough", "Shadow", "Venom", "Control", "Spirit", 
    "Dragon", "Leopard", "Kitsune"
}

-- 1. Girar Fruta (Gacha)
AddButton(FruitSection, "Girar Fruta (Gacha)", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
end)

-- 2. Localizar Frutas (ESP com Distância em Studs)
local FruitESP = false
AddButton(FruitSection, "Localizar Frutas (ESP + Distância)", function()
    FruitESP = not FruitESP
    
    -- Limpa ESP ao desligar
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:FindFirstChild("FruitESP") then v.FruitESP:Destroy() end
    end

    if FruitESP then
        task.spawn(function()
            while FruitESP do
                for _, v in pairs(game.Workspace:GetChildren()) do
                    -- Verifica se o item é uma fruta no chão
                    if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Baga")) then
                        local handle = v:FindFirstChild("Handle")
                        if handle then
                            local billboard = v:FindFirstChild("FruitESP")
                            if not billboard then
                                billboard = Instance.new("BillboardGui", v)
                                billboard.Name = "FruitESP"
                                billboard.AlwaysOnTop = true
                                billboard.Size = UDim2.new(0, 150, 0, 70)
                                billboard.ExtentsOffset = Vector3.new(0, 3, 0)
                                
                                local label = Instance.new("TextLabel", billboard)
                                label.Name = "DistanceLabel"
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.TextColor3 = Library.Theme.Accent
                                label.Font = Enum.Font.GothamBold
                                label.TextSize = 14
                                label.Parent = billboard
                            end
                            
                            -- Cálculo de Distância (Studs)
                            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - handle.Position).Magnitude)
                            billboard.DistanceLabel.Text = v.Name .. "\n[" .. dist .. " studs]"
                        end
                    end
                end
                task.wait(0.5) -- Atualiza a distância rapidamente
            end
        end)
    end
end)

-- 3. Auto Coletar (Teleporte)
_G.AutoCollectFruits = false
AddButton(FruitSection, "Auto Coletar Frutas: OFF", function(self)
    _G.AutoCollectFruits = not _G.AutoCollectFruits
    self.Text = "Auto Coletar Frutas: " .. (_G.AutoCollectFruits and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoCollectFruits do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Baga")) then
                    local h = v:FindFirstChild("Handle")
                    if h then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = h.CFrame
                        task.wait(0.3)
                    end
                end
            end
            task.wait(1)
        end
    end)
end)
