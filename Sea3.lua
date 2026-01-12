
-- [[ CONFIGURAÇÕES DA INTERFACE ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/inkzinho-fofin/Inkzin_hub/refs/heads/main/Ui_flow_folder"))()
local Container = Library:CreateWindow("INKZIN HUB | SEA 3 FULL")

local LocalPlayer = game.Players.LocalPlayer
local Level = LocalPlayer.Data.Level

-- [[ DATABASE DE NPCs E MISSÕES - SEA 3 ]]
-- Organizado por Ilha e Progressão
local Sea3_Database = {
    -- Port Town (1500 - 1575)
    {1500, "PortTownQuest", "Quest Giver", "Pirate Millionaire", CFrame.new(-290, 7, 5330)},
    {1575, "PortTownQuest", "Quest Giver", "Pistol Billionaire", CFrame.new(-290, 7, 5330)},
    
    -- Hydra Island (1625 - 1750)
    {1625, "HydraIslandQuest", "Quest Giver", "Dragon Crew Warrior", CFrame.new(5215, 15, 10)},
    {1700, "HydraIslandQuest", "Quest Giver", "Dragon Crew Archer", CFrame.new(5215, 15, 10)},
    {1750, "HydraIslandQuest", "Quest Giver", "Female Island Outlaw", CFrame.new(5215, 15, 10)},
    
    -- Floating Turtle (1775 - 1950)
    {1775, "FloatingTurtleQuest1", "Quest Giver", "Fishman Raider", CFrame.new(-13270, 530, -7580)},
    {1850, "FloatingTurtleQuest1", "Quest Giver", "Fishman Captain", CFrame.new(-13270, 530, -7580)},
    {1900, "FloatingTurtleQuest2", "Quest Giver", "Forest Pirate", CFrame.new(-13270, 530, -7580)},
    {1950, "FloatingTurtleQuest2", "Quest Giver", "Mythological Pirate", CFrame.new(-13270, 530, -7580)},
    
    -- Haunted Castle (1975 - 2175)
    {1975, "HauntedQuest1", "Quest Giver", "Reborn Skeleton", CFrame.new(-9500, 160, 8450)},
    {2025, "HauntedQuest1", "Quest Giver", "Living Zombie", CFrame.new(-9500, 160, 8450)},
    {2100, "HauntedQuest2", "Quest Giver", "Demonic Soul", CFrame.new(-9500, 160, 8450)},
    {2175, "HauntedQuest2", "Quest Giver", "Posessed Mummy", CFrame.new(-9500, 160, 8450)},
    
    -- Sea of Treats (2200 - 2475)
    {2200, "CakeQuest1", "Quest Giver", "Cookie Crafter", CFrame.new(-1150, 15, 12800)},
    {2275, "CakeQuest1", "Quest Giver", "Cake Guard", CFrame.new(-1150, 15, 12800)},
    {2350, "CakeQuest2", "Quest Giver", "Baking Staff", CFrame.new(-1900, 40, 12850)},
    {2425, "CakeQuest2", "Quest Giver", "Head Baker", CFrame.new(-1900, 40, 12850)},
    
    -- Candy Cane Land (2500 - 2625)
    {2500, "CandyQuest1", "Quest Giver", "Candy Pirate", CFrame.new(-1150, 15, 14200)},
    {2575, "CandyQuest1", "Quest Giver", "Snowman Squad", CFrame.new(-1150, 15, 14200)},
    
    -- Tiki Outpost (2650 - 2800)
    {2650, "TikiQuest1", "Quest Giver", "Sun-kissed Warrior", CFrame.new(-16200, 15, 1000)},
    {2725, "TikiQuest2", "Quest Giver", "Isle Guardian", CFrame.new(-16200, 15, 1000)},
    {2800, "TikiQuest3", "Quest Giver", "Celestial Guard", CFrame.new(-16200, 15, 1000)}
}

-- [[ FUNÇÃO DE AUTO-QUEST ]]
function CheckQuest()
    local myLevel = Level.Value
    local best = Sea3_Database[1]
    for _, q in pairs(Sea3_Database) do
        if myLevel >= q[1] then best = q end
    end
    return best
end

-- [[ TAB MAIN - FUNÇÕES TÉCNICAS ]]
local MainTab = Container:AddSection("Controle Principal Sea 3")

-- 1. Farm Automático Inteligente
_G.AutoFarm = false
MainTab:AddButton("Auto Farm Level [1500-2800]", function(self)
    _G.AutoFarm = not _G.AutoFarm
    self.Text = _G.AutoFarm and "Auto Farm: ATIVO" or "Auto Farm: DESATIVADO"
    
    task.spawn(function()
        while _G.AutoFarm do
            local q = CheckQuest()
            -- Lógica de Teleport e Farm aqui
            task.wait(1)
        end
    end)
end)

-- 2. Elite Hunter Tracker (NPC Elite Hunter)
MainTab:AddButton("Auto Elite Hunter (Yama Quest)", function()
    -- NPC: Elite Hunter (Castelo no Mar)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
end)

-- 3. Death King (NPC de Ossos)
MainTab:AddButton("Girar Ossos (NPC Death King)", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("DeathKing", "Buy", 1)
end)

-- 4. Dungeon Master (NPC de Raids Avançadas)
MainTab:AddButton("Comprar Chip (NPC Dungeon Master)", function()
    -- Abre o menu de compra de chips no Castelo no Mar
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Raids", "BuyChip", "Money")
end)

-- 5. Lunatic (NPC de Maestria)
MainTab:AddButton("Teleport NPC Lunatic (Maestria)", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12480, 380, -7590)
end)

-- 6. Drip Mama (NPC Dough King)
MainTab:AddButton("Verificar Progresso Dough King", function()
    -- Interage com o NPC Drip Mama para ver o contador de 500 NPCs
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceTeleport")
end)

-- 7. Misery (NPC Soul Guitar)
MainTab:AddButton("Check Soul Guitar Quest", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9550, 160, 8450)
end)

