--[[
    NCT HUB - BLOX FRUIT FULL VERSION
    Owner: CONGTHANHIOS
]]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Tạo Cửa Sổ Chính
local Window = OrionLib:MakeWindow({
    Name = "NCT Hub | Blox Fruit Premium", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "NCTHubConfig",
    IntroText = "Loading NCT Hub... by CongThanhios"
})

-- BIẾN TOÀN CỤC
_G.AutoFarm = false
_G.AutoBuso = true
_G.SelectWeapon = "Melee" -- Có thể đổi thành "Sword"

-- HỆ THỐNG NHẬN DIỆN SEA
local Sea1, Sea2, Sea3 = false, false, false
if game.PlaceId == 2753915549 then Sea1 = true
elseif game.PlaceId == 4442272183 then Sea2 = true
elseif game.PlaceId == 7449423635 then Sea3 = true end

-- HÀM BAY (TWEEN)
function Tween(Target)
    if not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local Distance = (Target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 300
    local TweenServ = game:GetService("TweenService")
    local Info = TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear)
    local Tween = TweenServ:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, Info, {CFrame = Target})
    Tween:Play()
end

-- HÀM KIỂM TRA LEVEL (DỮ LIỆU TỪ BANANA.TXT)
function CheckLevel()
    local v7 = game:GetService("Players").LocalPlayer.Data.Level.Value
    if Sea1 then
        if v7 >= 1 and v7 <= 9 then
            NameMon = "Bandit"; NameQuest = "BanditQuest1"; QuestLv = 1; CFrameQ = CFrame.new(1060.9, 16.4, 1547.7); CFrameMon = CFrame.new(1038.5, 41.2, 1576.5)
        elseif v7 >= 10 and v7 <= 14 then
            NameMon = "Monkey"; NameQuest = "JungleQuest"; QuestLv = 1; CFrameQ = CFrame.new(-1601.6, 36.8, 153.3); CFrameMon = CFrame.new(-1448.1, 50.8, 63.6)
        elseif v7 >= 15 and v7 <= 29 then
            NameMon = "Gorilla"; NameQuest = "JungleQuest"; QuestLv = 2; CFrameQ = CFrame.new(-1601.6, 36.8, 153.3); CFrameMon = CFrame.new(-1142.6, 40.4, -515.3)
        elseif v7 >= 30 and v7 <= 39 then
            NameMon = "Pirate"; NameQuest = "BuggyQuest1"; QuestLv = 1; CFrameQ = CFrame.new(-1140.1, 4.7, 3827.4); CFrameMon = CFrame.new(-1201.0, 40.6, 3857.5)
        -- Thêm các đảo tiếp theo...
        end
    elseif Sea2 then
        if v7 >= 700 and v7 <= 724 then
            NameMon = "Raider"; NameQuest = "Area1Quest"; QuestLv = 1; CFrameQ = CFrame.new(-427.7, 72.9, 1835.9); CFrameMon = CFrame.new(68.8, 93.6, 2429.6)
        end
    elseif Sea3 then
        if v7 >= 1500 and v7 <= 1524 then
            NameMon = "Pirate Millionaire"; NameQuest = "PiratePortQuest"; QuestLv = 1; CFrameQ = CFrame.new(-450.1, 107.6, 5950.7); CFrameMon = CFrame.new(-193.9, 56.1, 5755.7)
        end
    end
end

-- TỰ ĐỘNG CẦM VŨ KHÍ
function EquipTool()
    for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == _G.SelectWeapon or tool.Name == _G.SelectWeapon) then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
end

-- GIAO DIỆN
local HomeTab = Window:MakeTab({ Name = "Home", Icon = "rbxassetid://4483345998" })
HomeTab:AddLabel("Chủ sở hữu: CONGTHANHIOS")
HomeTab:AddParagraph("Thông Tin", "Sea Hiện Tại: "..(Sea1 and "1" or Sea2 and "2" or Sea3 and "3" or "Unknown"))

local FarmTab = Window:MakeTab({ Name = "Farming", Icon = "rbxassetid://4483345998" })
FarmTab:AddToggle({
    Name = "Auto Farm Level",
    Default = false,
    Callback = function(Value) _G.AutoFarm = Value end    
})

-- CORE XỬ LÝ
spawn(function()
    while true do task.wait()
        if _G.AutoFarm then
            pcall(function()
                CheckLevel()
                local Character = game.Players.LocalPlayer.Character
                
                -- Bật Haki
                if _G.AutoBuso and not Character:FindFirstChild("HasBuso") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                end

                if not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
                    Tween(CFrameQ)
                    if (Character.HumanoidRootPart.Position - CFrameQ.Position).Magnitude < 15 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                    end
                else
                    local Monster = game.Workspace.Enemies:FindFirstChild(NameMon) or game.Workspace:FindFirstChild(NameMon)
                    if Monster and Monster:FindFirstChild("Humanoid") and Monster.Humanoid.Health > 0 then
                        EquipTool()
                        Monster.HumanoidRootPart.CanCollide = false
                        Monster.HumanoidRootPart.CFrame = CFrameMon
                        Tween(Monster.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Attack", Monster.HumanoidRootPart.CFrame)
                    else
                        Tween(CFrameMon) -- Bay về chỗ quái đợi spawn
                    end
                end
            end)
        end
    end
end)

-- CHỐNG AFK
game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

OrionLib:Init()
