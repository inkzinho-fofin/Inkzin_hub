local Config = {
    BoxESP = true,
    BoxColor = Color3.fromRGB(255, 255, 255),
    TeamColor = true,
    BoxOutline = true,
    
    NameESP = true,
    DistanceESP = true,
    HealthESP = true,
    SkeletonESP = true,
    
    TeamCheck = true,
    AllyColor = Color3.fromRGB(0, 255, 140),
    EnemyColor = Color3.fromRGB(255, 25, 25),
    
    BoxTrans = 0.7,
    TextTrans = 0.7,
    
    MaxDistance = 1000,
    TextSize = 16
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ESPObjects = {}
local SkeletonConnections = {}
local TargetPlayer = nil
local GetPlayers = Players.GetPlayers
local WorldToViewportPoint = Camera.WorldToViewportPoint

local function CreateDrawing(type, props)
    local obj = nil
    pcall(function()
        obj = Drawing.new(type)
        for i,v in pairs(props) do
            obj[i] = v
        end
    end)
    return obj
end

local function IsAlive(plr)
    local success, result = pcall(function()
        return plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0
    end)
    return success and result or false
end

local function GetTeamColor(plr)
    if Config.TeamColor and plr.Team and plr.Team.TeamColor then
        return plr.Team.TeamColor.Color
    elseif Config.TeamCheck then
        return plr.Team == LocalPlayer.Team and Config.AllyColor or Config.EnemyColor
    else
        return Config.BoxColor
    end
end

local function GetBoxSize(plr)
    local success, boxSize, boxPos = pcall(function()
        local char = plr.Character
        local hrp = char.HumanoidRootPart
        local head = char.Head
        
        local rootPos, rootVis = WorldToViewportPoint(Camera, hrp.Position)
        if not rootVis then return Vector2.new(), Vector2.new(), false end
        
        local headPos = WorldToViewportPoint(Camera, head.Position + Vector3.new(0, 0.5, 0))
        local legPos = WorldToViewportPoint(Camera, hrp.Position - Vector3.new(0, 3, 0))
        
        local boxSize = Vector2.new(math.abs(headPos.Y - legPos.Y) * 0.6, math.abs(headPos.Y - legPos.Y))
        local boxPos = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y - boxSize.Y / 2)
        
        return boxSize, boxPos, true
    end)
    
    if success then
        return boxSize, boxPos, true
    else
        return Vector2.new(), Vector2.new(), false
    end
end

local function GetDistance(pos)
    local success, dist = pcall(function()
        return (Camera.CFrame.Position - pos).Magnitude
    end)
    return success and math.floor(dist) or 0
end

