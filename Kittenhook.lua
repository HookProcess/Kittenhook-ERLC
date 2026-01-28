--[[
    Open Source ERLC Script | Kittenhook
    Created by: codecompressor, sillyleolol
    
    Note:
    This script might be detected and may have bugs
    This script isn't done yet and is still be updated to fix bugs and detections

    Script getting updated a lot

    Things to do:
        Add gun mods
        Add combat features
        Add Visual
    ^^^^^^^^^^^^^^^^^^^^^ 
    Soon
]]

if not (hookmetamethod and getgc and rawset and rawget and getconnections) then
    game.Players.LocalPlayer:Kick("Unsupported executor")
end

local Stats = game:GetService("Stats")
local MemoryCall
MemoryCall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Method = getnamecallmethod()

    if not checkcaller() and Self == Stats and Method == "GetMemoryUsageMbForTag" then
        return math.random(30000, 34000) / 100
    end

    return MemoryCall(Self, ...)
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Teams = game:GetService("Teams")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local FillStaminaRemote = ReplicatedStorage:WaitForChild("FE"):WaitForChild("FillStaminaBought")
local EnvRemote = ReplicatedStorage:WaitForChild("FE"):WaitForChild("Actions"):WaitForChild("Environmental")
local BurnRemote = ReplicatedStorage:WaitForChild("FE"):WaitForChild("Actions"):WaitForChild("Burn")
local PunchRemote = ReplicatedStorage:WaitForChild("FE"):WaitForChild("Punch")
local RespawnRemote = ReplicatedStorage:WaitForChild("FE"):WaitForChild("DeathRespawn")
local ArrestRemote = ReplicatedStorage:WaitForChild("FE"):WaitForChild("UseHandcuffs")
local VehicleExit = ReplicatedStorage:WaitForChild("FE"):WaitForChild("VehicleExit")
local VehicleSit = ReplicatedStorage:WaitForChild("FE"):WaitForChild("VehicleSit")

local FuelConnection
local OriginalValues = {}

function GetVehicle()
    for Controls, Vehicle in ipairs(workspace.Vehicles:GetChildren()) do
        local ControlValues = Vehicle:FindFirstChild("Control_Values")
        if ControlValues and ControlValues:FindFirstChild("Owner") and ControlValues.Owner.Value == game.Players.LocalPlayer.Name then
            return Vehicle
        end
    end
end