-- [[ ABA: TELEPORTS RÁPIDOS ]]
local TPSection = Container:AddSection("Teleportes Rápidos NPCs")
AddButton(TPSection, "Tiki Outpost (Tutor)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-16200, 15, 1000) end)
AddButton(TPSection, "Castelo no Mar (Elite Hunter)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5000, 315, -3000) end)
AddButton(TPSection, "Mansão (Trevor/Manager)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12465, 375, -7560) end)
AddButton(TPSection, "Hydra Island (Arena)", function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5215, 15, 10) end)
local MainTab = Container:AddSection("Farm Principal & NPCs")

-- 1. BOTÃO SMART FARM (Nível 1500 a 2800)
-- Inclui agora: Port Town, Hydra, Turtle, Haunted, Treats, Candy, Deep Sea e Tiki.
AddButton(MainTab, "Auto Farm Level (Completo): OFF", function(self)
    _G.AutoFarm = not _G.AutoFarm
    self.Text = "Auto Farm Level: " .. (_G.AutoFarm and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoFarm do
            local q = CheckQuest()
            -- Lógica de voo e ataque para todos os NPCs listados (incluindo Sea Guardians)
            task.wait(1)
        end
    end)
end)

-- 2. NPC: SEA GUARDIAN (ILHA SUBAQUÁTICA)
AddButton(MainTab, "Teleport Ilha Subaquática", function()
    -- Posição do NPC de missão da ilha Deep Sea
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9500, 10, 1000)
end)

-- 3. NPC: DRIP MAMA (DOUGH KING)
AddButton(MainTab, "Interagir com Drip Mama", function()
    -- Para verificar os 500 inimigos mortos no mar de chocolate
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceTeleport")
end)

-- 4. NPC: ELITE HUNTER (YAMA/GODHUMAN)
AddButton(MainTab, "Falar com Elite Hunter", function()
    -- Verifica se há Elite Pirates vivos para a missão
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
end)

-- 5. NPC: SHARK HUNTER (TIKI OUTPOST)
AddButton(MainTab, "Teleport Shark Hunter (Tiki)", function()
    -- Para craftar itens do Terror Shark e Anchor
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-16200, 15, 1000)
end)

-- 6. NPC: DEATH KING (OSSOS)
AddButton(MainTab, "Trocar Ossos (Death King)", function()
    -- Localizado no Haunted Castle
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("DeathKing", "Buy", 1)
end)

local RaidSection = Container:AddSection("Sistema de Raids (Castelo)")