local function GetLimbPositions(char, rigType)
    local limbs = {}
    
    pcall(function()
        if rigType == "R6" then
            local head = WorldToViewportPoint(Camera, char.Head.Position)
            local torso = WorldToViewportPoint(Camera, char.Torso.Position)
            local leftArm = WorldToViewportPoint(Camera, char["Left Arm"].Position)
            local rightArm = WorldToViewportPoint(Camera, char["Right Arm"].Position)
            local leftLeg = WorldToViewportPoint(Camera, char["Left Leg"].Position)
            local rightLeg = WorldToViewportPoint(Camera, char["Right Leg"].Position)
            
            limbs = {
                Head = Vector2.new(head.X, head.Y),
                Torso = Vector2.new(torso.X, torso.Y),
                LeftArm = Vector2.new(leftArm.X, leftArm.Y),
                RightArm = Vector2.new(rightArm.X, rightArm.Y),
                LeftLeg = Vector2.new(leftLeg.X, leftLeg.Y),
                RightLeg = Vector2.new(rightLeg.X, rightLeg.Y)
            }
        else -- R15 or other
            local head = char:FindFirstChild("Head") and WorldToViewportPoint(Camera, char.Head.Position)
            local upperTorso = char:FindFirstChild("UpperTorso") and WorldToViewportPoint(Camera, char.UpperTorso.Position)
            local lowerTorso = char:FindFirstChild("LowerTorso") and WorldToViewportPoint(Camera, char.LowerTorso.Position)
            local leftUpperArm = char:FindFirstChild("LeftUpperArm") and WorldToViewportPoint(Camera, char.LeftUpperArm.Position)
            local rightUpperArm = char:FindFirstChild("RightUpperArm") and WorldToViewportPoint(Camera, char.RightUpperArm.Position)
            local leftLowerArm = char:FindFirstChild("LeftLowerArm") and WorldToViewportPoint(Camera, char.LeftLowerArm.Position)
            local rightLowerArm = char:FindFirstChild("RightLowerArm") and WorldToViewportPoint(Camera, char.RightLowerArm.Position)
            local leftHand = char:FindFirstChild("LeftHand") and WorldToViewportPoint(Camera, char.LeftHand.Position)
            local rightHand = char:FindFirstChild("RightHand") and WorldToViewportPoint(Camera, char.RightHand.Position)
            local leftUpperLeg = char:FindFirstChild("LeftUpperLeg") and WorldToViewportPoint(Camera, char.LeftUpperLeg.Position)
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg") and WorldToViewportPoint(Camera, char.RightUpperLeg.Position)
            local leftLowerLeg = char:FindFirstChild("LeftLowerLeg") and WorldToViewportPoint(Camera, char.LeftLowerLeg.Position)
            local rightLowerLeg = char:FindFirstChild("RightLowerLeg") and WorldToViewportPoint(Camera, char.RightLowerLeg.Position)
            local leftFoot = char:FindFirstChild("LeftFoot") and WorldToViewportPoint(Camera, char.LeftFoot.Position)
            local rightFoot = char:FindFirstChild("RightFoot") and WorldToViewportPoint(Camera, char.RightFoot.Position)
            
            limbs = {
                Head = head and Vector2.new(head.X, head.Y),
                UpperTorso = upperTorso and Vector2.new(upperTorso.X, upperTorso.Y),
                LowerTorso = lowerTorso and Vector2.new(lowerTorso.X, lowerTorso.Y),
                LeftUpperArm = leftUpperArm and Vector2.new(leftUpperArm.X, leftUpperArm.Y),
                RightUpperArm = rightUpperArm and Vector2.new(rightUpperArm.X, rightUpperArm.Y),
                LeftLowerArm = leftLowerArm and Vector2.new(leftLowerArm.X, leftLowerArm.Y),
                RightLowerArm = rightLowerArm and Vector2.new(rightLowerArm.X, rightLowerArm.Y),
                LeftHand = leftHand and Vector2.new(leftHand.X, leftHand.Y),
                RightHand = rightHand and Vector2.new(rightHand.X, rightHand.Y),
                LeftUpperLeg = leftUpperLeg and Vector2.new(leftUpperLeg.X, leftUpperLeg.Y),
                RightUpperLeg = rightUpperLeg and Vector2.new(rightUpperLeg.X, rightUpperLeg.Y),
                LeftLowerLeg = leftLowerLeg and Vector2.new(leftLowerLeg.X, leftLowerLeg.Y),
                RightLowerLeg = rightLowerLeg and Vector2.new(rightLowerLeg.X, rightLowerLeg.Y),
                LeftFoot = leftFoot and Vector2.new(leftFoot.X, leftFoot.Y),
                RightFoot = rightFoot and Vector2.new(rightFoot.X, rightFoot.Y)
            }
        end
    end)
    
    return limbs
end

local function CreateLine()
    return CreateDrawing("Line", {
        Visible = false,
        Thickness = 1.5,
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = Config.BoxTrans
    })
end

