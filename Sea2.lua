local Sea2 = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [[ TABELA DE MISSÕES COMPLETA DO SEA 2 ]]
local QuestData = {
    -- Reino de Rose (Kingdom of Rose)
    {Level = 700, NPC = "Raider", QuestName = "Area1Quest", QuestLevel = 1, EnemyPos = CFrame.new(-424, 73, 299), QuestPos = CFrame.new(-424, 73, 299)},
    {Level = 725, NPC = "Mercenary", QuestName = "Area1Quest", QuestLevel = 2, EnemyPos = CFrame.new(-1100, 73, 330), QuestPos = CFrame.new(-424, 73, 299)},
    {Level = 775, NPC = "Swan Pirate", QuestName = "Area2Quest", QuestLevel = 1, EnemyPos = CFrame.new(878, 122, 1287), QuestPos = CFrame.new(635, 73, 918)},
    {Level = 800, NPC = "Factory Staff", QuestName = "Area2Quest", QuestLevel = 2, EnemyPos = CFrame.new(295, 73, -50), QuestPos = CFrame.new(635, 73, 918)},
    
    -- Green Bit
    {Level = 875, NPC = "Marine Lieutenant", QuestName = "MarineQuest3", QuestLevel = 1, EnemyPos = CFrame.new(-2800, 73, -3000), QuestPos = CFrame.new(-2440, 73, -3210)},
    {Level = 900, NPC = "Marine Captain", QuestName = "MarineQuest3", QuestLevel = 2, EnemyPos = CFrame.new(-1870, 73, -3320), QuestPos = CFrame.new(-2440, 73, -3210)},
    
    -- Cemitério (Graveyard)
    {Level = 950, NPC = "Zombie", QuestName = "GraveyardQuest", QuestLevel = 1, EnemyPos = CFrame.new(-5400, 15, -700), QuestPos = CFrame.new(-5370, 15, -850)},
    {Level = 975, NPC = "Vampire", QuestName = "GraveyardQuest", QuestLevel = 2, EnemyPos = CFrame.new(-6000, 7, -1300), QuestPos = CFrame.new(-5370, 15, -850)},
    
    -- Montanha de Neve (Snow Mountain)
    {Level = 1000, NPC = "Snow Trooper", QuestName = "SnowMountainQuest", QuestLevel = 1, EnemyPos = CFrame.new(450, 400, -5300), QuestPos = CFrame.new(600, 400, -5370)},
    {Level = 1050, NPC = "Winter Warrior", QuestName = "SnowMountainQuest", QuestLevel = 2, EnemyPos = CFrame.new(1150, 430, -5200), QuestPos = CFrame.new(600, 400, -5370)},
    
    -- Quente e Frio (Hot and Cold)
    {Level = 1100, NPC = "Lab Subordinate", QuestName = "IceSideQuest", QuestLevel = 1, EnemyPos = CFrame.new(-6400, 15, -5100), QuestPos = CFrame.new(-6060, 15, -4980)},
    {Level = 1125, NPC = "Horned Warrior", QuestName = "IceSideQuest", QuestLevel = 2, EnemyPos = CFrame.new(-6400, 15, -5800), QuestPos = CFrame.new(-6060, 15, -4980)},
    {Level = 1175, NPC = "Magma Ninja", QuestName = "FireSideQuest", QuestLevel = 1, EnemyPos = CFrame.new(-5400, 15, -5900), QuestPos = CFrame.new(-5430, 15, -5295)},
    {Level = 1200, NPC = "Lava Pirate", QuestName = "FireSideQuest", QuestLevel = 2, EnemyPos = CFrame.new(-5200, 15, -6500), QuestPos = CFrame.new(-5430, 15, -5295)},
    
    -- Navio Amaldiçoado (Cursed Ship)
    {Level = 1250, NPC = "Ship Pirate", QuestName = "ShipQuest1", QuestLevel = 1, EnemyPos = CFrame.new(1037, 125, 32900), QuestPos = CFrame.new(1037, 125, 32900)},
    {Level = 1275, NPC = "Ship Officer", QuestName = "ShipQuest1", QuestLevel = 2, EnemyPos = CFrame.new(1037, 125, 33500), QuestPos = CFrame.new(1037, 125, 32900)},
    {Level = 1300, NPC = "Ship Steward", QuestName = "ShipQuest2", QuestLevel = 1, EnemyPos = CFrame.new(1037, 125, 33200), QuestPos = CFrame.new(1037, 125, 33200)},
    {Level = 1325, NPC = "Ship Engineer", QuestName = "ShipQuest2", QuestLevel = 2, EnemyPos = CFrame.new(1037, 125, 33800), QuestPos = CFrame.new(1037, 125, 33200)},
    
    -- Ilha do Sorvete (Ice Cream Land)
    {Level = 1350, NPC = "Cookie Pirate", QuestName = "IceCreamIslandQuest", QuestLevel = 1, EnemyPos = CFrame.new(-900, 65, -12000), QuestPos = CFrame.new(-820, 65, -10900)},
    {Level = 1375, NPC = "Giant Cookie", QuestName = "IceCreamIslandQuest", QuestLevel = 2, EnemyPos = CFrame.new(-1100, 65, -13000), QuestPos = CFrame.new(-820, 65, -10900)},
    
    -- Ilha Esquecida (Forgotten Island)
    {Level = 1425, NPC = "Sea Soldier", QuestName = "ForgottenQuest", QuestLevel = 1, EnemyPos = CFrame.new(-3000, 15, -17000), QuestPos = CFrame.new(-3050, 15, -15300)},
    {Level = 1450, NPC = "Water Fighter", QuestName = "ForgottenQuest", QuestLevel = 2, EnemyPos = CFrame.new(-3800, 15, -17200), QuestPos = CFrame.new(-3050, 15, -15300)},
}