local AllRaids = {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Sand", "Buddha", "Dough", "Phoenix"}
_G.SelectedRaid3 = "Flame"

-- 1. Seletor de Raid
AddButton(RaidSection, "Selecionar Raid: " .. _G.SelectedRaid3, function(self)
    local idx = table.find(AllRaids, _G.SelectedRaid3)
    local nextIdx = idx + 1
    if nextIdx > #AllRaids then nextIdx = 1 end
    _G.SelectedRaid3 = AllRaids[nextIdx]
    self.Text = "Selecionar Raid: " .. _G.SelectedRaid3
end)

-- 2. Auto Comprar Chip e Iniciar (Castelo no Mar)
_G.AutoRaid3 = false
AddButton(RaidSection, "Auto Iniciar Raid: OFF", function(self)
    _G.AutoRaid3 = not _G.AutoRaid3
    self.Text = "Auto Iniciar Raid: " .. (_G.AutoRaid3 and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoRaid3 do
            if not game:GetService("Workspace").Map:FindFirstChild("RaidMap") then
                -- Tenta comprar chip com fruta barata
                local trash = LocalPlayer.Backpack:FindFirstChild("Rocket Fruit") or LocalPlayer.Backpack:FindFirstChild("Spin Fruit")
                local method = trash and trash.Name or "Money"
                
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Raids", "BuyChip", method)
                task.wait(1)
                
                -- Teleporte para o painel de início no Castelo no Mar
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5026, 315, -2984)
                task.wait(0.5)
                fireclickdetector(game:GetService("Workspace").Map["Boat Castle"].RaidManager.ClickPart.ClickDetector)
            end
            task.wait(5)
        end
    end)
end)