local function CreatePlayerESP(plr)
    local esp = {
        Name = plr.Name,
        Player = plr,
        Box = CreateDrawing("Square", {
            Thickness = 1,
            Filled = false,
            Transparency = Config.BoxTrans,
            Color = Config.BoxColor,
            Visible = false
        }),
        BoxOutline = CreateDrawing("Square", {
            Thickness = 3,
            Filled = false,
            Transparency = Config.BoxTrans,
            Color = Color3.fromRGB(0, 0, 0),
            Visible = false
        }),
        Name = CreateDrawing("Text", {
            Text = plr.Name,
            Size = Config.TextSize,
            Center = true,
            Outline = true,
            OutlineColor = Color3.fromRGB(0, 0, 0),
            Color = Config.BoxColor,
            Transparency = Config.TextTrans,
            Visible = false
        }),
        Distance = CreateDrawing("Text", {
            Size = Config.TextSize - 2,
            Center = true,
            Outline = true,
            OutlineColor = Color3.fromRGB(0, 0, 0),
            Color = Color3.fromRGB(175, 175, 175),
            Transparency = Config.TextTrans,
            Visible = false
        }),
        HealthBar = CreateDrawing("Square", {
            Thickness = 1,
            Filled = true,
            Transparency = Config.BoxTrans + 0.2,
            Color = Color3.fromRGB(0, 255, 0),
            Visible = false
        }),
        HealthBarBG = CreateDrawing("Square", {
            Thickness = 1,
            Filled = true,
            Transparency = Config.BoxTrans - 0.2,
            Color = Color3.fromRGB(40, 40, 40),
            Visible = false
        }),
        Skeleton = {
            Head = {
                UpperTorso = CreateLine()
            },
            UpperTorso = {
                LowerTorso = CreateLine(),
                LeftUpperArm = CreateLine(),
                RightUpperArm = CreateLine()
            },
            LowerTorso = {
                LeftUpperLeg = CreateLine(),
                RightUpperLeg = CreateLine()
            },
            LeftUpperArm = {
                LeftLowerArm = CreateLine()
            },
            RightUpperArm = {
                RightLowerArm = CreateLine()
            },
            LeftLowerArm = {
                LeftHand = CreateLine()
            },
            RightLowerArm = {
                RightHand = CreateLine()
            },
            LeftUpperLeg = {
                LeftLowerLeg = CreateLine()
            },
            RightUpperLeg = {
                RightLowerLeg = CreateLine()
            },
            LeftLowerLeg = {
                LeftFoot = CreateLine()
            },
            RightLowerLeg = {
                RightFoot = CreateLine()
            }
        },
        SkeletonR6 = {
            Head = {
                Torso = CreateLine()
            },
            Torso = {
                LeftArm = CreateLine(),
                RightArm = CreateLine(),
                LeftLeg = CreateLine(),
                RightLeg = CreateLine()
            }
        }
    }
    
    ESPObjects[plr] = esp
    return esp
end

