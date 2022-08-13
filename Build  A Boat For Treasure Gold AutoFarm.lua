local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

local Tween = function(Object, Time, EasingStyle, EasingDirection, Value)
    return TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle[EasingStyle], Enum.EasingDirection[EasingDirection]), Value)
end

while true do
    local Character = Player.Character
    
    local Humanoid = Character:WaitForChild("Humanoid")
    local RootPart = Humanoid.RootPart
    
    local BoatStages = workspace:WaitForChild("BoatStages")
    
    local NormalStages = BoatStages and BoatStages:WaitForChild("NormalStages")
    local LastStage = NormalStages and NormalStages:FindFirstChild("TheEnd")
    
    RootPart.CFrame = CFrame.new(0, 0, 0)
    for x = 1, #NormalStages:GetChildren()-1 do 
        local CurrentStage = NormalStages:FindFirstChild("CaveStage"..x)
        local DarknessPart = CurrentStage and CurrentStage:FindFirstChild("DarknessPart")
        
        if CurrentStage and DarknessPart then
            local RootPartTween = Tween(RootPart, .7, "Quart", "Out", {CFrame = DarknessPart.CFrame})
            RootPartTween:Play()
            RootPartTween.Completed:Wait()
        end
    end
    
    if LastStage then
        local GoldenChest = LastStage and LastStage:FindFirstChild("GoldenChest")
        local Trigger = GoldenChest and GoldenChest:FindFirstChild("Trigger")
        
        if Trigger then
            RootPart.CFrame = Trigger.CFrame
            wait(.1)
            RootPart.Anchored = true
        end
    end
    repeat task.wait() until Player.Character ~= Character
end