if game.PlaceId == 2534724415 then
    setfpscap(360)
    
    local Compkiller = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/CompKiller/refs/heads/main/src/source.luau"))();
    local Notifier = Compkiller.newNotify();
    local ConfigManager = Compkiller:ConfigManager({Directory = "Compkiller", Config = "Compkiller"}); -- let's keep it like this :Skull:

    Compkiller:Loader("rbxassetid://120245531583106" , 2.5).yield();

    local Window = Compkiller.new({
        Name = "Kittenhook",
        Keybind = "LeftAlt",
        Logo = "rbxassetid://120245531583106", -- we aint got a logo so we usin compkiller logo ^^^
        Scale = Compkiller.Scale.Window, 
        TextSize = 15,
    });

    _G.MoneyAuraRange = 13
    _G.PunchAuraRange = 12
    _G.ArrestAuraRange = 15
    _G.SpeedModifyValue = 16 

    Window:DrawCategory({ Name = "Main" })

    local PlayerTab = Window:DrawContainerTab({ Name = "Player", Icon = "user", Type = "Double" })
    local CombatTab = Window:DrawContainerTab({ Name = "Combat", Icon = "skull", Type = "Single" })
    local VehicleTab = Window:DrawContainerTab({ Name = "Vehicle", Icon = "car", Type = "Double" })
    local VisualsTab = Window:DrawContainerTab({ Name = "Visuals", Icon = "eye", Type = "Single" })
    local TrollingTab = Window:DrawContainerTab({ Name = "Trolling", Icon = "more-horizontal", Type = "Single" })
    local FarmingTab = Window:DrawContainerTab({ Name = "Farming", Icon = "shield", Type = "Single" })
    local UtilitiesTab = Window:DrawContainerTab({ Name = "Utilities", Icon = "settings", Type = "Single" })

    local PlayerTabMain = PlayerTab:DrawTab({ Name = "Local", Type = "Double" })
    local PlayerSection = PlayerTabMain:DrawSection({ Name = "Player" })
    local BypassSection = PlayerTabMain:DrawSection({ Name = "Bypass", Position = "right" })
    local PoliceSection = PlayerTabMain:DrawSection({ Name = "Police" })

    local CombatTabMain = CombatTab:DrawTab({ Name = "Combat", Type = "Single" })
    local CombatSection = CombatTabMain:DrawSection({ Name = "Aura" })

    local VehicleTabMain = VehicleTab:DrawTab({ Name = "Main", Type = "Double" })
    local VehicleSection = VehicleTabMain:DrawSection({ Name = "Vehicle" })
    local VehicleBypassSection = VehicleTabMain:DrawSection({ Name = "Bypass", Position = "right" })

    local FarmingTabMain = FarmingTab:DrawTab({ Name = "Farming", Type = "Single" })
    local FarmingSection = FarmingTabMain:DrawSection({ Name = "Auto Collect" })

    local UtilitiesTabMain = UtilitiesTab:DrawTab({ Name = "Utilities", Type = "Single" })
    local UtilitiesSection = UtilitiesTabMain:DrawSection({ Name = "Utilities" })

    PlayerSection:AddToggle({Name = "Walkspeed", Callback = function(State) _G.SpeedModify = State end})
    PlayerSection:AddSlider({Name = "Walkspeed Modifier", Min = 1, Max = 250, Precision = 1, Default = 16, Callback = function(State) _G.SpeedModifyValue = State end})
    PlayerSection:AddToggle({Name = "Noclip", Callback = function(State) _G.Noclip = State end})
    PlayerSection:AddToggle({Name = "Infinite Jump", Callback = function(State) _G.InfiniteJump = State end})
    PlayerSection:AddToggle({Name = "Instant Respawn", Callback = function(State) _G.AutoRespawn = State end})
    PlayerSection:AddToggle({Name = "Always Reset", Callback = function(State) _G.AlwaysReset = State end})
    PlayerSection:AddButton({Name = "Give Basketball", Callback = function() 
        for _, Basketball in pairs(Workspace.Basketballs:GetChildren()) do 
            if Basketball:IsA("BasePart") then 
                firetouchinterest(Basketball, LocalPlayer.Character.HumanoidRootPart, 0) 
                task.wait() 
                firetouchinterest(Basketball, LocalPlayer.Character.HumanoidRootPart, 1) 
            end 
        end 
    end})
    PlayerSection:AddButton({Name = "Respawn", Callback = function() 
        EnvRemote:FireServer(1000)
        task.wait()
        RespawnRemote:FireServer("River City")
    end})
    BypassSection:AddToggle({Name = "Infinite Stamina", Callback = function(State) _G.InfiniteStamina = State end})
    BypassSection:AddToggle({Name = "No Fall Damage", Callback = function(State) _G.NoFallDamage = State end})
    BypassSection:AddToggle({Name = "No Drown Damage", Callback = function(State) _G.NoDrownDamage = State end})
    --BypassSection:AddToggle({Name = "No Fire Damage", Callback = function(State) _G.NoFireDamage = State end})
    BypassSection:AddToggle({Name = "No Barbed Wires", Callback = function(State) _G.NoBarbedWires = State end})
    BypassSection:AddToggle({Name = "No Speed Cameras", Callback = function(State) _G.NoSpeedCameras = State end})
    BypassSection:AddToggle({Name = "No Speed Traps", Callback = function(State) _G.NoSpeedTraps = State end})
    BypassSection:AddToggle({Name = "No Traffic Lights", Callback = function(State) _G.NoTrafficLights = State end})
    PoliceSection:AddToggle({Name = "Arrest Aura", Callback = function(State) _G.ArrestAura = State end})
    PoliceSection:AddSlider({Name = "Arrest Aura Range", Min = 5, Max = 30, Precision = 1, Default = 15, Callback = function(State) _G.ArrestAuraRange = State end})
    PoliceSection:AddToggle({Name = "Anti Arrest", Callback = function(State) _G.AntiArrest = State end})
    
    CombatSection:AddToggle({Name = "Punch Aura", Callback = function(State) _G.PunchAura = State end})
    CombatSection:AddSlider({Name = "Punch Aura Range", Min = 1, Max = 17, Precision = 1, Default = 12, Callback = function(State) _G.PunchAuraRange = State end})

    VehicleSection:AddToggle({Name = "Enabled", Callback = function(State) _G.VehicleModsEnabled = State end})
    VehicleSection:AddToggle({Name = "Anti Roll", Callback = function(State) _G.AntiRoll = State end})
    VehicleSection:AddToggle({Name = "Ratios (Infinite Speed)", Callback = function(State) _G.InfiniteSpeed = State end})
    VehicleSection:AddSlider({Name = "Horsepower", Min = 0, Max = 10000, Default = 210, Callback = function(Value) _G.HorsepowerValue = Value end})
    VehicleSection:AddSlider({Name = "Forward Accel", Min = 0.01, Max = 10000, Precision = 0.01, Default = 150, Callback = function(Value) _G.ForwardAccel = Value end})
    VehicleSection:AddSlider({Name = "Backward Accel", Min = 0.01, Max = 10000, Precision = 0.01, Default = 150, Callback = function(Value) _G.BackwardAccel = Value end})
    VehicleSection:AddSlider({Name = "Steer Speed", Min = 0.01, Max = 10000, Precision = 0.01, Default = 150, Callback = function(Value) _G.SteerSpeed = Value end})
    VehicleSection:AddButton({Name = "Apply Modification", Callback = function()
        if Humanoid and Humanoid.SeatPart then
            local Seat = Humanoid.SeatPart
            VehicleExit:FireServer(Seat)
            task.wait(0.52)
            VehicleSit:FireServer(Seat)
        end
    end})
    VehicleSection:AddToggle({Name = "Vehicle Noclip", Callback = function(State) _G.VehicleNoclip = State end})
    VehicleSection:AddToggle({Name = "Spam Drift", Callback = function(State) _G.SpamDrift = State end})
    VehicleBypassSection:AddToggle({Name = "Infinite Fuel", Callback = function(State) _G.InfiniteFuel = State end})
    VehicleBypassSection:AddToggle({Name = "No Stop Sticks", Callback = function(State) _G.NoStopSticks = State end})

    FarmingSection:AddToggle({Name = "Money Aura", Callback = function(State) _G.MoneyAura = State end})
    FarmingSection:AddSlider({Name = "Money Aura Range", Min = 5, Max = 50, Precision = 1, Default = 13, Callback = function(State) _G.MoneyAuraRange = State end})

    UtilitiesSection:AddToggle({
        Name = "No E Wait", 
        Callback = function(State) 
            _G.NoEWait = State        
            if _G.NoEWait then
                for Stuff, Interact in pairs(getgc(true)) do
                    if type(Interact) == "table" and rawget(Interact, "HoldTime") then
                        if not rawget(Interact, "OldValue") then
                            rawset(Interact, "OldValue", Interact.HoldTime)
                        end
                        rawset(Interact, "HoldTime", 0)
                    end
                end
            else
                for Stuff, Interact in pairs(getgc(true)) do
                    if type(Interact) == "table" and rawget(Interact, "OldValue") then
                        rawset(Interact, "HoldTime", Interact.OldValue)
                        rawset(Interact, "OldValue", nil)
                    end
                end
            end
        end 
    })

    task.spawn(function()
        while task.wait() do
            local Vehicle = GetVehicle()
            if _G.SpeedModify and Humanoid and Humanoid.MoveDirection.Magnitude > 0 then
                LocalPlayer.Character:TranslateBy(Humanoid.MoveDirection * (_G.SpeedModifyValue / 10))
            end

            if _G.Noclip and LocalPlayer.Character then
                for Stuff, Part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if Part:IsA("BasePart") then
                        Part.CanCollide = false
                    end
                end
            end

            if _G.AlwaysReset then
                StarterGui:SetCore("ResetButtonCallback", true)
            end

            if _G.InfiniteStamina and Humanoid then
                task.spawn(getconnections(FillStaminaRemote.OnClientEvent)[1].Function) -- yeah... what the fuck
            end

            if _G.NoBarbedWires then
                for Stuff, Fence in pairs(Workspace.Dump:GetChildren()) do 
                    if Fence.Name == "Metal Fence" and Fence:IsA("Model") and Fence:FindFirstChild("Fence") then 
                        Fence.Fence.CanTouch = false
                    end 
                end 
            end

            if _G.NoSpeedCameras then
                for Stuff, CameraPart in pairs(Workspace.TrafficDetections.EvasionDetections:GetChildren()) do
                    if CameraPart.Name == "EvasionDetection" and CameraPart:IsA("BasePart") then
                        CameraPart.CanTouch = false
                    end
                end
            end

            if _G.NoSpeedTraps then
                for Stuff, SpeedTraps in pairs(Workspace.TrafficDetections.SpeedTraps:GetDescendants()) do 
                    if SpeedTraps:IsA("BasePart") and SpeedTraps.Parent.Name == "SpeedTrap" then 
                        SpeedTraps.CanTouch = false
                    end 
                end 
            end

            if _G.NoTrafficLights then
                for Stuff, TrafficLights in pairs(Workspace["Traffic Lights"]:GetDescendants()) do 
                    if TrafficLights:IsA("BasePart") and TrafficLights.Parent.Name == "Detection" then 
                        TrafficLights.CanTouch = false
                    end 
                end 
            end

            if _G.NoStopSticks then
                for Stuff, StopStick in pairs(Workspace.Deployables:GetDescendants()) do 
                    if StopStick:IsA("BasePart") and StopStick.Name == "Stop Stick" then 
                        StopStick.CanTouch = false
                    end 
                end 
            end

            if _G.InfiniteFuel and Vehicle then
                local Fuel = Vehicle and Vehicle:FindFirstChild("Control_Values") and Vehicle.Control_Values:FindFirstChild("CurrentFuel")
                if Fuel then
                    if not FuelConnection then 
                        Fuel.Value = 14
                    end
                    FuelConnection = Fuel:GetPropertyChangedSignal("Value"):Connect(function()
                        if Fuel.Value ~= 14 then
                            Fuel.Value = 14
                        end
                    end)
                end
            else
                if FuelConnection then
                    FuelConnection:Disconnect()
                    FuelConnection = nil
                end
            end

            local DriveController = Vehicle and Vehicle:FindFirstChild("Drive Controller")
            if DriveController then
                local Drive = require(DriveController)
                if not OriginalValues[Vehicle] then
                    OriginalValues[Vehicle] = {
                        Horsepower = Drive.Horsepower,
                        ThrotAccel = Drive.ThrotAccel,
                        ThrotDecel = Drive.ThrotDecel,
                        SteerSpeed = Drive.SteerSpeed,
                        FAntiRoll = Drive.FAntiRoll,
                        RAntiRoll = Drive.RAntiRoll,
                        FinalDrive = Drive.FinalDrive
                    }
                end
                local Original = OriginalValues[Vehicle]
                if _G.VehicleModsEnabled and Vehicle then
                    Drive.Horsepower = _G.HorsepowerValue or 210
                    Drive.ThrotAccel = _G.ForwardAccel or 150
                    Drive.ThrotDecel = _G.BackwardAccel or 150
                    Drive.SteerSpeed = _G.SteerSpeed or 150
                else
                    Drive.Horsepower = Original.Horsepower
                    Drive.ThrotAccel = Original.ThrotAccel
                    Drive.ThrotDecel = Original.ThrotDecel
                    Drive.SteerSpeed = Original.SteerSpeed
                end

                if _G.AntiRoll then
                    Drive.FAntiRoll = 10000
                    Drive.RAntiRoll = 10000
                else
                    Drive.FAntiRoll = Original.FAntiRoll
                    Drive.RAntiRoll = Original.RAntiRoll
                end

                if _G.InfiniteSpeed then
                    Drive.FinalDrive = 1
                else
                    Drive.FinalDrive = Original.FinalDrive
                end

                if _G.SpamDrift and Vehicle then
                    local DriftRemote = Vehicle.Input_Events:FindFirstChild("Drift")
                    if DriftRemote then
                        DriftRemote:FireServer(math.huge, math.huge)
                    end
                end

                if _G.VehicleNoclip and Vehicle then
                    task.wait(.5)
                    local MyVehicle = GetVehicle()
                    for _, Vehicle in pairs(Workspace.Vehicles:GetChildren()) do
                        if Vehicle ~= MyVehicle then
                            for Stuff, Part in pairs(Vehicle:GetDescendants()) do
                                if Part:IsA("BasePart") then
                                    Part.CanCollide = not _G.VehicleNoclip
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(.3) do
            if _G.MoneyAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for Stuff, MoneyBill in pairs(Workspace:GetChildren()) do
                    if MoneyBill.Name == "MoneyBill" and MoneyBill:IsA("BasePart") then
                        if (LocalPlayer.Character.HumanoidRootPart.Position - MoneyBill.Position).Magnitude <= _G.MoneyAuraRange then
                            firetouchinterest(MoneyBill, LocalPlayer.Character.HumanoidRootPart, 0)
                            task.wait()
                            firetouchinterest(MoneyBill, LocalPlayer.Character.HumanoidRootPart, 1)
                        end
                    end
                end
            end

            for Stuff, Player in pairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if _G.PunchAura and (LocalPlayer.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude < _G.PunchAuraRange and Player.Character.Humanoid.Health > 0.101 then
                        PunchRemote:FireServer(Player)
                    end
                    if _G.ArrestAura and (LocalPlayer.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude < _G.ArrestAuraRange then
                        if IsWanted and Player.Team ~= Teams.Jail then
                            local IsWanted = Player.Character:FindFirstChild("Is_Wanted") or (Player:FindFirstChild("Is_Wanted"))
                            ArrestRemote:InvokeServer("Handcuff", Player, false)
                            task.wait()
                            ArrestRemote:InvokeServer("Arrest", Player)
                        end
                    end
                end
            end
        end
    end)

    local DamageCall
    DamageCall = hookmetamethod(game, "__namecall", function(Self, ...)
        local Args = {...}
        local Method = getnamecallmethod()
        if not checkcaller() and Self == EnvRemote and Method == "FireServer" then
            local Damage = Args[1]
            if _G.NoFallDamage and type(Damage) == "number" and Damage ~= 10 then 
                return
            end
            if _G.NoDrownDamage and Damage == 10 then
                return
            end
        end
        return DamageCall(Self, ...)
    end)

    UserInputService.JumpRequest:Connect(function()
        if _G.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(Character)
        Character:WaitForChild("Humanoid").HealthChanged:Connect(function(Health) 
            if _G.AutoRespawn and Health < 0.11 then
                RespawnRemote:FireServer("River City")
            end 
        end)
    end)

    LocalPlayer.ChildAdded:Connect(function(Child)
        if _G.AntiArrest and (Child.Name == "In_Handcuffs" or Child.Name == "Detained") then
            EnvRemote:FireServer(1000)
            task.wait()
            RespawnRemote:FireServer("River City")
        end
    end)

    Window:DrawCategory({ Name = "Settings" });
    local SettingTab = Window:DrawTab({ Icon = "settings-3", Name = "Settings", Type = "Single" });
    SettingTab:DrawSection({ Name = "UI Settings" }):AddButton({Name = "Copy Discord Link", Callback = function() setclipboard("https://discord.gg/XZHTtDzrvT") end})
    local ConfigUI = Window:DrawConfig({ Name = "Config", Icon = "folder", Config = ConfigManager }):Init();
end
