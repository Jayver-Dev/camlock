local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local camlockEnabled = false

-- Create Notification
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Notification = Instance.new("TextLabel")
Notification.Parent = ScreenGui
Notification.Size = UDim2.new(0, 250, 0, 50)
Notification.Position = UDim2.new(0.5, -125, 0.1, 0)
Notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Notification.TextColor3 = Color3.fromRGB(255, 255, 255)
Notification.Text = "Camlock Enabled"
Notification.Font = Enum.Font.SourceSansBold
Notification.TextSize = 20

wait(3) -- Remove the notification after 3 seconds
Notification:Destroy()

-- Create Draggable UI
local CamlockFrame = Instance.new("Frame")
CamlockFrame.Parent = ScreenGui
CamlockFrame.Size = UDim2.new(0, 100, 0, 50)
CamlockFrame.Position = UDim2.new(0.8, 0, 0.1, 0)
CamlockFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CamlockFrame.BorderSizePixel = 2
CamlockFrame.Active = true
CamlockFrame.Draggable = true

-- Create Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = CamlockFrame
TitleBar.Size = UDim2.new(1, 0, 0, 15)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

-- Create Button
local CamlockButton = Instance.new("TextButton")
CamlockButton.Parent = CamlockFrame
CamlockButton.Size = UDim2.new(1, 0, 1, -15)
CamlockButton.Position = UDim2.new(0, 0, 0, 15)
CamlockButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
CamlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CamlockButton.Font = Enum.Font.SourceSansBold
CamlockButton.TextSize = 20
CamlockButton.Text = "Camlock"

-- Enable/Disable Camlock
CamlockButton.MouseButton1Click:Connect(function()
    camlockEnabled = not camlockEnabled
    CamlockButton.Text = camlockEnabled and "On" or "Off"
end)

-- Find Nearest Player
local function getNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local myPosition = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position

    if myPosition then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (myPosition - otherPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = otherPlayer
                end
            end
        end
    end
    return nearestPlayer
end

-- Aim at Target
RunService.RenderStepped:Connect(function()
    if camlockEnabled then
        local targetPlayer = getNearestPlayer()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPlayer.Character.Head.Position)
        end
    end
end)

-- Make UI Resizable by Dragging Edges
local resizing = false
local resizeStart = nil
local frameStartSize = nil

CamlockFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.X > CamlockFrame.AbsolutePosition.X + CamlockFrame.AbsoluteSize.X - 10
       and input.Position.Y > CamlockFrame.AbsolutePosition.Y + CamlockFrame.AbsoluteSize.Y - 10 then
        resizing = true
        resizeStart = Vector2.new(input.Position.X, input.Position.Y)
        frameStartSize = CamlockFrame.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sizeDelta = Vector2.new(input.Position.X, input.Position.Y) - resizeStart
        CamlockFrame.Size = UDim2.new(0, math.clamp(frameStartSize.X.Offset + sizeDelta.X, 50, 300), 0, math.clamp(frameStartSize.Y.Offset + sizeDelta.Y, 50, 150))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)
