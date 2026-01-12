local Sea2 = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [[ 1. TABELA DE MISSÕES DO SEA 2 (700 - 1500) ]]
local QuestData = {
    -- Kingdom of Rose
    {Level = 700, NPC = "Raider", QuestName = "Area1Quest", QuestLevel = 1, EnemyPos = CFrame.new(-424, 73, 299), QuestPos = CFrame.new(-424, 73, 299)},
    {Level = 725, NPC = "Mercenary", QuestName = "Area1Quest", QuestLevel = 2, EnemyPos = CFrame.new(-1100, 73, 330), QuestPos = CFrame.new(-424, 73, 299)},
    {Level = 775, NPC = "Swan Pirate", QuestName = "Area2Quest", QuestLevel = 1, EnemyPos = CFrame.new(878, 122, 1287), QuestPos = CFrame.new(635, 73, 918)},
    -- Green Bit
    {Level = 875, NPC = "Marine Lieutenant", QuestName = "MarineQuest3", QuestLevel = 1, EnemyPos = CFrame.new(-2800, 73, -3000), QuestPos = CFrame.new(-2440, 73, -3210)},
    -- Graveyard
    {Level = 950, NPC = "Zombie", QuestName = "GraveyardQuest", QuestLevel = 1, EnemyPos = CFrame.new(-5400, 15, -700), QuestPos = CFrame.new(-5370, 15, -850)},
    -- Snow Mountain
    {Level = 1000, NPC = "Snow Trooper", QuestName = "SnowMountainQuest", QuestLevel = 1, EnemyPos = CFrame.new(450, 400, -5300), QuestPos = CFrame.new(600, 400, -5370)},
    -- Hot and Cold
    {Level = 1100, NPC = "Lab Subordinate", QuestName = "IceSideQuest", QuestLevel = 1, EnemyPos = CFrame.new(-6400, 15, -5100), QuestPos = CFrame.new(-6060, 15, -4980)},
    -- Cursed Ship
    {Level = 1250, NPC = "Ship Pirate", QuestName = "ShipQuest1", QuestLevel = 1, EnemyPos = CFrame.new(1037, 125, 33000), QuestPos = CFrame.new(1037, 125, 33000)},
    -- Ice Cream Land
    {Level = 1350, NPC = "Cookie Pirate", QuestName = "IceCreamIslandQuest", QuestLevel = 1, EnemyPos = CFrame.new(-900, 65, -12000), QuestPos = CFrame.new(-820, 65, -10900)},
    -- Forgotten Island
    {Level = 1425, NPC = "Sea Soldier", QuestName = "ForgottenQuest", QuestLevel = 1, EnemyPos = CFrame.new(-3000, 15, -17000), QuestPos = CFrame.new(-3050, 15, -15300)},
}

-- [[ 2. SISTEMA DE MOVIMENTAÇÃO ]]
local function TweenTo(cframe)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - cframe.Position).Magnitude
    local Speed = 320
    local Tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Dist/Speed, Enum.EasingStyle.Linear), {CFrame = cframe})
    Tween:Play()
    
    -- Noclip automático durante o voo
    if not _G.NoclipEvent then
        _G.NoclipEvent = RunService.Stepped:Connect(function()
            if _G.AutoFarm and LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end
    return Tween
end

function Sea2:Load(MyUI)
    -- Criando Abas
    local Farm = MyUI:AddTab("Farm")
    local Config = MyUI:AddTab("config")
    local Especial = MyUI:AddTab("especial")
    local Fruits = MyUI:AddTab("fruits")
    local SeaEvents = MyUI:AddTab("Sea events")
    local Raids = MyUI:AddTab("raids")

    --------------------------------------------------------------------------------
    -- [ABA FARM]
    --------------------------------------------------------------------------------
    Farm:AddToggle("Auto Farm Level (700-1500)", function(state)
        _G.AutoFarm = state
        task.spawn(function()
            while _G.AutoFarm do
                task.wait()
                pcall(function()
                    local myLevel = LocalPlayer.Data.Level.Value
                    local questInfo = QuestData[1]
                    for _, v in pairs(QuestData) do
                        if myLevel >= v.Level then questInfo = v end
                    end

                    if not LocalPlayer.PlayerGui.Main.Quest.Visible then
                        TweenTo(questInfo.QuestPos)
                        if (LocalPlayer.Character.HumanoidRootPart.Position - questInfo.QuestPos.Position).Magnitude < 20 then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questInfo.QuestName, questInfo.QuestLevel)
                        end
                    else
                        local Enemy = workspace.Enemies:FindFirstChild(questInfo.NPC) or workspace.Enemies:FindFirstChild(questInfo.NPC .. " [Lv. " .. questInfo.Level .. "]")
                        if Enemy and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
                            TweenTo(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0))
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new(999, 999))
                        else
                            TweenTo(questInfo.EnemyPos)
                        end
                    end
                end)
            end
        end)
    end)

    Farm:AddToggle("Auto Stats (Melee/Def)", function(state)
        _G.AutoStats = state
        task.spawn(function()
            while _G.AutoStats do task.wait(0.7)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
        end)
    end)

    --------------------------------------------------------------------------------
    -- [ABA RAIDS]
    --------------------------------------------------------------------------------
    Raids:AddToggle("Auto Start Raid", function(state)
        _G.AutoRaid = state
        task.spawn(function()
            while _G.AutoRaid do task.wait(1)
                -- Lógica simplificada: Compra chip e tenta iniciar
                ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNPC","Select","Flame") -- Exemplo Flame
                ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNPC","Confirm")
            end
        end)
    end)

    Raids:AddToggle("Kill Aura (Raid Mode)", function(state)
        _G.RaidKill = state
        task.spawn(function()
            while _G.RaidKill do task.wait()
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        v.Humanoid.Health = 0 -- Nota: Apenas visual ou se o exploit permitir
                    end
                end
            end
        end)
    end)

    --------------------------------------------------------------------------------
    -- [ABA ESPECIAL]
    --------------------------------------------------------------------------------
    Especial:AddToggle("Auto Factory", function(state)
        _G.AutoFactory = state
        task.spawn(function()
            while _G.AutoFactory do task.wait()
                if workspace:FindFirstChild("Factory") then
                    TweenTo(CFrame.new(432, 200, -430)) -- Posição Core da Factory
                end
            end
        end)
    end)

    Especial:AddToggle("Auto Law Boss", function(state)
        _G.LawFarm = state
        task.spawn(function()
            while _G.LawFarm do task.wait()
                if workspace.Enemies:FindFirstChild("Law") then
                    TweenTo(workspace.Enemies.Law.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                end
            end
        end)
    end)

    --------------------------------------------------------------------------------
    -- [ABA FRUITS]
    --------------------------------------------------------------------------------
    Fruits:AddToggle("Auto Gacha (Sea 2)", function(state)
        _G.AutoGacha = state
        task.spawn(function()
            while _G.AutoGacha do task.wait(2)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            end
        end)
    end)

    --------------------------------------------------------------------------------
    -- [ABA SEA EVENTS]
    --------------------------------------------------------------------------------
    SeaEvents:AddToggle("Sea Beast Hunter", function(state)
        _G.SBHunter = state
        task.spawn(function()
            while _G.SBHunter do task.wait(1)
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == "Sea Beast" then
                        TweenTo(v.CFrame * CFrame.new(0, 50, 0))
                    end
                end
            end
        end)
    end)

    --------------------------------------------------------------------------------
    -- [ABA CONFIG]
    --------------------------------------------------------------------------------
    Config:AddToggle("Anti-AFK", function(state)
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            if state then
                vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end
        end)
    end)
end

return Sea2