local function UpdateSkeleton(esp, limbs, color, transparency, visible, isR6)
    pcall(function()
        if isR6 then
            if limbs.Head and limbs.Torso then
                esp.SkeletonR6.Head.Torso.From = limbs.Head
                esp.SkeletonR6.Head.Torso.To = limbs.Torso
                esp.SkeletonR6.Head.Torso.Color = color
                esp.SkeletonR6.Head.Torso.Transparency = transparency
                esp.SkeletonR6.Head.Torso.Visible = visible
            end
            
            if limbs.Torso then
                if limbs.LeftArm then
                    esp.SkeletonR6.Torso.LeftArm.From = limbs.Torso
                    esp.SkeletonR6.Torso.LeftArm.To = limbs.LeftArm
                    esp.SkeletonR6.Torso.LeftArm.Color = color
                    esp.SkeletonR6.Torso.LeftArm.Transparency = transparency
                    esp.SkeletonR6.Torso.LeftArm.Visible = visible
                end
                
                if limbs.RightArm then
                    esp.SkeletonR6.Torso.RightArm.From = limbs.Torso
                    esp.SkeletonR6.Torso.RightArm.To = limbs.RightArm
                    esp.SkeletonR6.Torso.RightArm.Color = color
                    esp.SkeletonR6.Torso.RightArm.Transparency = transparency
                    esp.SkeletonR6.Torso.RightArm.Visible = visible
                end
                
                if limbs.LeftLeg then
                    esp.SkeletonR6.Torso.LeftLeg.From = limbs.Torso
                    esp.SkeletonR6.Torso.LeftLeg.To = limbs.LeftLeg
                    esp.SkeletonR6.Torso.LeftLeg.Color = color
                    esp.SkeletonR6.Torso.LeftLeg.Transparency = transparency
                    esp.SkeletonR6.Torso.LeftLeg.Visible = visible
                end
                
                if limbs.RightLeg then
                    esp.SkeletonR6.Torso.RightLeg.From = limbs.Torso
                    esp.SkeletonR6.Torso.RightLeg.To = limbs.RightLeg
                    esp.SkeletonR6.Torso.RightLeg.Color = color
                    esp.SkeletonR6.Torso.RightLeg.Transparency = transparency
                    esp.SkeletonR6.Torso.RightLeg.Visible = visible
                end
            end
        else
            if limbs.Head and limbs.UpperTorso then
                esp.Skeleton.Head.UpperTorso.From = limbs.Head
                esp.Skeleton.Head.UpperTorso.To = limbs.UpperTorso
                esp.Skeleton.Head.UpperTorso.Color = color
                esp.Skeleton.Head.UpperTorso.Transparency = transparency
                esp.Skeleton.Head.UpperTorso.Visible = visible
            end
            
            if limbs.UpperTorso then
                if limbs.LowerTorso then
                    esp.Skeleton.UpperTorso.LowerTorso.From = limbs.UpperTorso
                    esp.Skeleton.UpperTorso.LowerTorso.To = limbs.LowerTorso
                    esp.Skeleton.UpperTorso.LowerTorso.Color = color
                    esp.Skeleton.UpperTorso.LowerTorso.Transparency = transparency
                    esp.Skeleton.UpperTorso.LowerTorso.Visible = visible
                end
                
                if limbs.LeftUpperArm then
                    esp.Skeleton.UpperTorso.LeftUpperArm.From = limbs.UpperTorso
                    esp.Skeleton.UpperTorso.LeftUpperArm.To = limbs.LeftUpperArm
                    esp.Skeleton.UpperTorso.LeftUpperArm.Color = color
                    esp.Skeleton.UpperTorso.LeftUpperArm.Transparency = transparency
                    esp.Skeleton.UpperTorso.LeftUpperArm.Visible = visible
                end
                
                if limbs.RightUpperArm then
                    esp.Skeleton.UpperTorso.RightUpperArm.From = limbs.UpperTorso
                    esp.Skeleton.UpperTorso.RightUpperArm.To = limbs.RightUpperArm
                    esp.Skeleton.UpperTorso.RightUpperArm.Color = color
                    esp.Skeleton.UpperTorso.RightUpperArm.Transparency = transparency
                    esp.Skeleton.UpperTorso.RightUpperArm.Visible = visible
                end
            end
            
            if limbs.LowerTorso then
                if limbs.LeftUpperLeg then
                    esp.Skeleton.LowerTorso.LeftUpperLeg.From = limbs.LowerTorso
                    esp.Skeleton.LowerTorso.LeftUpperLeg.To = limbs.LeftUpperLeg
                    esp.Skeleton.LowerTorso.LeftUpperLeg.Color = color
                    esp.Skeleton.LowerTorso.LeftUpperLeg.Transparency = transparency
                    esp.Skeleton.LowerTorso.LeftUpperLeg.Visible = visible
                end
                
                if limbs.RightUpperLeg then
                    esp.Skeleton.LowerTorso.RightUpperLeg.From = limbs.LowerTorso
                    esp.Skeleton.LowerTorso.RightUpperLeg.To = limbs.RightUpperLeg
                    esp.Skeleton.LowerTorso.RightUpperLeg.Color = color
                    esp.Skeleton.LowerTorso.RightUpperLeg.Transparency = transparency
                    esp.Skeleton.LowerTorso.RightUpperLeg.Visible = visible
                end
            end
            
            if limbs.LeftUpperArm and limbs.LeftLowerArm then
                esp.Skeleton.LeftUpperArm.LeftLowerArm.From = limbs.LeftUpperArm
                esp.Skeleton.LeftUpperArm.LeftLowerArm.To = limbs.LeftLowerArm
                esp.Skeleton.LeftUpperArm.LeftLowerArm.Color = color
                esp.Skeleton.LeftUpperArm.LeftLowerArm.Transparency = transparency
                esp.Skeleton.LeftUpperArm.LeftLowerArm.Visible = visible
            end
            
            if limbs.RightUpperArm and limbs.RightLowerArm then
                esp.Skeleton.RightUpperArm.RightLowerArm.From = limbs.RightUpperArm
                esp.Skeleton.RightUpperArm.RightLowerArm.To = limbs.RightLowerArm
                esp.Skeleton.RightUpperArm.RightLowerArm.Color = color
                esp.Skeleton.RightUpperArm.RightLowerArm.Transparency = transparency
                esp.Skeleton.RightUpperArm.RightLowerArm.Visible = visible
            end
            
            if limbs.LeftLowerArm and limbs.LeftHand then
                esp.Skeleton.LeftLowerArm.LeftHand.From = limbs.LeftLowerArm
                esp.Skeleton.LeftLowerArm.LeftHand.To = limbs.LeftHand
                esp.Skeleton.LeftLowerArm.LeftHand.Color = color
                esp.Skeleton.LeftLowerArm.LeftHand.Transparency = transparency
                esp.Skeleton.LeftLowerArm.LeftHand.Visible = visible
            end
            
            if limbs.RightLowerArm and limbs.RightHand then
                esp.Skeleton.RightLowerArm.RightHand.From = limbs.RightLowerArm
                esp.Skeleton.RightLowerArm.RightHand.To = limbs.RightHand
                esp.Skeleton.RightLowerArm.RightHand.Color = color
                esp.Skeleton.RightLowerArm.RightHand.Transparency = transparency
                esp.Skeleton.RightLowerArm.RightHand.Visible = visible
            end
            
            if limbs.LeftUpperLeg and limbs.LeftLowerLeg then
                esp.Skeleton.LeftUpperLeg.LeftLowerLeg.From = limbs.LeftUpperLeg
                esp.Skeleton.LeftUpperLeg.LeftLowerLeg.To = limbs.LeftLowerLeg
                esp.Skeleton.LeftUpperLeg.LeftLowerLeg.Color = color
                esp.Skeleton.LeftUpperLeg.LeftLowerLeg.Transparency = transparency
                esp.Skeleton.LeftUpperLeg.LeftLowerLeg.Visible = visible
            end
            
            if limbs.RightUpperLeg and limbs.RightLowerLeg then
                esp.Skeleton.RightUpperLeg.RightLowerLeg.From = limbs.RightUpperLeg
                esp.Skeleton.RightUpperLeg.RightLowerLeg.To = limbs.RightLowerLeg
                esp.Skeleton.RightUpperLeg.RightLowerLeg.Color = color
                esp.Skeleton.RightUpperLeg.RightLowerLeg.Transparency = transparency
                esp.Skeleton.RightUpperLeg.RightLowerLeg.Visible = visible
            end
            
            if limbs.LeftLowerLeg and limbs.LeftFoot then
                esp.Skeleton.LeftLowerLeg.LeftFoot.From = limbs.LeftLowerLeg
                esp.Skeleton.LeftLowerLeg.LeftFoot.To = limbs.LeftFoot
                esp.Skeleton.LeftLowerLeg.LeftFoot.Color = color
                esp.Skeleton.LeftLowerLeg.LeftFoot.Transparency = transparency
                esp.Skeleton.LeftLowerLeg.LeftFoot.Visible = visible
            end
            
            if limbs.RightLowerLeg and limbs.RightFoot then
                esp.Skeleton.RightLowerLeg.RightFoot.From = limbs.RightLowerLeg
                esp.Skeleton.RightLowerLeg.RightFoot.To = limbs.RightFoot
                esp.Skeleton.RightLowerLeg.RightFoot.Color = color
                esp.Skeleton.RightLowerLeg.RightFoot.Transparency = transparency
                esp.Skeleton.RightLowerLeg.RightFoot.Visible = visible
            end
        end
    end)
