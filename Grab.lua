--[[
    FE HACKS BY Arian#4137.
]]--

local Target = [[  target's name here  ]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

local PlayerGui = Player:WaitForChild("PlayerGui")
local Backpack = Player:WaitForChild("Backpack")

local Character = Player.Character

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
    local RightArm = Character and Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
    if Tool and RightArm then
        local Handle = Tool and Tool:FindFirstChild("Handle") or false
        if Handle then
            local Weld = Instance.new("Weld")
            Weld.Name = "RightGrip"
            Weld.Part0 = RightArm
            Weld.Part1 = Handle
            Weld.C0 = CFrame.new(0, -2, 0) * CFrame.Angles(math.rad(-110), 0, math.rad(45))
            Weld.C1 = Tool.Grip
            Weld.Parent = RightArm
            return Weld
        end
    end
end

local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
local RootPart = Character and Humanoid and Humanoid.RootPart or false
if not Humanoid or not RootPart then
    return
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
end
local CS; CS = RunService.Heartbeat:Connect(function()
    if Humanoid then
        if Humanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
            Humanoid:ChangeState("GettingUp")
        end
    else
        CS:Disconnect()
    end
end)
local MainAnimation = Instance.new("Animation")
MainAnimation.AnimationId = "rbxassetid://35978879"
MainAnimation.Parent = Humanoid
local Animation = Humanoid:LoadAnimation(MainAnimation)
Animation.Looped = false
Animation:AdjustSpeed(.5)
Animation:Play()
wait(.1)
Animation:AdjustSpeed(0)

local KillTPlayer; KillTPlayer = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and Input.KeyCode == Enum.KeyCode.K then
        KillTPlayer:Disconnect()
        local KillAnimation = Instance.new("Animation")
        KillAnimation.AnimationId = "rbxassetid://204062532"
        KillAnimation.Parent = Humanoid
        local Animation = Humanoid:LoadAnimation(KillAnimation)
        Animation:Play()
        Animation:AdjustSpeed(1)
        Animation.Stopped:Wait()
        Player.Character = nil
        Humanoid.Health = 0
        Character:BreakJoints()
    end
end)
