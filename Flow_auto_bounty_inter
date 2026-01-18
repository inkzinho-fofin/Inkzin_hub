-- Core Module: Bounty Logic
local Core = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

Core.Active = true

function Core:GetTarget()
    local nearest = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                nearest = v
            end
        end
    end
    return nearest
end

function Core:Attack(target)
    local settings = getgenv().Setting
    -- Lógica de uso de habilidades baseada na configuração de Item
    for category, data in pairs(settings.Item) do
        if data["Habilitar"] then
            -- Simulacro de uso de skills (Z, X, C, V) com cooldown
            for skill, info in pairs(data) do
                if type(info) == "table" and info["Habilitar"] then
                    print("Usando Skill: " .. skill .. " de " .. category)
                    task.wait(info["Tempo de espera"] or settings.Diversos["Atraso do clique"])
                end
            end
        end
    end
end

function Core:Travel(targetCFrame)
    if not getgenv().Setting.Diversos["Tween"] then 
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
        return 
    end
    
    local speed = 250 -- Velocidade padrão de Tween
    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    local info = TweenInfo.new(dist/speed, Enum.EasingStyle.Linear)
    
    local tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

return Core