end

local function HideSkeleton(esp)
    pcall(function()
        for _, parent in pairs(esp.Skeleton) do
            for _, line in pairs(parent) do
                line.Visible = false
            end
        end
        
        for _, parent in pairs(esp.SkeletonR6) do
            for _, line in pairs(parent) do
                line.Visible = false
            end
        end
    end)
end

local function IsR6(char)
    return char:FindFirstChild("Torso") ~= nil
end

local function UpdateESP()
    for _, plr in ipairs(GetPlayers(Players)) do
        if plr ~= LocalPlayer then
            local esp = ESPObjects[plr] or CreatePlayerESP(plr)
            
            pcall(function()
                if IsAlive(plr) and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local char = plr.Character
                    local hrp = char.HumanoidRootPart
                    local hum = char:FindFirstChild("Humanoid")
                    
                    local pos, vis = WorldToViewportPoint(Camera, hrp.Position)
                    local dist = GetDistance(hrp.Position)
                    
                    if vis and dist <= Config.MaxDistance then
                        local boxSize, boxPos, validBox = GetBoxSize(plr)
                        local teamColor = GetTeamColor(plr)
                        
                        if validBox then
                            if Config.BoxESP then
                                esp.Box.Size = boxSize
                                esp.Box.Position = boxPos
                                esp.Box.Color = teamColor
                                esp.Box.Visible = true
                                
                                if Config.BoxOutline then
                                    esp.BoxOutline.Size = boxSize
                                    esp.BoxOutline.Position = boxPos
                                    esp.BoxOutline.Visible = true
                                else
                                    esp.BoxOutline.Visible = false
                                end
                            else
                                esp.Box.Visible = false
                                esp.BoxOutline.Visible = false
                            end
                            
                            if Config.NameESP then
                                esp.Name.Text = plr.Name
                                esp.Name.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y - 15)
                                esp.Name.Color = teamColor
                                esp.Name.Visible = true
                            else
                                esp.Name.Visible = false
                            end
                            
                            if Config.DistanceESP then
                                esp.Distance.Text = tostring(dist) .. "m"
                                esp.Distance.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 3)
                                esp.Distance.Visible = true
                            else
                                esp.Distance.Visible = false
                            end
                            
                            if Config.HealthESP and hum then
                                local hp = hum.Health / hum.MaxHealth
                                local barSize = Vector2.new(3, boxSize.Y * hp)
                                local barPos = boxPos + Vector2.new(-5, boxSize.Y * (1 - hp))
                                
                                esp.HealthBar.Size = barSize
                                esp.HealthBar.Position = barPos
                                esp.HealthBar.Color = Color3.fromRGB(255 - (255 * hp), (255 * hp), 0)
                                esp.HealthBar.Visible = true
                                
                                esp.HealthBarBG.Size = Vector2.new(3, boxSize.Y)
                                esp.HealthBarBG.Position = Vector2.new(boxPos.X - 5, boxPos.Y)
                                esp.HealthBarBG.Visible = true
                            else
                                esp.HealthBar.Visible = false
                                esp.HealthBarBG.Visible = false
                            end
                            
                            if Config.SkeletonESP then
                                local isR6 = IsR6(char)
                                local limbs = GetLimbPositions(char, isR6 and "R6" or "R15")
                                
                                UpdateSkeleton(esp, limbs, teamColor, Config.BoxTrans, true, isR6)
                            else
                                HideSkeleton(esp)
                            end
                        else
                            esp.Box.Visible = false
                            esp.BoxOutline.Visible = false
                            esp.Name.Visible = false
                            esp.Distance.Visible = false
                            esp.HealthBar.Visible = false
                            esp.HealthBarBG.Visible = false
                            HideSkeleton(esp)
                        end
                    else
                        esp.Box.Visible = false
                        esp.BoxOutline.Visible = false
                        esp.Name.Visible = false
                        esp.Distance.Visible = false
                        esp.HealthBar.Visible = false
                        esp.HealthBarBG.Visible = false
                        HideSkeleton(esp)
                    end
                else
                    esp.Box.Visible = false
                    esp.BoxOutline.Visible = false
                    esp.Name.Visible = false
                    esp.Distance.Visible = false
                    esp.HealthBar.Visible = false
                    esp.HealthBarBG.Visible = false
                    HideSkeleton(esp)
                end
            end)
        end
    end
    
    for plr, esp in pairs(ESPObjects) do
        if not table.find(GetPlayers(Players), plr) then
            pcall(function()
                for _, drawing in pairs(esp) do
                    if typeof(drawing) == "table" then
                        if drawing.Remove then
                            drawing:Remove()
                        else
                            for _, subDraw in pairs(drawing) do
                                if typeof(subDraw) == "table" then
                                    for _, line in pairs(subDraw) do
                                        line:Remove()
                                    end
                                elseif subDraw.Remove then
                                    subDraw:Remove()
                                end
                            end
                        end
                    elseif drawing.Remove then
                        drawing:Remove()
                    end
                end
            end)
            
            ESPObjects[plr] = nil
        end
    end
