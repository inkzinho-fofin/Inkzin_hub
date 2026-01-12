-- [[ CARREGAMENTO DA INTERFACE ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/inkzinho-fofin/Inkzin_hub/refs/heads/main/Ui_flow_folder"))()
local Container = Library:CreateWindow("INKZIN HUB | SEA 1")

-- [[ VARIÁVEIS DE CONTROLE ]]
_G.AutoFarm = false
_G.AutoBoss = false
_G.AutoFruit = false
_G.AutoChest = false

local Player = game.Players.LocalPlayer
local Level = Player.Data.Level

-- [[ REPOSITÓRIO DE DADOS - SEA 1 ]]
-- Formato: {Nível Necessário, Nome da Quest, Nome do NPC, Nome do Monstro, Posição da Quest, Posição do Farm}
local Sea1_Quests = {
    {0, "BanditQuest1", "Bandit Recruiter", "Bandit", CFrame.new(1059, 15, 1549), CFrame.new(1184, 16, 1625)},
    {10, "JungleQuest", "Adventurer", "Monkey", CFrame.new(-1598, 36, 153), CFrame.new(-1600, 37, 160)},
    {15, "JungleQuest", "Adventurer", "Gorilla", CFrame.new(-1598, 36, 153), CFrame.new(-1204, 28, -510)},
    {30, "PirateVillageQuest", "Quest Giver", "Pirate", CFrame.new(-1922, 7, 3934), CFrame.new(-1890, 22, 3950)},
    -- Adicione as demais quests seguindo esta hierarquia de nível
}

-- [[ FUNÇÃO SISTEMA DE NÍVEL INTELIGENTE ]]
function GetCurrentQuest()
    local myLevel = Level.Value
    local bestQuest = Sea1_Quests[1]
    
    for _, quest in pairs(Sea1_Quests) do
        if myLevel >= quest[1] then
            bestQuest = quest
        end
    end
    return bestQuest
end

-- [[ ABAS PRINCIPAIS (TABS) ]]

-- 1. TAB: MAIN FARM (Nível)
local MainTab = Container:AddSection("Auto Farm Level")

MainTab:AddButton("Toggle Auto Farm [Smart]", function()
    _G.AutoFarm = not _G.AutoFarm
    
    task.spawn(function()
        while _G.AutoFarm do
            pcall(function()
                local q = GetCurrentQuest()
                -- Lógica:
                -- Se não tiver a quest -> Teleporta pro NPC (q[5]) e pega a quest (q[2])
                -- Se tiver a quest -> Teleporta pro Farm (q[6]) e ataca o Monstro (q[4])
                print("Farmando: " .. q[4] .. " (Nível " .. q[1] .. "+)")
            end)
            task.wait(0.5)
        end
    end)
end)

-- 2. TAB: BOSSES
local BossTab = Container:AddSection("Farm Boss")

BossTab:AddButton("Toggle Farm All Bosses", function()
    _G.AutoBoss = not _G.AutoBoss
    -- Lógica para verificar se bosses como Gorilla King ou Buggy deram spawn
end)

-- 3. TAB: FRUTAS (Bagas)
local FruitTab = Container:AddSection("Farm Baga (Fruits)")

FruitTab:AddButton("Auto Collect Fruits", function()
    _G.AutoFruit = not _G.AutoFruit
    task.spawn(function()
        while _G.AutoFruit do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Baga")) then
                    -- Teleportar para a fruta
                    firetouchinterest(Player.Character.HumanoidRootPart, v.Handle, 0)
                end
            end
            task.wait(1)
        end
    end)
end)

-- 4. TAB: BAÚS
local ChestTab = Container:AddSection("Farm Baús")

ChestTab:AddButton("Auto Chest [Fast]", function()
    _G.AutoChest = not _G.AutoChest
    task.spawn(function()
        while _G.AutoChest do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name == "Chest" or v.Name == "Chest1" or v.Name == "Chest2" or v.Name == "Chest3" then
                    Player.Character.HumanoidRootPart.CFrame = v.CFrame
                    task.wait(0.2)
                end
            end
            task.wait(0.1)
        end
    end)
end)