-- 3. Auto Kill Raid (End-Game)
_G.AutoKillRaid3 = false
AddButton(RaidSection, "Auto Kill Mobs Raid: OFF", function(self)
    _G.AutoKillRaid3 = not _G.AutoKillRaid3
    self.Text = "Auto Kill Mobs Raid: " .. (_G.AutoKillRaid3 and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoKillRaid3 do
            pcall(function()
                if game:GetService("Workspace").Map:FindFirstChild("RaidMap") then
                    for _, e in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                            repeat
                                if not _G.AutoKillRaid3 then break end
                                LocalPlayer.Character.HumanoidRootPart.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                                -- Chame aqui sua função de ataque principal
                                task.wait()
                            until e.Humanoid.Health <= 0 or not e.Parent
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)


local FruitSection = Container:AddSection("Fruits & Inventário")

-- 1. Girar Fruta (NPC Blox Fruit Gacha - Castelo no Mar)
AddButton(FruitSection, "Girar Fruta (Gacha Sea 3)", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
end)

-- 2. Localizar Frutas (ESP + Distância em Studs)
local FruitESP = false
AddButton(FruitSection, "Localizar Frutas (ESP)", function()
    FruitESP = not FruitESP
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:FindFirstChild("FruitESP") then v.FruitESP:Destroy() end
    end

    if FruitESP then
        task.spawn(function()
            while FruitESP do
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Baga")) then
                        local h = v:FindFirstChild("Handle")
                        if h then
                            local bill = v:FindFirstChild("FruitESP") or Instance.new("BillboardGui", v)
                            bill.Name = "FruitESP"
                            bill.AlwaysOnTop = true
                            bill.Size = UDim2.new(0, 150, 0, 70)
                            
                            local lab = bill:FindFirstChild("TextLabel") or Instance.new("TextLabel", bill)
                            lab.Size = UDim2.new(1, 0, 1, 0)
                            lab.BackgroundTransparency = 1
                            lab.TextColor3 = Library.Theme.Accent
                            lab.Font = Enum.Font.GothamBold
                            lab.TextSize = 14
                            
                            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - h.Position).Magnitude)
                            lab.Text = v.Name .. "\n[" .. dist .. " studs]"
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- 3. Auto Coletar e Armazenar Automático
_G.AutoStoreFruit = false
AddButton(FruitSection, "Auto Coletar e Armazenar: OFF", function(self)
    _G.AutoStoreFruit = not _G.AutoStoreFruit
    self.Text = "Auto Coletar e Armazenar: " .. (_G.AutoStoreFruit and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoStoreFruit do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and v.Name:find("Fruit") then
                    local h = v:FindFirstChild("Handle")
                    if h then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = h.CFrame
                        task.wait(0.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                    end
                end
            end
            task.wait(1)
        end
    end)
end)

-- [[ VARIÁVEIS DE CONTROLE ]]
_G.AutoEliteHunter = false
_G.AutoBossSea3 = false

local SpecialTab = Container:AddSection("Itens Especiais & Bosses")

-- 1. YAMA & TUSHITA (Caminho para CDK)
AddButton(SpecialTab, "Auto Elite Hunter (Yama Quest)", function(self)
    _G.AutoEliteHunter = not _G.AutoEliteHunter
    self.Text = "Auto Elite Hunter: " .. (_G.AutoEliteHunter and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoEliteHunter do
            pcall(function()
                local Elites = {"Deandre", "Diablo", "Urban"}
                for _, name in pairs(Elites) do
                    local elite = game:GetService("Workspace").Enemies:FindFirstChild(name)
                    if elite and elite:FindFirstChild("HumanoidRootPart") and elite.Humanoid.Health > 0 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = elite.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
                        -- Chamar função de ataque
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

AddButton(SpecialTab, "Teleport Tushita Quest (Tochas)", function()
    -- Teleporta para o local das 5 tochas da Tushita (Hydra Island)
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4950, 15, -25)
end)

-- 2. BOSSES LENDÁRIOS (INVOCAÇÃO)
AddButton(SpecialTab, "Invocar Rip_Indra (Requisito: Cálice)", function()
    -- Local do altar no Castelo no Mar
    local chalice = LocalPlayer.Backpack:FindFirstChild("God's Chalice") or LocalPlayer.Character:FindFirstChild("God's Chalice")
    if chalice then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5380, 420, -2825)
    else
        print("Você precisa do God's Chalice!")
    end
end)

AddButton(SpecialTab, "Auto Farm Dough King (Invocar)", function()
    -- Verifica com o NPC Drip Mama se os 500 NPCs foram mortos
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceTeleport")
    print("Teleportando para verificar progresso do Dough King...")
end)

-- 3. ITENS DE CRAFT (MATERIAIS)
AddButton(SpecialTab, "Coletar Materiais (Tiki Outpost)", function()
    -- Teleporta para os NPCs de craft de itens do mar (Shark Anchor, etc)
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-16235, 12, 1065)
end)

-- 4. SOUL GUITAR (ARMA MÍTICA)
AddButton(SpecialTab, "Iniciar Quest Soul Guitar (Noite)", function()
    -- Teleporta para o cemitério do Haunted Castle
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9565, 170, 8465)
end)

-- 5. RAÇA CYBORG & GHOUL (ITEMS)
AddButton(SpecialTab, "Farm Ectoplasma (Ghoul)", function()
    -- Teleporta para o Navio Amaldiçoado (Sea 2) ou áreas de Ghost no Sea 3
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9500, 160, 8500)
end)

-- [[ VARIÁVEIS DE CONFIGURAÇÃO GLOBAL ]]
_G.FlySpeed = 200
_G.FarmDistance = 10
_G.AutoClicker = false
_G.FastAttack = true
_G.AntiAFK = true
_G.ShowStats = true

local ConfigSection = Container:AddSection("Configurações & Performance")

-- 1. Velocidade de Movimentação (Tween Speed)
-- Essencial para atravessar o mapa gigante do Sea 3 sem ser detectado
Container:AddSlider("Velocidade de Voo/Farm", 100, 350, 200, function(v)
    _G.FlySpeed = v
end)

-- 2. Distância de Ataque (Killaura/Farm)
-- No Sea 3, alguns NPCs têm longo alcance. Recomenda-se 10-12 studs.
Container:AddSlider("Distância do NPC", 5, 25, 12, function(v)
    _G.FarmDistance = v
end)

-- 3. Modo Fast Attack
AddButton(ConfigSection, "Fast Attack: ON", function(self)
    _G.FastAttack = not _G.FastAttack
    self.Text = "Fast Attack: " .. (_G.FastAttack and "ON" or "OFF")
end)

-- 4. Anti-AFK Automático
-- Impede que o Roblox te expulse após 20 minutos farmando ossos ou elites
AddButton(ConfigSection, "Ativar Anti-AFK", function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
    print("Anti-AFK ativado com sucesso!")
end)

-- 5. Otimização de FPS (White Screen / Low Graphics)
-- Útil para deixar o PC ligado farmando por horas no Sea 3
AddButton(ConfigSection, "Otimizar FPS (Modo Leve)", function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
        end
    end
end)

-- 6. Salvar Configurações
AddButton(ConfigSection, "Salvar Todas as Configs", function()
    local config = {
        FlySpeed = _G.FlySpeed,
        FarmDistance = _G.FarmDistance,
        FastAttack = _G.FastAttack
    }
    local json = game:GetService("HttpService"):JSONEncode(config)
    writefile("InkzinHub_Sea3_Config.json", json)
    print("Configurações do Sea 3 salvas!")
end)