end

local connection
local function startESP()
    if connection then connection:Disconnect() end
    connection = RunService.RenderStepped:Connect(function()
        pcall(UpdateESP)
    end)
end

local function stopESP()
    if connection then connection:Disconnect() end
    
    for _, esp in pairs(ESPObjects) do
        pcall(function()
            for _, drawing in pairs(esp) do
                if typeof(drawing) == "table" then
                    if drawing.Remove then
                        drawing:Remove()
                    else
                        for _, subDraw in pairs(drawing) do
                            if typeof(subDraw) == "table" then
                                for _, line in pairs(subDraw) do
                                    line:Remove()
                                end
                            elseif subDraw.Remove then
                                subDraw:Remove()
                            end
                        end
                    end
                elseif drawing.Remove then
                    drawing:Remove()
                end
            end
        end)
    end
    
    ESPObjects = {}
end

local on = true
local function toggle()
    on = not on
    if on then
        startESP()
    else
        stopESP()
    end
end

local function ToggleESP() 
    Toggled = not Toggled 
    if not Toggled then 
        CleanupESP() 
    else 
        connection = RunService.RenderStepped:Connect(UpdateESP) 
    end 
    return Toggled 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPToggle"
ScreenGui.Parent = game:GetService("CoreGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 80, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "ESP: ON"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.AutoButtonColor = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = ToggleButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 80)
UIStroke.Thickness = 1.5
UIStroke.Parent = ToggleButton

ToggleButton.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
end)

ToggleButton.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
end)

ToggleButton.MouseButton1Click:Connect(function()
    local status = ToggleESP()
    ToggleButton.Text = status and "ESP: ON" or "ESP: OFF"
    ToggleButton.BackgroundColor3 = status and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30)
end)

startESP()
