local Sea3 = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [[ TABELA DE MISSÕES ATUALIZADA - MÁXIMO LVL 2800 ]]
local QuestData = {
    -- Port Town
    {Level = 1500, NPC = "Pirate Millionaire", QuestName = "PortTownQuest", QuestLevel = 1, EnemyPos = CFrame.new(-3734, 6, -600), QuestPos = CFrame.new(-3580, 6, -440)},
    {Level = 1525, NPC = "Pistol Billionaire", QuestName = "PortTownQuest", QuestLevel = 2, EnemyPos = CFrame.new(-3000, 6, -450), QuestPos = CFrame.new(-3580, 6, -440)},
    -- Hydra Island
    {Level = 1575, NPC = "Dragon Crew Warrior", QuestName = "HydraIslandQuest", QuestLevel = 1, EnemyPos = CFrame.new(5700, 600, -1100), QuestPos = CFrame.new(5450, 600, -750)},
    {Level = 1600, NPC = "Dragon Crew Archer", QuestName = "HydraIslandQuest", QuestLevel = 2, EnemyPos = CFrame.new(6500, 600, -100), QuestPos = CFrame.new(5450, 600, -750)},
    -- Floating Turtle
    {Level = 1625, NPC = "Fishman Raider", QuestName = "TurtleQuest", QuestLevel = 1, EnemyPos = CFrame.new(-12000, 431, -14700), QuestPos = CFrame.new(-11480, 431, -14900)},
    {Level = 1750, NPC = "Forest Pirate", QuestName = "TurtleQuest2", QuestLevel = 1, EnemyPos = CFrame.new(-13300, 331, -10500), QuestPos = CFrame.new(-13230, 331, -11500)},
    {Level = 1900, NPC = "Wild Marine", QuestName = "MarineTreeQuest", QuestLevel = 1, EnemyPos = CFrame.new(-3000, 300, -12000), QuestPos = CFrame.new(-2180, 310, -10390)},
    -- Haunted Castle
    {Level = 1975, NPC = "Reborn Skeleton", QuestName = "HauntedQuest1", QuestLevel = 1, EnemyPos = CFrame.new(-8750, 140, 600), QuestPos = CFrame.new(-8640, 140, 550)},
    {Level = 2025, NPC = "Demonic Soul", QuestName = "HauntedQuest2", QuestLevel = 1, EnemyPos = CFrame.new(-9500, 140, 1500), QuestPos = CFrame.new(-9500, 140, 1500)},
    -- Sea of Treats
    {Level = 2075, NPC = "Peanut Scout", QuestName = "IceCreamIslandQuest", QuestLevel = 1, EnemyPos = CFrame.new(-13500, 100, -13500), QuestPos = CFrame.new(-13500, 100, -13500)},
    {Level = 2200, NPC = "Cookie Crafter", QuestName = "CakeQuest1", QuestLevel = 1, EnemyPos = CFrame.new(-15000, 100, -14500), QuestPos = CFrame.new(-14900, 100, -14400)},
    {Level = 2300, NPC = "Cocoa Warrior", QuestName = "CakeQuest2", QuestLevel = 1, EnemyPos = CFrame.new(-15500, 100, -15000), QuestPos = CFrame.new(-15400, 100, -14900)},
    -- Tiki Outpost
    {Level = 2450, NPC = "Sun-kissed Warrior", QuestName = "TikiQuest", QuestLevel = 1, EnemyPos = CFrame.new(-16500, 50, 500), QuestPos = CFrame.new(-16200, 50, 200)},
    {Level = 2500, NPC = "Isle Outlaw", QuestName = "TikiQuest", QuestLevel = 2, EnemyPos = CFrame.new(-17000, 50, 1000), QuestPos = CFrame.new(-16200, 50, 200)},
    -- [[ NOVA ILHA - UPDATE 2800 ]]
    {Level = 2550, NPC = "Abyssal Guard", QuestName = "AbyssalQuest1", QuestLevel = 1, EnemyPos = CFrame.new(-19000, 10, 2500), QuestPos = CFrame.new(-18800, 15, 2400)},
    {Level = 2650, NPC = "Deep Sea Hunter", QuestName = "AbyssalQuest2", QuestLevel = 1, EnemyPos = CFrame.new(-19500, 10, 3000), QuestPos = CFrame.new(-19400, 15, 2900)},
    {Level = 2725, NPC = "Void Servant", QuestName = "VoidQuest1", QuestLevel = 1, EnemyPos = CFrame.new(-20500, 10, 4500), QuestPos = CFrame.new(-20300, 15, 4400)},
    {Level = 2775, NPC = "Void Commander", QuestName = "VoidQuest1", QuestLevel = 2, EnemyPos = CFrame.new(-21000, 10, 5000), QuestPos = CFrame.new(-20300, 15, 4400)},
}

