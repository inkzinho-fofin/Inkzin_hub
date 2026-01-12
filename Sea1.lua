-- [[ CARREGAMENTO DA INTERFACE ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/inkzinho-fofin/Inkzin_hub/refs/heads/main/Ui_flow_folder"))()
local Container = Library:CreateWindow("INKZIN HUB | SEA 1 (STARTER)")

local LocalPlayer = game.Players.LocalPlayer
local Level = LocalPlayer.Data.Level

-- [[ REPOSITÓRIO DE QUESTS - SEA 1 ]]
-- Nível, NomeQuest, NomeNPC, NomeMonstro, PosNPC
local Sea1_Quests = {
    {0, "BanditQuest1", "Quest Giver", "Bandit", CFrame.new(1060, 15, 1545)},
    {10, "MonkeyQuest1", "Adventurer", "Monkey", CFrame.new(-1600, 35, 155)},
    {15, "MonkeyQuest1", "Adventurer", "Gorilla", CFrame.new(-1600, 35, 155)},
    {30, "PirateVillageQuest", "Sophie", "Pirate", CFrame.new(-1140, 5, 3825)},
    {40, "PirateVillageQuest", "Sophie", "Brute", CFrame.new(-1140, 5, 3825)},
    {60, "DesertQuest", "Desert Adventurer", "Desert Bandit", CFrame.new(895, 5, 4390)},
    {75, "DesertQuest", "Desert Adventurer", "Desert Officer", CFrame.new(895, 5, 4390)},
    {90, "SnowQuest", "Village Elder", "Snow Bandit", CFrame.new(1385, 15, -1300)},
    {100, "SnowQuest", "Village Elder", "Snowman", CFrame.new(1385, 15, -1300)},
    {120, "MarineQuest", "Marine Officer", "Chief Petty Officer", CFrame.new(-4855, 20, 4340)},
    {150, "SkyQuest", "Sky Adventurer", "Sky Bandit", CFrame.new(-4840, 715, -2620)},
    {190, "PrisonQuest", "Prison Warden", "Prisoner", CFrame.new(5310, 5, 470)},
    {250, "MagmaQuest", "Magma Admiral", "Military Soldier", CFrame.new(-5315, 10, 8515)},
    {300, "MagmaQuest", "Magma Admiral", "Military Spy", CFrame.new(-5315, 10, 8515)},
    {375, "UnderwaterQuest", "Water Adventurer", "Fishman Warrior", CFrame.new(61120, 15, 1565)},
    {450, "SkyQuest2", "Mole", "God's Guard", CFrame.new(-4720, 845, -1950)},
    {525, "FountainQuest", "Fountain Adventurer", "Galley Pirate", CFrame.new(5255, 40, 4050)},
    {625, "FountainQuest", "Fountain Adventurer", "Galley Captain", CFrame.new(5255, 40, 4050)}
}

-- [[ TAB: MAIN FARM ]]
local MainTab = Container:AddSection("Auto Farm Level")

_G.AutoFarm = false
MainTab:AddButton("Auto Farm Smart: OFF", function(self)
    _G.AutoFarm = not _G.AutoFarm
    self.Text = "Auto Farm Smart: " .. (_G.AutoFarm and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoFarm do
            pcall(function()
                -- Lógica de seleção automática de quest baseada no nível
                local myLevel = Level.Value
                local best = Sea1_Quests[1]
                for _, q in pairs(Sea1_Quests) do
                    if myLevel >= q[1] then best = q end
                end
                -- Ação: Teleport NPC -> Pegar Quest -> Matar Mob
            end)
            task.wait(1)
        end
    end)
end)

-- [[ TAB: FRUITS (SEA 1) ]]
local FruitTab = Container:AddSection("Fruits & ESP")

AddButton(FruitTab, "Girar Fruta (Cousin)", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
end)

AddButton(FruitTab, "Fruit ESP (Studs)", function()
    -- Lógica de localização de frutas no mapa
end)

-- [[ TAB: SIDE QUESTS (SEA 1) ]]
local SideTab = Container:AddSection("Missões Especiais")

AddButton(SideTab, "Auto Saber Quest (Shanks)", function()
    -- Teleporta para os botões da selva e resolve o puzzle
    print("Iniciando Puzzle do Shanks...")
end)

AddButton(SideTab, "Auto Pole (Enel)", function()
    -- Farm do Boss Thunder God no Upper Sky
end)

-- [[ TAB: SETTINGS ]]
local ConfigTab = Container:AddSection("Configurações")

Container:AddSlider("Velocidade de Tween", 100, 300, 150, function(v)
    _G.FlySpeed = v
end)

AddButton(ConfigTab, "Anti-AFK", function()
    -- Código para evitar ser desconectado
end)

-- [[ VARIÁVEIS DE CONFIGURAÇÃO - SEA 1 ]]
_G.FlySpeed = 150
_G.AutoStats = false
_G.StatPoint = "Melee" -- Opções: Melee, Defense, Sword, Blox Fruit
_G.AntiAFK = true
_G.FastAttack = true

local ConfigSection = Container:AddSection("Configurações & Performance")

-- 1. Velocidade de Movimentação
-- No Sea 1, as distâncias são menores, então 150-200 é o ideal para não bugar o mapa.
Container:AddSlider("Velocidade de Voo", 100, 300, 150, function(v)
    _G.FlySpeed = v
end)

-- 2. Sistema de Auto Stats (Vital para Iniciantes)
-- No Sea 1, o player ganha pontos muito rápido. Este sistema distribui sozinho.
MainTab:AddLabel("--- Distribuição de Pontos ---")

AddButton(ConfigSection, "Auto Stats: OFF", function(self)
    _G.AutoStats = not _G.AutoStats
    self.Text = "Auto Stats: " .. (_G.AutoStats and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoStats do
            pcall(function()
                local args = {
                    [1] = "AddPoint",
                    [2] = _G.StatPoint,
                    [3] = 1
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end)
            task.wait(0.3)
        end
    end)
end)

-- Seletor de onde colocar os pontos
AddButton(ConfigSection, "Focar em: " .. _G.StatPoint, function(self)
    local stats = {"Melee", "Defense", "Sword", "Blox Fruit"}
    local pos = table.find(stats, _G.StatPoint)
    local nextPos = pos + 1
    if nextPos > #stats then nextPos = 1 end
    _G.StatPoint = stats[nextPos]
    self.Text = "Focar em: " .. _G.StatPoint
end)

-- 3. Modo Fast Attack (Otimizado para Sea 1)
AddButton(ConfigSection, "Ataque Rápido: ON", function(self)
    _G.FastAttack = not _G.FastAttack
    self.Text = "Ataque Rápido: " .. (_G.FastAttack and "ON" or "OFF")
end)

-- 4. Anti-AFK (Evita ser desconectado enquanto farma a noite)
AddButton(ConfigSection, "Ativar Anti-AFK", function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
    print("Anti-AFK Inkzin Hub Ativado!")
end)

-- 5. Otimização de Gráficos (Para PC e Celular)
AddButton(ConfigSection, "Remover Texturas (FPS Boost)", function()
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Transparency = 0
        end
    end
    print("Gráficos otimizados!")
end)

-- 6. Salvar Configurações
AddButton(ConfigSection, "Salvar Configs do Sea 1", function()
    local save = {
        FlySpeed = _G.FlySpeed,
        StatPoint = _G.StatPoint
    }
    writefile("Inkzin_Sea1_Config.json", game:GetService("HttpService"):JSONEncode(save))
end)
