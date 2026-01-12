local Sea1 = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [[ 1. TABELA DE DADOS (Nível 1 ao 700) ]]
local QuestData = {
    {Level = 1, NPC = "Bandit", QuestName = "BanditQuest1", QuestLevel = 1, EnemyPos = CFrame.new(1060, 17, 1547), QuestPos = CFrame.new(1060, 17, 1547)},
    {Level = 10, NPC = "Monkey", QuestName = "JungleQuest", QuestLevel = 1, EnemyPos = CFrame.new(-1600, 37, 150), QuestPos = CFrame.new(-1600, 37, 150)},
    {Level = 15, NPC = "Gorilla", QuestName = "JungleQuest", QuestLevel = 2, EnemyPos = CFrame.new(-1240, 7, -500), QuestPos = CFrame.new(-1600, 37, 150)},
    {Level = 30, NPC = "Pirate", QuestName = "BuggyQuest1", QuestLevel = 1, EnemyPos = CFrame.new(-1115, 5, 3940), QuestPos = CFrame.new(-1140, 5, 3830)},
    {Level = 40, NPC = "Brute", QuestName = "BuggyQuest1", QuestLevel = 2, EnemyPos = CFrame.new(-1300, 6, 4160), QuestPos = CFrame.new(-1140, 5, 3830)},
    {Level = 60, NPC = "Desert Bandit", QuestName = "DesertQuest", QuestLevel = 1, EnemyPos = CFrame.new(930, 7, 4420), QuestPos = CFrame.new(895, 7, 4390)},
    {Level = 75, NPC = "Desert Officer", QuestName = "DesertQuest", QuestLevel = 2, EnemyPos = CFrame.new(1350, 7, 4380), QuestPos = CFrame.new(895, 7, 4390)},
    {Level = 90, NPC = "Snow Bandit", QuestName = "SnowQuest", QuestLevel = 1, EnemyPos = CFrame.new(1360, 88, -1280), QuestPos = CFrame.new(1385, 88, -1298)},
    {Level = 100, NPC = "Snowman", QuestName = "SnowQuest", QuestLevel = 2, EnemyPos = CFrame.new(1160, 88, -1450), QuestPos = CFrame.new(1385, 88, -1298)},
    {Level = 120, NPC = "Chief Petty Officer", QuestName = "MarineQuest2", QuestLevel = 1, EnemyPos = CFrame.new(-4850, 21, 4260), QuestPos = CFrame.new(-5035, 28, 4325)},
    {Level = 150, NPC = "Sky Bandit", QuestName = "SkyQuest", QuestLevel = 1, EnemyPos = CFrame.new(-4970, 278, -970), QuestPos = CFrame.new(-4840, 279, -943)},
    {Level = 175, NPC = "Dark Master", QuestName = "SkyQuest", QuestLevel = 2, EnemyPos = CFrame.new(-5250, 389, -2250), QuestPos = CFrame.new(-4840, 279, -943)},
    {Level = 190, NPC = "Prisoner", QuestName = "PrisonerQuest", QuestLevel = 1, EnemyPos = CFrame.new(5300, 2, 475), QuestPos = CFrame.new(5380, 2, 475)},
    {Level = 210, NPC = "Dangerous Prisoner", QuestName = "PrisonerQuest", QuestLevel = 2, EnemyPos = CFrame.new(5560, 2, 280), QuestPos = CFrame.new(5380, 2, 475)},
    {Level = 225, NPC = "Toga Warrior", QuestName = "ColosseumQuest", QuestLevel = 1, EnemyPos = CFrame.new(-1760, 8, -2750), QuestPos = CFrame.new(-1575, 8, -2985)},
    {Level = 275, NPC = "Gladiator", QuestName = "ColosseumQuest", QuestLevel = 2, EnemyPos = CFrame.new(-1340, 8, -3300), QuestPos = CFrame.new(-1575, 8, -2985)},
    {Level = 300, NPC = "Military Soldier", QuestName = "MagmaQuest", QuestLevel = 1, EnemyPos = CFrame.new(-5400, 9, 8500), QuestPos = CFrame.new(-5315, 13, 8515)},
    {Level = 325, NPC = "Military Spy", QuestName = "MagmaQuest", QuestLevel = 2, EnemyPos = CFrame.new(-5815, 9, 8820), QuestPos = CFrame.new(-5315, 13, 8515)},
    {Level = 375, NPC = "Fishman Warrior", QuestName = "FishmanQuest", QuestLevel = 1, EnemyPos = CFrame.new(61122, 19, 1565), QuestPos = CFrame.new(61122, 19, 1565)},
    {Level = 400, NPC = "Fishman Commando", QuestName = "FishmanQuest", QuestLevel = 2, EnemyPos = CFrame.new(61122, 19, 1565), QuestPos = CFrame.new(61122, 19, 1565)},
    {Level = 450, NPC = "God's Guard", QuestName = "SkyExp1Quest", QuestLevel = 1, EnemyPos = CFrame.new(-4720, 846, -1950), QuestPos = CFrame.new(-4720, 846, -1950)},
    {Level = 500, NPC = "Shanda", QuestName = "SkyExp2Quest", QuestLevel = 1, EnemyPos = CFrame.new(-7680, 5551, -480), QuestPos = CFrame.new(-7900, 5551, -6380)},
    {Level = 625, NPC = "Galley Pirate", QuestName = "FountainQuest", QuestLevel = 1, EnemyPos = CFrame.new(5580, 5, 3980), QuestPos = CFrame.new(5255, 5, 3855)},
    {Level = 650, NPC = "Galley Captain", QuestName = "FountainQuest", QuestLevel = 2, EnemyPos = CFrame.new(5650, 5, 4950), QuestPos = CFrame.new(5255, 5, 3855)},
}