-- [[ LÓGICA DE MOVIMENTAÇÃO ]]
local function TweenTo(cframe)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local Dist = (LocalPlayer.Character.HumanoidRootPart.Position - cframe.Position).Magnitude
    local Speed = 350
    local Tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Dist/Speed, Enum.EasingStyle.Linear), {CFrame = cframe})
    Tween:Play()
    
    if not _G.NoclipActive then
        _G.NoclipActive = true
        RunService.Stepped:Connect(function()
            if _G.AutoFarm and LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end
    return Tween
end

function Sea3:Load(MyUI)
    local Farm = MyUI:AddTab("Farm")
    local Config = MyUI:AddTab("config")
    local Especial = MyUI:AddTab("especial")
    local SeaEvents = MyUI:AddTab("Sea events")
    local Fruits = MyUI:AddTab("fruits")
    local Raids = MyUI:AddTab("raids")

    -----------------------------------------------------------
    -- ABA FARM
    -----------------------------------------------------------
    Farm:AddToggle("Auto Farm (1500 - 2800)", function(state)
        _G.AutoFarm = state
        task.spawn(function()
            while _G.AutoFarm do
                task.wait()
                pcall(function()
                    local myLevel = LocalPlayer.Data.Level.Value
                    local quest = QuestData[1]
                    for _, v in pairs(QuestData) do if myLevel >= v.Level then quest = v end end

                    if not LocalPlayer.PlayerGui.Main.Quest.Visible then
                        TweenTo(quest.QuestPos)
                        if (LocalPlayer.Character.HumanoidRootPart.Position - quest.QuestPos.Position).Magnitude < 15 then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", quest.QuestName, quest.QuestLevel)
                        end
                    else
                        local Enemy = workspace.Enemies:FindFirstChild(quest.NPC) or workspace.Enemies:FindFirstChild(quest.NPC .. " [Lv. " .. quest.Level .. "]")
                        if Enemy and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
                            TweenTo(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0))
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

    Farm:AddToggle("Auto Stats (Melee/Def)", function(state)
        _G.AutoStats = state
        task.spawn(function()
            while _G.AutoStats do task.wait(1)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
        end)
    end)

    -----------------------------------------------------------
    -- ABA SEA EVENTS
    -----------------------------------------------------------
    SeaEvents:AddToggle("Auto Terror Shark", function(state)
        _G.Terror = state
        task.spawn(function()
            while _G.Terror do task.wait()
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Terror Shark" and v:FindFirstChild("HumanoidRootPart") then
                        TweenTo(v.HumanoidRootPart.CFrame * CFrame.new(0, 45, 0))
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                    end
                end
            end
        end)
    end)

    SeaEvents:AddToggle("Auto Leviathan Finder", function(state)
        -- Lógica de busca em alto mar
    end)

    -----------------------------------------------------------
    -- ABA ESPECIAL
    -----------------------------------------------------------
    Especial:AddToggle("Auto Elite Hunter", function(state)
        _G.Elite = state
        task.spawn(function()
            while _G.Elite do task.wait(5)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("EliteHunter")
            end
        end)
    end)

    Especial:AddToggle("Soul Guitar Quest", function(state)
        if state then TweenTo(CFrame.new(-9515, 160, 850)) end
    end)

    -----------------------------------------------------------
    -- ABA FRUITS
    -----------------------------------------------------------
    Fruits:AddToggle("Auto Gacha & Store", function(state)
        _G.FruitLogic = state
        task.spawn(function()
            while _G.FruitLogic do
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
                for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", v:GetAttribute("OriginalName"), v)
                    end
                end
                task.wait(5)
            end
        end)
    end)

    -----------------------------------------------------------
    -- ABA RAIDS (DOUGH KING)
    -----------------------------------------------------------
    Raids:AddToggle("Auto Dough King / Prince", function(state)
        _G.DoughBoss = state
        task.spawn(function()
            while _G.DoughBoss do task.wait()
                local boss = workspace.Enemies:FindFirstChild("Cake Prince") or workspace.Enemies:FindFirstChild("Dough King")
                if boss then 
                    TweenTo(boss.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(999, 999))
                end
            end
        end)
    end)

    -----------------------------------------------------------
    -- ABA CONFIG
    -----------------------------------------------------------
    Config:AddToggle("Anti-AFK", function(state)
        _G.AntiAFK = state
        LocalPlayer.Idled:Connect(function()
            if _G.AntiAFK then 
                game:GetService("VirtualUser"):CaptureController() 
                game:GetService("VirtualUser"):ClickButton2(Vector2.new()) 
            end
        end)
    end)

    Config:AddToggle("White Screen (FPS)", function(state)
        RunService:Set3dRenderingEnabled(not state)
    end)
end

return Sea3
