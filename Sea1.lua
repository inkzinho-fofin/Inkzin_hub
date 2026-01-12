local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local FlowLib = {}

-- [CONFIGURAÇÃO DE TEMAS]
local Themes = {
	Black = {Main = Color3.fromRGB(10, 10, 10), Sec = Color3.fromRGB(20, 20, 20), Accent = Color3.fromRGB(255, 255, 255)},
	DarkPurple = {Main = Color3.fromRGB(15, 5, 30), Sec = Color3.fromRGB(25, 10, 50), Accent = Color3.fromRGB(140, 70, 255)},
	LightPurple = {Main = Color3.fromRGB(40, 25, 65), Sec = Color3.fromRGB(55, 35, 85), Accent = Color3.fromRGB(210, 180, 255)}
}

function FlowLib:Init(themeName)
	local theme = Themes[themeName] or Themes.DarkPurple
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "flow_blox_fruits"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	-- [ORBE CYBERPUNK ARRASTÁVEL]
	local OpenBtn = Instance.new("TextButton")
	OpenBtn.Size = UDim2.new(0, 50, 0, 50)
	OpenBtn.Position = UDim2.new(0, 20, 0, 100)
	OpenBtn.BackgroundColor3 = theme.Main
	OpenBtn.Text = "F"
	OpenBtn.TextColor3 = theme.Accent
	OpenBtn.Font = Enum.Font.GothamBold
	OpenBtn.TextSize = 22
	OpenBtn.Parent = ScreenGui
	Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
	local Stroke = Instance.new("UIStroke", OpenBtn)
	Stroke.Color = theme.Accent
	Stroke.Thickness = 2

	-- [JANELA PRINCIPAL]
	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 550, 0, 350)
	Main.Position = UDim2.new(0.5, -275, 0.5, -175)
	Main.BackgroundColor3 = theme.Main
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Parent = ScreenGui
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

	-- [HEADER ARRASTÁVEL]
	local Header = Instance.new("Frame")
	Header.Size = UDim2.new(1, 0, 0, 40)
	Header.BackgroundColor3 = theme.Sec
	Header.Parent = Main
	Instance.new("UICorner", Header)

	local Title = Instance.new("TextLabel")
	Title.Text = "  FLOW_BLOX_FRUITS"
	Title.Size = UDim2.new(0.5, 0, 1, 0)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = theme.Accent
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Header

	local Credits = Instance.new("TextLabel")
	Credits.Text = "by Hatsune_inkyt"
	Credits.Size = UDim2.new(0, 120, 1, 0)
	Credits.Position = UDim2.new(1, -160, 0, 0)
	Credits.BackgroundTransparency = 1
	Credits.TextColor3 = theme.Accent
	Credits.TextTransparency = 0.5
	Credits.Font = Enum.Font.Gotham
	Credits.TextSize = 12
	Credits.Parent = Header

	local BreakBtn = Instance.new("TextButton")
	BreakBtn.Size = UDim2.new(0, 35, 0, 35)
	BreakBtn.Position = UDim2.new(1, -40, 0, 2)
	BreakBtn.BackgroundTransparency = 1
	BreakBtn.Text = "✕"
	BreakBtn.TextColor3 = theme.Accent
	BreakBtn.Font = Enum.Font.GothamBold
	BreakBtn.TextSize = 20
	BreakBtn.Parent = Header

	-- [CONTAINERS DE ABAS]
	local Sidebar = Instance.new("ScrollingFrame")
	Sidebar.Size = UDim2.new(0, 130, 1, -50)
	Sidebar.Position = UDim2.new(0, 10, 0, 45)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ScrollBarThickness = 0
	Sidebar.Parent = Main
	Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

	local ContentHolder = Instance.new("Frame")
	ContentHolder.Size = UDim2.new(1, -160, 1, -55)
	ContentHolder.Position = UDim2.new(0, 150, 0, 45)
	ContentHolder.BackgroundColor3 = theme.Sec
	ContentHolder.Parent = Main
	Instance.new("UICorner", ContentHolder)

	-----------------------------------------------------------
	-- FUNÇÕES DE ARRASTE (DRAG)
	-----------------------------------------------------------
	local function MakeDraggable(obj, dragPart)
		local dragging, dragInput, dragStart, startPos
		dragPart.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = obj.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end

	MakeDraggable(Main, Header)
	MakeDraggable(OpenBtn, OpenBtn)

	-----------------------------------------------------------
	-- SISTEMA DE ABAS E COMPONENTES
	-----------------------------------------------------------
	local Tabs = {}
	local firstTab = true

	function FlowLib:AddTab(name)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, 0, 0, 35)
		TabBtn.BackgroundColor3 = theme.Main
		TabBtn.Text = name
		TabBtn.TextColor3 = theme.Accent
		TabBtn.Font = Enum.Font.GothamSemibold
		TabBtn.TextSize = 12
		TabBtn.Parent = Sidebar
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
		local bStroke = Instance.new("UIStroke", TabBtn)
		bStroke.Color = theme.Accent
		bStroke.Thickness = 1
		bStroke.Transparency = 0.8

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, -10, 1, -10)
		Page.Position = UDim2.new(0, 5, 0, 5)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 2
		Page.ScrollBarImageColor3 = theme.Accent
		Page.Parent = ContentHolder
		Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)

		if firstTab then
			Page.Visible = true
			bStroke.Transparency = 0
			firstTab = false
		end

		TabBtn.MouseButton1Click:Connect(function()
			for _, v in pairs(ContentHolder:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
			for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.UIStroke.Transparency = 0.8 end end
			Page.Visible = true
			bStroke.Transparency = 0
		end)

		local Components = {}

		function Components:AddToggle(text, callback)
			local Toggle = Instance.new("TextButton")
			Toggle.Size = UDim2.new(1, 0, 0, 35)
			Toggle.BackgroundColor3 = theme.Main
			Toggle.Text = "  " .. text
			Toggle.TextColor3 = theme.Accent
			Toggle.Font = Enum.Font.Gotham
			Toggle.TextSize = 13
			Toggle.TextXAlignment = Enum.TextXAlignment.Left
			Toggle.Parent = Page
			Instance.new("UICorner", Toggle)
			
			local Indicator = Instance.new("Frame")
			Indicator.Size = UDim2.new(0, 20, 0, 20)
			Indicator.Position = UDim2.new(1, -25, 0.5, -10)
			Indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Indicator.Parent = Toggle
			Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

			local state = false
			Toggle.MouseButton1Click:Connect(function()
				state = not state
				local color = state and theme.Accent or Color3.fromRGB(50, 50, 50)
				TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
				callback(state)
			end)
		end

		return Components
	end

	-----------------------------------------------------------
	-- ANIMAÇÕES E FECHAMENTO
	-----------------------------------------------------------
	task.spawn(function()
		while task.wait(1.5) do
			if OpenBtn.Parent then
				TweenService:Create(OpenBtn, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 55, 0, 55)}):Play()
				task.wait(1.5)
				TweenService:Create(OpenBtn, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 50, 0, 50)}):Play()
			end
		end
	end)

	OpenBtn.MouseButton1Click:Connect(function()
		Main.Visible = not Main.Visible
	end)

	BreakBtn.MouseButton1Click:Connect(function()
		local t = TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Position = Main.Position + UDim2.new(0, 0, 1, 50),
			Rotation = math.random(-20, 20),
			BackgroundTransparency = 1
		})
		t:Play()
		TweenService:Create(OpenBtn, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
		t.Completed:Connect(function() ScreenGui:Destroy() end)
	end)

	return FlowLib
end

-- [EXECUÇÃO E CRIAÇÃO DAS ABAS]
local MyUI = FlowLib:Init("DarkPurple")

local Farm = MyUI:AddTab("Farm")
local Config = MyUI:AddTab("config")
local Especial = MyUI:AddTab("especial")
local Fruits = MyUI:AddTab("fruits")
local SeaEvents = MyUI:AddTab("Sea events")
local Raids = MyUI:AddTab("raids")

-- Exemplo de como adicionar um Toggle:
Farm:AddToggle("Auto Farm Level", function(s)
	print("Auto Farm: ", s)
end)



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
