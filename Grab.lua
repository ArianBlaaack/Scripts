--[[
    FE HACKS BY Arian#4137.
]]--

local Target = [[  lnter  ]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Character = Player.Character

local PlayerGui = Player:WaitForChild("PlayerGui")
local Backpack = Player:WaitForChild("Backpack")

local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
local RootPart = Character and Humanoid and Humanoid.RootPart or false
local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
if not Humanoid or not RootPart or not RightArm then
    return
end

local AnimationIds = {
    ["Grab"] = {
        ["R6"] = 35978879,
        ["R15"] = 4210116953
    },
    ["Kill"] = {
        ["R6"] = 204062532,
        ["R15"] = 3338083565
    }
}

local GetPlayer = function(Name)
    for x in string.gmatch(Name, "[%a%d%p]+") do
        Name = x:lower()
        break
    end
    local TPlayer = nil
    for _, x in next, Players:GetPlayers() do
        if tostring(x):lower():match(Name) or x["DisplayName"]:lower():match(Name) then
            TPlayer = x
            break
        end
    end
    return TPlayer
end

local CreateRightGrip = function(Tool)
    if Tool and RightArm then
        local Handle = Tool and Tool:FindFirstChild("Handle") or false
        if Handle then
            local Weld = Instance.new("Weld")
            Weld.Name = "RightGrip"
            Weld.Part0 = RightArm
            Weld.Part1 = Handle
            if Humanoid.RigType == Enum.HumanoidRigType.R6 then
                Weld.C0 = CFrame.new(0, -2, 0) * CFrame.Angles(math.rad(-110), 0, math.rad(45))
            else
                Weld.C0 = CFrame.new(2, -1, 1) * CFrame.Angles(math.rad(-90), math.rad(-25), math.rad(-110))--math.rad(-90)
            end
            Weld.C1 = Tool.Grip
            Weld.Parent = RightArm
            return Weld
        end
    end
end

Humanoid:UnequipTools()
local MainTool = Backpack:FindFirstChildWhichIsA("Tool") or false
if not MainTool or not MainTool:FindFirstChild("Handle") then
    return
end

local TPlayer = GetPlayer(Target)
local TCharacter = TPlayer and TPlayer.Character

local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid") or false
local TRootPart = TCharacter and THumanoid and THumanoid.RootPart or false
if not THumanoid or not TRootPart then
    return
end

if Character:FindFirstChild("Animate") then
    Character:FindFirstChild("Animate").Disabled = true
end
for _, x in next, Humanoid:GetPlayingAnimationTracks() do
    x:Stop()
end
CreateRightGrip(MainTool)
MainTool.Parent = Character
MainTool.Handle:BreakJoints()
MainTool.Parent = Backpack
MainTool.Parent = Humanoid
CreateRightGrip(MainTool)
if firetouchinterest then
    firetouchinterest(MainTool.Handle, TRootPart, 0)
    firetouchinterest(MainTool.Handle, TRootPart, 1)
else
    if Humanoid.RigType == Enum.HumanoidRigType.R6 then
        local OldCFrame = RootPart.CFrame
        local OldTick = tick()
        repeat
            task.wait()
            RootPart.CFrame = TRootPart.CFrame * CFrame.new(0, 2, 2)
            if MainTool.Parent ~= Humanoid then
                break
            end
        until (tick() - OldTick) > 3
        RootPart.CFrame = OldCFrame
    else
        return
    end
end
local CS; CS = RunService.Heartbeat:Connect(function()
    if Humanoid then
        if Humanoid.Health > 0 then
            Humanoid:ChangeState("GettingUp")
        end
    else
        CS:Disconnect()
    end
end)
THumanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
THumanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
local MainAnimation = Instance.new("Animation", Humanoid)
local Animation
local WaitTime
if Humanoid.RigType == Enum.HumanoidRigType.R6 then
    MainAnimation.AnimationId = "rbxassetid://"..AnimationIds["Grab"]["R6"]
    Animation = Humanoid:LoadAnimation(MainAnimation)
    WaitTime = .1
else
    MainAnimation.AnimationId = "rbxassetid://"..AnimationIds["Grab"]["R15"]
    Animation = Humanoid:LoadAnimation(MainAnimation)
    WaitTime = .25
end
Animation.Looped = false
Animation:Play()
task.wait(WaitTime)
Animation:AdjustSpeed(0)

local KillTPlayer; KillTPlayer = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and Input.KeyCode == Enum.KeyCode.K then
        KillTPlayer:Disconnect()
        local KillAnimation = Instance.new("Animation")
        if Humanoid.RigType == Enum.HumanoidRigType.R6 then
            KillAnimation.AnimationId = "rbxassetid://"..AnimationIds["Kill"]["R6"]
        else
            RootPart.Anchored = true
            KillAnimation.AnimationId = "rbxassetid://"..AnimationIds["Kill"]["R15"]
        end
        KillAnimation.Parent = Humanoid
        local Animation = Humanoid:LoadAnimation(KillAnimation)
        Animation:Play()
        Animation:AdjustSpeed(1)
        task.wait(1)
        RootPart.Anchored = false
        Player.Character = nil
        Humanoid.Health = 0
        Character:BreakJoints()
    end
end)
