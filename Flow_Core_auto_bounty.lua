-- Core Module (Bounty Logic)
local Core = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

Core.Settings = {
    TweenSpeed = 60,
    SkillDelay = 1.5
}

function Core:TeleportToPlayer(targetPlayer)
    local character = LocalPlayer.Character
    local targetChar = targetPlayer.Character
    
    if character and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
        local root = character:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetChar.HumanoidRootPart
        
        local distance = (root.Position - targetRoot.Position).Magnitude
        local duration = distance / self.Settings.TweenSpeed
        
        local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, info, {CFrame = targetRoot.CFrame})
        
        tween:Play()
        return tween
    end
end

return Core