-- [[ SISTEMA DE MOVIMENTAÇÃO E ATAQUE ]]
local function TweenTo(cframe)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - cframe.Position).Magnitude
    local Speed = 350 -- Velocidade de voo
    local Tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Dist/Speed, Enum.EasingStyle.Linear), {CFrame = cframe})
    Tween:Play()
    
    -- NoClip para não prender em objetos
    if not _G.NoclipActive then
        _G.NoclipActive = true
        RunService.Stepped:Connect(function()
            if _G.AutoFarm and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
    return Tween
end

function Sea2:Load(MyUI)
    -- Criando as abas
    local Farm = MyUI:AddTab("Farm")
    local Config = MyUI:AddTab("config")
    local Especial = MyUI:AddTab("especial")
    local Fruits = MyUI:AddTab("fruits")
    local SeaEvents = MyUI:AddTab("Sea events")
    local Raids = MyUI:AddTab("raids")

    -----------------------------------------------------------
    -- ABA FARM
    -----------------------------------------------------------
    Farm:AddToggle("Auto Farm Level (700-1500)", function(state)
        _G.AutoFarm = state
        task.spawn(function()
            while _G.AutoFarm do
                task.wait()
                pcall(function()
                    local myLevel = LocalPlayer.Data.Level.Value
                    local quest = QuestData[1]
                    for _, v in pairs(QuestData) do
                        if myLevel >= v.Level then quest = v end
                    end

                    if not LocalPlayer.PlayerGui.Main.Quest.Visible then
                        TweenTo(quest.QuestPos)
                        if (LocalPlayer.Character.HumanoidRootPart.Position - quest.QuestPos.Position).Magnitude < 20 then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", quest.QuestName, quest.QuestLevel)
                        end
                    else
                        local Enemy = workspace.Enemies:FindFirstChild(quest.NPC) or workspace.Enemies:FindFirstChild(quest.NPC .. " [Lv. " .. quest.Level .. "]")
                        if Enemy and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
                            TweenTo(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new(999, 999))
                        else
                            TweenTo(quest.EnemyPos)
                        end
                    end
                end)
            end
        end)
    end)

    Farm:AddToggle("Auto Stats (Foco Melee/Def)", function(state)
        _G.AutoStats = state
        task.spawn(function()
            while _G.AutoStats do task.wait(1)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
        end)
    end)

    -----------------------------------------------------------
    -- ABA ESPECIAL (BOSSES E FACTORY)
    -----------------------------------------------------------
    Especial:AddToggle("Auto Factory", function(state)
        _G.Factory = state
        task.spawn(function()
            while _G.Factory do task.wait()
                if workspace:FindFirstChild("Factory") then
                    TweenTo(CFrame.new(432, 210, -430))
                end
            end
        end)
    end)

    Especial:AddToggle("Auto Law (Fragments)", function(state)
        _G.Law = state
        task.spawn(function()
            while _G.Law do task.wait()
                if workspace.Enemies:FindFirstChild("Law") then
                    TweenTo(workspace.Enemies.Law.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0))
                end
            end
        end)
    end)

    -----------------------------------------------------------
    -- ABA RAIDS
    -----------------------------------------------------------
    Raids:AddToggle("Auto Buy Chip", function(state)
        _G.BuyChip = state
        task.spawn(function()
            while _G.BuyChip do task.wait(2)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNPC","Select","Flame")
            end
        end)
    end)

    -----------------------------------------------------------
    -- ABA FRUITS
    -----------------------------------------------------------
    Fruits:AddToggle("Auto Gacha", function(state)
        _G.Gacha = state
        task.spawn(function()
            while _G.Gacha do task.wait(5)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            end
        end)
    end)
    
    Fruits:AddToggle("Auto Store Fruit", function(state)
        _G.Store = state
        task.spawn(function()
            while _G.Store do task.wait(2)
                for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", v:GetAttribute("OriginalName"), v)
                    end
                end
            end
        end)
    end)
end

return Sea2
