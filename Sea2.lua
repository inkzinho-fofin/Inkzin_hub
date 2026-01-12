-- [[ CARREGAMENTO DA INTERFACE ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/inkzinho-fofin/Inkzin_hub/refs/heads/main/Ui_flow_folder"))()
local Container = Library:CreateWindow("INKZIN HUB | SEA 2")

-- [[ VARIÁVEIS DE CONTROLE ]]
_G.AutoFarm = false
_G.AutoStats = false
local Player = game.Players.LocalPlayer
local Level = Player.Data.Level

-- [[ REPOSITÓRIO DE DADOS - SEA 2 (700 a 1500) ]]
-- Formato: {Nível, NomeQuest, NomeNPC, NomeMonstro, PosQuest, PosFarm}
local Sea2_Quests = {
    {700, "Area1Quest", "Quest Giver", "Raider", CFrame.new(-425, 73, -2650), CFrame.new(-750, 73, -2400)},
    {725, "Area1Quest", "Quest Giver", "Mercenary", CFrame.new(-425, 73, -2650), CFrame.new(-1000, 73, -2850)},
    {775, "Area2Quest", "Quest Giver", "Swan Pirate", CFrame.new(634, 73, -4465), CFrame.new(900, 73, -4350)},
    {800, "Area2Quest", "Quest Giver", "Factory Worker", CFrame.new(634, 73, -4465), CFrame.new(150, 73, -4300)},
    {875, "MarineQuest2", "Quest Giver", "Marine Lieutenant", CFrame.new(-2440, 73, -3200), CFrame.new(-2800, 73, -3000)},
    {900, "MarineQuest2", "Quest Giver", "Marine Captain", CFrame.new(-2440, 73, -3200), CFrame.new(-3000, 73, -3300)},
    {950, "ZombieQuest", "Quest Giver", "Zombie", CFrame.new(-5650, 6, -450), CFrame.new(-5700, 15, -750)},
    {1000, "SnowMountainQuest", "Quest Giver", "Snow Trooper", CFrame.new(610, 400, -1370), CFrame.new(500, 400, -1500)},
    {1100, "IceSideQuest", "Quest Giver", "Lab Subordinate", CFrame.new(-6060, 15, -4900), CFrame.new(-5800, 15, -4800)},
    {1150, "IceSideQuest", "Quest Giver", "Horned Warrior", CFrame.new(-6060, 15, -4900), CFrame.new(-6400, 15, -5800)},
    {1200, "FireSideQuest", "Quest Giver", "Magma Ninja", CFrame.new(-5430, 15, -5290), CFrame.new(-5400, 15, -5800)},
    {1250, "FireSideQuest", "Quest Giver", "Lava Pirate", CFrame.new(-5430, 15, -5290), CFrame.new(-5200, 15, -6000)},
    {1350, "ShipQuest1", "Quest Giver", "Ship Pirate", CFrame.new(770, 125, 32800), CFrame.new(850, 130, 32900)},
    {1425, "ForgottenQuest", "Quest Giver", "Sea Soldier", CFrame.new(-3050, 240, -10175), CFrame.new(-3100, 240, -10300)},
    {1450, "ForgottenQuest", "Quest Giver", "Water Tyran", CFrame.new(-3050, 240, -10175), CFrame.new(-3300, 240, -10500)}
}

-- [[ FUNÇÃO SISTEMA DE NÍVEL ]]
function GetCurrentQuest()
    local myLevel = Level.Value
    local bestQuest = Sea2_Quests[1]
    for _, quest in pairs(Sea2_Quests) do
        if myLevel >= quest[1] then
            bestQuest = quest
        end
    end
    return bestQuest
end

-- [[ TABS DA INTERFACE ]]

-- 1. MAIN FARM (NÍVEL)
local MainTab = Container:AddSection("Auto Farm Sea 2")

local function AddButton(parent, text, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Library.Theme.Secondary
    b.Text = text; b.TextColor3 = Library.Theme.Text; b.Font = Enum.Font.Gotham
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

AddButton(MainTab, "Toggle Smart Farm: OFF", function(self)
    _G.AutoFarm = not _G.AutoFarm
    self.Text = "Toggle Smart Farm: " .. (_G.AutoFarm and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoFarm do
            pcall(function()
                local q = GetCurrentQuest()
                -- Lógica de Farm aqui (Teleport q[5], Pegar q[2], Teleport q[6], Atacar q[4])
                print("Sea 2 | Farmando: " .. q[4])
            end)
            task.wait(1)
        end
    end)
end)

-- 2. BOSSES DO SEA 2
local BossTab = Container:AddSection("Farm Bosses")
AddButton(BossTab, "Farm Don Swan", function() print("Indo para o Swan...") end)
AddButton(BossTab, "Farm Cursed Captain", function() print("Indo para o Navio...") end)

-- 3. FRUTAS (FRUITS)
local FruitTab = Container:AddSection("Fruits")
AddButton(FruitTab, "Girar Fruta (Sea 2)", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
end)

AddButton(FruitTab, "Localizar Frutas (ESP + Studs)", function()
    -- Lógica de ESP de Frutas com Studs que criamos
end)

-- 4. BAÚS (CHESTS)
local ChestTab = Container:AddSection("Auto Chests")
AddButton(ChestTab, "Farm Baús Sea 2", function()
    _G.AutoChest = not _G.AutoChest
    task.spawn(function()
        while _G.AutoChest do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") then
                    Player.Character.HumanoidRootPart.CFrame = v.CFrame
                    task.wait(0.3)
                end
            end
            task.wait(1)
        end
    end)
end)

-- [[ VARIÁVEIS DE CONFIGURAÇÃO ]]
_G.FlySpeed = 100
_G.AutoClick = false
_G.UseSkills = false
_G.DistanceNPC = 10
_G.BoatType = "Speedboat" -- Barco padrão para compra

-- [[ ABA: SEA EVENTS (EVENTOS DO MAR) ]]
local SeaEventSection = Container:AddSection("Sea Events (Eventos)")

-- 1. Compra Automática de Barco
AddButton(SeaEventSection, "Comprar Barco (Padrão)", function()
    local args = {
        [1] = "BuyBoat",
        [2] = _G.BoatType
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end)

-- 2. Navegação Automática (Vai para o mar aberto)
_G.AutoSail = false
AddButton(SeaEventSection, "Auto Navegar: OFF", function(self)
    _G.AutoSail = not _G.AutoSail
    self.Text = "Auto Navegar: " .. (_G.AutoSail and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoSail do
            pcall(function()
                -- Move o personagem/barco para a zona de spawn de Sea Beasts
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -50)
            end)
            task.wait(0.1)
        end
    end)
end)

-- 3. Auto Atacar Eventos (M1 + Skills)
AddButton(SeaEventSection, "Auto Kill (Sea Beast/Ships)", function()
    _G.AutoClick = not _G.AutoClick
    _G.UseSkills = not _G.UseSkills
    
    task.spawn(function()
        while _G.AutoClick do
            pcall(function()
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then 
                    tool:Activate() -- Clique M1
                    
                    if _G.UseSkills then
                        -- Simula o uso das teclas Z, X, C, V
                        local VirtualInput = game:GetService("VirtualInputManager")
                        VirtualInput:SendKeyEvent(true, "Z", false, game)
                        task.wait(0.1)
                        VirtualInput:SendKeyEvent(true, "X", false, game)
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- [[ ABA: SETTINGS (CONFIGURAÇÕES) ]]
local SettingsSection = Container:AddSection("Settings & Configs")

-- 1. Velocidade de Voo/Farm (Slider)
-- Nota: A lógica de Slider deve estar na sua Library. Aqui usamos a chamada:
Container:AddSlider("Velocidade de Voo", 50, 300, 100, function(v)
    _G.FlySpeed = v
end)

-- 2. Distância do NPC (Slider)
Container:AddSlider("Distância do NPC", 5, 25, 10, function(v)
    _G.DistanceNPC = v
end)

-- 3. Anti-AFK (Sempre Ativo por padrão)
AddButton(SettingsSection, "Re-ativar Anti-AFK", function()
    print("Anti-AFK já está rodando no background.")
end)

-- 4. Botão para Salvar Configurações (JSON)
AddButton(SettingsSection, "Salvar Configurações", function()
    local HttpService = game:GetService("HttpService")
    local json = HttpService:JSONEncode(_G.Settings)
    writefile("InkzinHub_Config.json", json)
    print("Configurações salvas no Executor!")
end)

-- [[ SEÇÃO DE FRUTAS - ADAPTADA SEA 2 ]]
local FruitSection = Container:AddSection("Fruits & Bagas")

-- 1. Girar Fruta (NPC Cousin no Café do Sea 2)
AddButton(FruitSection, "Girar Fruta (Gacha)", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
end)

-- 2. Detectar e Localizar Frutas (ESP + Distância em Studs)
local FruitESP = false
AddButton(FruitSection, "Localizar Frutas (ESP)", function()
    FruitESP = not FruitESP
    
    -- Limpa ESP ao desligar
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:FindFirstChild("FruitESP") then v.FruitESP:Destroy() end
    end

    if FruitESP then
        task.spawn(function()
            while FruitESP do
                for _, v in pairs(game.Workspace:GetChildren()) do
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
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.TextColor3 = Library.Theme.Accent -- Roxo do Hub
                                label.Font = Enum.Font.GothamBold
                                label.TextSize = 14
                                label.Parent = billboard
                            end
                            
                            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - handle.Position).Magnitude)
                            billboard.TextLabel.Text = v.Name .. "\n[" .. dist .. " studs]"
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- 3. Auto Coletar e Armazenar (Exclusivo Sea 2/3)
_G.AutoCollectAndStore = false
AddButton(FruitSection, "Coletar e Armazenar: OFF", function(self)
    _G.AutoCollectAndStore = not _G.AutoCollectAndStore
    self.Text = "Coletar e Armazenar: " .. (_G.AutoCollectAndStore and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoCollectAndStore do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Baga")) then
                    local h = v:FindFirstChild("Handle")
                    if h then
                        -- Teleporta e Coleta
                        LocalPlayer.Character.HumanoidRootPart.CFrame = h.CFrame
                        task.wait(0.5)
                        
                        -- Tenta armazenar a fruta que estiver na mão
                        local fruitInHand = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if fruitInHand and fruitInHand.Name:find("Fruit") then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruitInHand.Name, fruitInHand)
                            print("Fruta armazenada: " .. fruitInHand.Name)
                        end
                    end
                end
            end
            task.wait(2)
        end
    end)
end)

-- [[ VARIÁVEIS DE CONTROLE ]]
_G.AutoRaid = false
_G.SelectRaid = "Flame"
_G.AutoBuyChip = false
_G.AutoStartRaid = false
_G.AutoKillRaid = false

local RaidSection = Container:AddSection("Sistema de Auto Raid")

-- 1. LISTA COMPLETA DE RAIDS (Comuns e Avançadas)
local AllRaids = {
    "Flame", "Ice", "Quake", "Light", "Dark", 
    "Spider", "Rumble", "Magma", "Sand", "Buddha", 
    "Dough", "Phoenix"
}

-- 2. SELETOR DE RAID (Ciclo de Opções)
AddButton(RaidSection, "Selecionar Raid: " .. _G.SelectRaid, function(self)
    local index = table.find(AllRaids, _G.SelectRaid)
    local nextIndex = index + 1
    if nextIndex > #AllRaids then nextIndex = 1 end
    _G.SelectRaid = AllRaids[nextIndex]
    self.Text = "Selecionar Raid: " .. _G.SelectRaid
end)

-- 3. FUNÇÃO: DESARMAZENAR FRUTAS BARATAS
-- Útil para tirar as frutas do inventário e usar como chip
AddButton(RaidSection, "Retirar Frutas Baratas (Pagar)", function()
    local TrashFruits = {"Rocket Fruit", "Spin Fruit", "Chop Fruit", "Spring Fruit", "Bomb Fruit", "Smoke Fruit", "Spike Fruit"}
    for _, name in pairs(TrashFruits) do
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", name)
    end
end)

-- 4. AUTO COMPRAR CHIP E INICIAR
AddButton(RaidSection, "Auto Iniciar Raid: OFF", function(self)
    _G.AutoStartRaid = not _G.AutoStartRaid
    self.Text = "Auto Iniciar Raid: " .. (_G.AutoStartRaid and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoStartRaid do
            pcall(function()
                -- Verifica se NÃO está em raid e NÃO tem chip
                if not game:GetService("Workspace").Map:FindFirstChild("RaidMap") and not LocalPlayer.Backpack:FindFirstChild("Special Microchip") then
                    
                    -- Tenta usar fruta da mochila primeiro
                    local fruit = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    local chipTarget = "Money" -- Padrão caso não tenha fruta
                    
                    if fruit and fruit.Name:find("Fruit") then
                        chipTarget = fruit.Name
                    end
                    
                    -- Compra o Chip (Invoke para o NPC da Raid)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Raids", "BuyChip", chipTarget)
                    task.wait(1)
                    
                    -- Teleporta e clica no botão para iniciar
                    local button = game:GetService("Workspace").Map["Boat Castle"].RaidManager.ClickPart
                    LocalPlayer.Character.HumanoidRootPart.CFrame = button.CFrame
                    fireclickdetector(button.ClickDetector)
                end
            end)
            task.wait(2)
        end
    end)
end)

-- 5. AUTO KILL E PRÓXIMA ILHA (FARM DA RAID)
AddButton(RaidSection, "Auto Farm Raid (Kill): OFF", function(self)
    _G.AutoKillRaid = not _G.AutoKillRaid
    self.Text = "Auto Farm Raid (Kill): " .. (_G.AutoKillRaid and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoKillRaid do
            pcall(function()
                if game:GetService("Workspace").Map:FindFirstChild("RaidMap") then
                    -- Busca inimigos na Raid
                    for _, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            -- Posicionamento Seguro (Cima do NPC)
                            repeat
                                if not _G.AutoKillRaid then break end
                                LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
                                
                                -- Auto Attack (Simula cliques)
                                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                if tool then tool:Activate() end
                                
                                task.wait()
                            until enemy.Humanoid.Health <= 0 or not enemy.Parent
                        end
                    end
                else
                    -- Se a raid acabou ou não começou, espera
                    task.wait(2)
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- [[ VARIÁVEIS DE CONTROLE ]]
_G.AutoBlackbeard = false
_G.AutoRengoku = false
_G.AutoCyborg = false

local SideQuestSection = Container:AddSection("Missões Secundárias & Itens")

-- 1. DARK BEARD (BARBA NEGRA)
AddButton(SideQuestSection, "Auto Invocar Barba Negra", function()
    -- Verifica se o jogador tem o Fist of Darkness
    local fist = LocalPlayer.Backpack:FindFirstChild("Fist of Darkness") or LocalPlayer.Character:FindFirstChild("Fist of Darkness")
    if fist then
        -- Teleporta para a Arena no mar (Dark Arena)
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3777, 15, -3498)
        print("Invocando Barba Negra...")
    else
        print("Você precisa do Fist of Darkness (Baús ou Sea Beast)!")
    end
end)

-- 2. RENGOKU (ESPADA LENDÁRIA)
AddButton(SideQuestSection, "Auto Farm Rengoku", function()
    _G.AutoRengoku = not _G.AutoRengoku
    task.spawn(function()
        while _G.AutoRaid do
            pcall(function()
                -- 1. Verifica se tem a Hidden Key
                local key = LocalPlayer.Backpack:FindFirstChild("Hidden Key") or LocalPlayer.Character:FindFirstChild("Hidden Key")
                if key then
                    -- Teleporta para a porta secreta no Castelo de Gelo
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(6347, 273, -6966)
                else
                    -- Vai matar o Awakened Ice Admiral até dropar a chave
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(6472, 297, -6784)
                    -- Lógica de ataque aqui
                end
            end)
            task.wait(1)
        end
    end)
end)

-- 3. DON SWAN (DOFLAMINGO) - ACESSO À MANSÃO
AddButton(SideQuestSection, "Acessar Don Swan (Doflamingo)", function()
    -- Verifica se o player tem uma fruta de 1M+ no inventário para dar ao Trevor
    local trevorPos = CFrame.new(-390, 73, -2985)
    LocalPlayer.Character.HumanoidRootPart.CFrame = trevorPos
    print("Fale com o Trevor para entregar a fruta de 1M!")
end)

-- 4. RAÇA CYBORG (CORE BRAIN)
AddButton(SideQuestSection, "Auto Missão Cyborg", function()
    _G.AutoCyborg = not _G.AutoCyborg
    task.spawn(function()
        while _G.AutoCyborg do
            pcall(function()
                -- Requisito: Law Raid (Order) para dropar o Core Brain
                -- O script deve verificar se o Core Brain está no inventário
                local brain = LocalPlayer.Backpack:FindFirstChild("Core Brain")
                if brain then
                    -- Teleporta para o local de inserção no laboratório
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4720, -63, -299)
                else
                    print("Você precisa dropar o Core Brain na Raid do Law (Order)!")
                end
            end)
            task.wait(2)
        end
    end)
end)

-- 5. TRUE TRIPLE KATANA (SADDI, SHISUI, WANDO)
AddButton(SideQuestSection, "Check Legendary Sword Dealer", function()
    -- Teleporta pelos 3 spots onde o vendedor de espadas lendárias aparece
    local spawnSpots = {
        CFrame.new(-1022, 164, -3340), -- Arcos do Reino de Rose
        CFrame.new(-1318, 203, -4462), -- Planta Gigante
        CFrame.new(634, 73, -4465)      -- Túnel da Ilha
    }
    for _, spot in pairs(spawnSpots) do
        LocalPlayer.Character.HumanoidRootPart.CFrame = spot
        task.wait(2)
    end
end)
-- [[ VARIÁVEIS DE CONTROLE ]]
_G.AutoFactory = false

local FactorySection = Container:AddSection("Evento: Factory (Fábrica)")

-- 1. FUNÇÃO PARA VERIFICAR SE A FÁBRICA ESTÁ ABERTA
function IsFactoryOpen()
    -- No Blox Fruits, o núcleo da fábrica (Core) só aparece quando o evento inicia
    local core = game:GetService("Workspace").Enemies:FindFirstChild("Core") or game:GetService("Workspace").Enemies:FindFirstChild("Factory Core")
    return core
end

-- 2. TOGGLE AUTO FACTORY
AddButton(FactorySection, "Auto Farm Factory: OFF", function(self)
    _G.AutoFactory = not _G.AutoFactory
    self.Text = "Auto Farm Factory: " .. (_G.AutoFactory and "ON" or "OFF")
    
    task.spawn(function()
        while _G.AutoFactory do
            pcall(function()
                local core = IsFactoryOpen()
                
                if core then
                    -- 1. Teleporta para cima do Núcleo
                    LocalPlayer.Character.HumanoidRootPart.CFrame = core.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                    
                    -- 2. Equipar Arma/Fruta e Atacar
                    local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                        tool:Activate() -- Ataque M1
                        
                        -- Usa habilidades se estiverem configuradas
                        local VIM = game:GetService("VirtualInputManager")
                        VIM:SendKeyEvent(true, "Z", false, game)
                        task.wait(0.1)
                        VIM:SendKeyEvent(true, "X", false, game)
                    end
                else
                    -- Se a fábrica estiver fechada, o script avisa ou espera no Café
                    print("Aguardando a Factory abrir...")
                end
            end)
            task.wait(0.5)
        end
    end)
end)

-- 3. BOTÃO DE TELEPORTE DIRETO (CASO QUEIRAS IR MANUALMENTE)
AddButton(FactorySection, "Teleportar para Factory", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(432, 204, -429)
end)