-- [[ 2. FUNÇÕES ÚTEIS (TWEENS E ATAQUES) ]]
local function GetCurrentQuest()
    local myLevel = LocalPlayer.Data.Level.Value
    local target = QuestData[1]
    for _, v in pairs(QuestData) do
        if myLevel >= v.Level then target = v end
    end
    return target
end

local function TweenTo(cframe)
    local Character = LocalPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local HRP = Character.HumanoidRootPart
        local Dist = (HRP.Position - cframe.Position).Magnitude
        local Speed = 300
        local Info = TweenInfo.new(Dist / Speed, Enum.EasingStyle.Linear)
        local Tween = TweenService:Create(HRP, Info, {CFrame = cframe})
        Tween:Play()
        -- Ativar NoClip para não bater nas paredes
        if not _G.NoclipRunning then
             _G.NoclipRunning = true
             RunService.Stepped:Connect(function()
                 if _G.AutoFarm then
                     for _, v in pairs(Character:GetChildren()) do
                         if v:IsA("BasePart") then v.CanCollide = false end
                     end
                 end
             end)
        end
        return Tween
    end
end

-- [[ 3. CARREGAMENTO DA LIBRARY ]]
function Sea1:Load(MyUI)
    -- Criando as abas conforme pedido
    local Farm = MyUI:AddTab("Farm")
    local Config = MyUI:AddTab("config")
    local Especial = MyUI:AddTab("especial")
    local Fruits = MyUI:AddTab("fruits")
    local SeaEvents = MyUI:AddTab("Sea events")
    local Raids = MyUI:AddTab("raids")

    --------------------------------------------------------------------------------
    -- [ABA FARM]
    --------------------------------------------------------------------------------
    Farm:AddToggle("Auto Farm Level (1-700)", function(state)
        _G.AutoFarm = state
        
        task.spawn(function()
            while _G.AutoFarm do
                task.wait()
                pcall(function()
                    local QuestInfo = GetCurrentQuest()
                    local hasQuest = LocalPlayer.PlayerGui.Main.Quest.Visible
                    
                    if not hasQuest then
                        -- Ir para o NPC e pegar missão
                        TweenTo(QuestInfo.QuestPos)
                        if (LocalPlayer.Character.HumanoidRootPart.Position - QuestInfo.QuestPos.Position).Magnitude < 20 then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", QuestInfo.QuestName, QuestInfo.QuestLevel)
                        end
                    else
                        -- Matar o NPC
                        local TargetEnemy = nil
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == QuestInfo.NPC and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                TargetEnemy = v
                                break
                            end
                        end
                        
                        if TargetEnemy then
                            -- Ir até o inimigo
                            TweenTo(TargetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)) -- Fica flutuando acima dele
                            
                            -- Auto Click / Fast Attack
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new(999, 999))
                            
                            -- Usar habilidade se tiver
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("Globalcd")
                        else
                            -- Esperar no Spawn dele
                            TweenTo(QuestInfo.EnemyPos)
                        end
                    end
                end)
            end
        end)
    end)

    Farm:AddToggle("Auto Stats (Melee)", function(state)
        _G.AutoStats = state
        task.spawn(function()
            while _G.AutoStats do task.wait(0.5)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
            end
        end)
    end)

    Farm:AddToggle("Auto Stats (Defense)", function(state)
        _G.AutoDefense = state
        task.spawn(function()
            while _G.AutoDefense do task.wait(0.5)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
        end)
    end)

    --------------------------------------------------------------------------------
    -- [ABA CONFIG]
    --------------------------------------------------------------------------------
    Config:AddToggle("WalkSpeed (200)", function(state)
        _G.Speed = state
        task.spawn(function()
            while _G.Speed do task.wait()
                if LocalPlayer.Character then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 200
                end
            end
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end)
    end)

    Config:AddToggle("Infinite Jump", function(state)
        _G.InfJump = state
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfJump then
                LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
            end
        end)
    end)

    Config:AddToggle("White Screen (FPS Boost)", function(state)
        RunService:Set3dRenderingEnabled(not state)
    end)

    Config:AddToggle("Remove Attack Effect", function(state)
        if state then
            -- Código simples para deletar partículas
            for _, v in pairs(game.ReplicatedStorage.Effect.Container:GetChildren()) do
                if v:IsA("Part") or v:IsA("MeshPart") then v:Destroy() end
            end
        end
    end)

    --------------------------------------------------------------------------------
    -- [ABA FRUITS]
    --------------------------------------------------------------------------------
    Fruits:AddToggle("Auto Buy Random Fruit", function(state)
        _G.AutoBuyFruit = state
        task.spawn(function()
            while _G.AutoBuyFruit do task.wait(1)
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            end
        end)
    end)

    Fruits:AddToggle("Auto Store Fruit", function(state)
        _G.AutoStore = state
        task.spawn(function()
            while _G.AutoStore do task.wait(1)
                for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", v:GetAttribute("OriginalName"), v)
                    end
                end
                -- Checar também no personagem
                if LocalPlayer.Character then
                    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                        if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", v:GetAttribute("OriginalName"), v)
                        end
                    end
                end
            end
        end)
    end)

    Fruits:AddToggle("Teleport to Fruit", function(state)
        _G.TPFruit = state
        task.spawn(function()
            while _G.TPFruit do task.wait(1)
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Blox Fruit" and v:FindFirstChild("Handle") then
                        TweenTo(v.Handle.CFrame)
                    end
                end
            end
        end)
    end)

    --------------------------------------------------------------------------------
    -- [ABA ESPECIAL]
    --------------------------------------------------------------------------------
    Especial:AddToggle("Auto Saber Quest", function(state)
        -- Script simples para ir aos botões da Saber
        if state then
            print("Iniciando Quest da Saber (Lógica de Puzzle)...")
            -- Nota: O puzzle da saber é complexo, aqui apenas teleportaríamos para os botões
        end
    end)

    Especial:AddToggle("Go to Sky (Upper)", function(state)
        if state then TweenTo(CFrame.new(-7894, 5547, -380)) end
    end)
    
    Especial:AddToggle("Go to Underwater", function(state)
        if state then TweenTo(CFrame.new(61163, 11, 1819)) end
    end)

    --------------------------------------------------------------------------------
    -- [ABA SEA EVENTS / RAIDS] (Adaptação para Sea 1)
    --------------------------------------------------------------------------------
    -- No Sea 1 não existem Sea Events ou Raids oficiais.
    -- Vamos usar essas abas para utilitários de mundo.
    
    SeaEvents:AddToggle("Go to Sea 2 (NPC)", function(state)
        if state then
            -- Teleporta para o prisioneiro da quest do Sea 2
            TweenTo(CFrame.new(-5039, 28, 4390))
        end
    end)

    Raids:AddToggle("Auto Greybeard Boss", function(state)
        _G.Greybeard = state
        task.spawn(function()
            while _G.Greybeard do task.wait()
                if workspace.Enemies:FindFirstChild("Greybeard") then
                    TweenTo(workspace.Enemies.Greybeard.HumanoidRootPart.CFrame * CFrame.new(0,10,0))
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(800, 800))
                end
            end
        end)
    end)
end

return Sea1
