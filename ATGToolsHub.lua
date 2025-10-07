repeat task.wait() until game:IsLoaded()

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local screen = workspace.CurrentCamera.ViewportSize
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local startTime = tick() -- เวลาเริ่มสคริปต์
local infoParagraph = nil
local char = nil
local hum = nil
local content = ""
local width = math.clamp(screen.X * 0.6, 400, 600)   -- อย่างน้อย 400px มากสุด 600px
local height = math.clamp(screen.Y * 0.6, 300, 500) -- อย่างน้อย 300px มากสุด 500px


local Window = Fluent:CreateWindow({
    Title = "ATG Tools Hub " .. Fluent.Version,
    SubTitle = "by ATGFAIL",
    TabWidth = 160,
    Size = UDim2.fromOffset(width, height),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "repeat" }),
    ScriptTools = Window:AddTab({ Title = "Scripts Tools", Icon = "wrench"}),
    ScriptHub = Window:AddTab({ Title = "Scripts Hub", Icon = "component"}),
    Server = Window:AddTab({ Title = "Server", Icon = "server"}),
    AFK = Window:AddTab({ Title = "AFK", Icon = "server-off"}),
    Players = Window:AddTab({ Title = "Humanoid", Icon = "users" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "plane" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "locate"}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

    -- สร้าง Paragraph
    infoParagraph = Tabs.Main:AddParagraph({
        Title = "Player Info",
        Content = "Loading player info..."
    })

    -- ฟังก์ชันช่วยเติมเลขให้เป็น 2 หลัก (เช่น 4 -> "04")
    local function pad2(n)
        return string.format("%02d", tonumber(n) or 0)
    end

    -- ฟังก์ชันอัพเดทข้อมูล
    local function updateInfo()
        -- รับตัวละคร / humanoid (ถ้ามี)
        char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        hum = char and char:FindFirstChildWhichIsA("Humanoid")

        -- เวลาที่เล่น (วินาที, ปัดลง)
        local playedSeconds = math.floor(tick() - startTime)

        -- แยกชั่วโมง นาที วินาที
        local hours = math.floor(playedSeconds / 3600)
        local minutes = math.floor((playedSeconds % 3600) / 60)
        local seconds = playedSeconds % 60

        -- วันที่ปัจจุบัน รูปแบบ DD/MM/YYYY
        local dateStr = os.date("%d/%m/%Y")

        -- สร้างข้อความที่จะโชว์ (เอา Health/WalkSpeed/JumpPower ออกแล้ว)
        content = string.format([[
    Name: %s (@%s)
    Date : %s

    Played Time : %s : %s : %s
    ]],
            LocalPlayer.DisplayName or LocalPlayer.Name,
            LocalPlayer.Name or "Unknown",
            dateStr,
            pad2(hours),
            pad2(minutes),
            pad2(seconds)
        )

        -- อัปเดต Paragraph ใน UI
        pcall(function()
            infoParagraph:SetDesc(content)
        end)
    end

    -- loop update ทุกๆ 1 วิ
    task.spawn(function()
        while true do
            if Fluent.Unloaded then break end
            pcall(updateInfo)
            task.wait(1)
        end
    end)



    Tabs.ScriptTools:AddButton({
    Title = "ATGAudio Logger",
    Description = "กดเพื่อเปิด ATGAudio Logger",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการทำงาน",
            Content = "แน่ใจนะว่าจะรัน ATGAudio Logger?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        loadstring(game:HttpGet('https://raw.githubusercontent.com/ATGFAIL/ATGAudio-logger/main/ATGAudio-logger.lua'))()
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})

Tabs.ScriptTools:AddButton({
    Title = "ATGDex Explorrer",
    Description = "กดเพื่อเปิด ATGDex Explorrer",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการทำงาน",
            Content = "แน่ใจนะว่าจะรัน ATGDex Explorrer?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        loadstring(game:HttpGet('https://raw.githubusercontent.com/ATGFAIL/ATGDex/main/ATGDex.lua'))()
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})

Tabs.ScriptTools:AddButton({
    Title = "ATGRemote Spy",
    Description = "กดเพื่อเปิด ATGRemote Spy",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการทำงาน",
            Content = "แน่ใจนะว่าจะรัน ATGRemote Spy?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        loadstring(game:HttpGet('https://raw.githubusercontent.com/ATGFAIL/ATGRemoteSpy/main/ATGRemoteSpy.lua'))()
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})

Tabs.ScriptTools:AddButton({
    Title = "Server Info",
    Description = "กดเพื่อเปิด Server Info",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการทำงาน",
            Content = "แน่ใจนะว่าจะรัน Server Info?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        loadstring(game:HttpGet('https://raw.githubusercontent.com/ATGFAIL/serverinfo/main/serverinfo.lua'))()
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})



Tabs.ScriptHub:AddButton({
    Title = "ATG Hub",
    Description = "กดเพื่อรันสคริปต์ ATG Hub ของ ATGFAIL",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการทำงาน",
            Content = "แน่ใจนะว่าจะรันสคริปต์ ATGComkub.lua ?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        loadstring(game:HttpGet('https://raw.githubusercontent.com/ATGFAIL/ATGHub/main/ATGComkub.lua'))()
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})

Tabs.ScriptHub:AddButton({
    Title = "Maru Hub PC",
    Description = "กดเพื่อรันสคริปต์ Maru Hub PC",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการทำงาน",
            Content = "แน่ใจนะว่าจะรันสคริปต์ Maru Hub PC?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()   
                        (getgenv()).key = "MARUM08PPQRXFDXZOW1XENE1LW";
                        (getgenv()).id = "1334559259882557471";
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/xshiba/MaruComkak/main/PCBit.lua"))()
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})

Tabs.ScriptHub:AddButton({
    Title = "Maru Hub Mobile",
    Description = "กดเพื่อรันสคริปต์ Maru Hub Mobile",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการทำงาน",
            Content = "แน่ใจนะว่าจะรันสคริปต์ Maru Hub Mobile?",
            Buttons = {
                {
                    Title = "Thai",
                    Callback = function()   
                        getgenv().Key = "MARU-P9AOJ-KQ0E-LKB7-62CQB-JEGNJ"
                        getgenv().id = "1334559259882557471"
                        _G.Script_Language = "Thai"
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/xshiba/MaruBitkub/main/Mobile.lua"))()
                    end
                },
                {
                    Title = "All Map",
                    Callback = function()
                        getgenv().Key = "MARU-P9AOJ-KQ0E-LKB7-62CQB-JEGNJ"
                        getgenv().id = "1334559259882557471"
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/xshiba/MaruBitkub/main/Mobile.lua"))()
                    end
                },
                {
                    Title = "Kaitun",
                    Callback = function()
                        getgenv().Key = "MARU-P9AOJ-KQ0E-LKB7-62CQB-JEGNJ"
                        getgenv().id = "1334559259882557471"
                        getgenv().Script_Mode = "Kaitun_Script"
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/xshiba/MaruBitkub/main/Mobile.lua"))()
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})

Tabs.ScriptHub:AddButton({
    Title = "Build a Zoo",
    Description = "กดเพื่อรันสคริปต์แมพ Build a Zoo",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการทำงาน",
            Content = "แน่ใจนะว่าจะรันสคริปต์แมพ Build a Zoo?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()   
                        -- Game: ❄️Build a Zoo 
                        _G.Authorize = '07EQJ-WK06H-7UZ0X-OZQ2V'
                        loadstring(game:HttpGet("https://deity.alphes.net/.lua")){"V1"}
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})

Tabs.ScriptHub:AddButton({
    Title = "99 Night In The Forest",
    Description = "กดเพื่อรันสคริปต์แมพ 99 Night In The Forest",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการทำงาน",
            Content = "แน่ใจนะว่าจะรันสคริปต์แมพ 99 Night In The Forest?",
            Buttons = {
                {
                    Title = "FoxName",
                    Callback = function()   
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua"))()
                    end
                },
                {
                    Title = "H4xScripts",
                    callback = function()
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader2.lua", true))()
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})

Tabs.Server:AddButton({
    Title = "Find Private Server",
    Description = "หาเซิฟ VIP ฟรี",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการทำงาน",
            Content = "แน่ใจนะว่าจะหาเซิฟวี?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()   
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Free%20Private%20Server.lua"))()
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                    end
                }
            }
        })
    end
})

-- ============================
-- Server Hop (unchanged logic, but minimal calls)
-- ============================
do
    local function findServer()
        local servers = {}
        local cursor = ""
        local placeId = game.PlaceId
        repeat
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
            local success, response = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
            if success and response and response.data then
                for _, server in ipairs(response.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        table.insert(servers, server.id)
                    end
                end
                cursor = response.nextPageCursor or ""
            else break end
        until cursor == ""
        if #servers > 0 then return servers[math.random(1,#servers)] end
        return nil
    end

    Tabs.Server:AddButton({
        Title = "Server Hop",
        Description = "Join a different random server instance.",
        Callback = function()
            local serverId = findServer()
            if serverId then TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer) else warn("No available servers found!") end
        end
    })

    Tabs.Server:AddButton({
        Title = "Rejoin",
        Description = "Rejoin This Server",
        Callback = function()
            local ok, err = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end)
        end
    })

    local function findLowestServer()
        local lowestServer, lowestPlayers = nil, math.huge
        local cursor = ""
        local placeId = game.PlaceId
        repeat
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
            local success, response = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
            if success and response and response.data then
                for _, server in ipairs(response.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        if server.playing < lowestPlayers then lowestPlayers = server.playing; lowestServer = server.id end
                    end
                end
                cursor = response.nextPageCursor or ""
            else break end
        until cursor == ""
        return lowestServer
    end

    Tabs.Server:AddButton({
        Title = "Lower Server",
        Description = "Join the server with the least number of players.",
        Callback = function()
            local serverId = findLowestServer()
            if serverId then TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer) else warn("No available servers found!") end
        end
    })
end

local Section = Tabs.Server:AddSection("Job ID")

-- เก็บค่าจาก Input
local jobIdInputValue = ""

-- สร้าง Input (ใช้ของเดิมที่ให้มา ปรับ Default ให้ว่าง)
local Input = Tabs.Server:AddInput("Input", {
    Title = "Input Job ID",
    Default = "",
    Placeholder = "วาง Job ID ที่นี่",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        jobIdInputValue = tostring(Value or "")
    end
})

-- อัปเดตค่าแบบ realtime เวลาเปลี่ยน
Input:OnChanged(function(Value)
    jobIdInputValue = tostring(Value or "")
end)

-- ปุ่ม Teleport
Tabs.Server:AddButton({
    Title = "Teleport to Job",
    Description = "Teleport ไปยัง Job ID ที่ใส่ข้างบน",
    Callback = function()
        -- validation เบื้องต้น
        if jobIdInputValue == "" or jobIdInputValue == "Default" then
            Window:Dialog({
                Title = "กรอกก่อน!!",
                Content = "กรอก Job ID ก่อนนะ จิ้มปุ่มอีกทีจะ teleport ให้",
                Buttons = {
                    { Title = "OK", Callback = function() end }
                }
            })
            return
        end

        -- เช็คว่าเป็น Job เดียวกับที่เราอยู่หรือยัง
        if tostring(game.JobId) == jobIdInputValue then
            Window:Dialog({
                Title = "อยู่แล้วนะ",
                Content = "คุณอยู่ในเซิร์ฟเวอร์นี้อยู่แล้ว (same Job ID).",
                Buttons = { { Title = "OK", Callback = function() end } }
            })
            return
        end

        -- ยืนยันก่อน teleport
        Window:Dialog({
            Title = "ยืนยันการย้าย",
            Content = "จะย้ายไปเซิร์ฟเวอร์ Job ID:\n" .. jobIdInputValue .. "\nยืนยันไหม?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        -- เรียก Teleport ใน pcall กัน error
                        local ok, err = pcall(function()
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobIdInputValue)
                        end)

                        if ok then
                            -- ปกติจะไม่มาถึงบรรทัดนี้เพราะ client จะโหลดหน้า teleport แต่เผื่อ error
                            print("Teleport เริ่มแล้ว — ถ้ามีปัญหาจะมี log ขึ้น")
                        else
                            Window:Dialog({
                                Title = "Teleport ล้มเหลว",
                                Content = "เกิดข้อผิดพลาด: " .. tostring(err),
                                Buttons = { { Title = "OK", Callback = function() end } }
                            })
                        end
                    end
                },
                { Title = "Cancel", Callback = function() end }
            }
        })
    end
})

-- -----------------------
-- Anti-AFK
-- -----------------------
do
    local vu = nil
    -- VirtualUser trick: works in many environments (Roblox default)
    local function enableAntiAFK(enable)
        if enable then
            if not vu then
                -- VirtualUser exists only in Roblox client; we get via game:GetService("VirtualUser") (works in studio / client)
                pcall(function() vu = game:GetService("VirtualUser") end)
            end
            if vu then
                Players.LocalPlayer.Idled:Connect(function()
                    pcall(function()
                        vu:Button2Down(Vector2.new(0,0))
                        task.wait(1)
                        vu:Button2Up(Vector2.new(0,0))
                    end)
                end)
            end
    end

    local antiAFKToggle = Tabs.AFK:AddToggle("AntiAFKToggle", { Title = "Anti-AFK Beta", Default = true })
    antiAFKToggle:OnChanged(function(v) enableAntiAFK(v) end)
    -- default on
    antiAFKToggle:SetValue(true)
    enableAntiAFK(true)
end
end

local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")

-- สร้าง ScreenGui (ถ้าอยู่ใน Studio ให้ตั้งเป็น Parent = PlayerGui)
local ATGAFK = Instance.new("ScreenGui")
ATGAFK.Name = "ATG_AntiAFK"
ATGAFK.ResetOnSpawn = false
ATGAFK.Parent = PlayerGui or game.CoreGui

-- ===== Main frame =====
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 320, 0, 130)
Main.Position = UDim2.new(0.35, 0, 0.38, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ATGAFK

local UICornerMain = Instance.new("UICorner", Main)
UICornerMain.CornerRadius = UDim.new(0, 10)

-- Title bar (for drag)
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 24)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.Text = "ATG Anti-AFK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextScaled = true

local Credits = Instance.new("TextLabel")
Credits.Parent = Main
Credits.Size = UDim2.new(1, 0, 0, 18)
Credits.Position = UDim2.new(0, 0, 1, -20)
Credits.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Credits.BorderSizePixel = 0
Credits.Font = Enum.Font.GothamBold
Credits.Text = "Made by ATGFAIL"
Credits.TextColor3 = Color3.fromRGB(200, 200, 200)
Credits.TextSize = 14
Credits.TextScaled = true

-- Activate / Deactivate button
local Activate = Instance.new("TextButton")
Activate.Parent = Main
Activate.Name = "Activate"
Activate.Size = UDim2.new(0.94, 0, 0, 64)
Activate.Position = UDim2.new(0.03, 0, 0.18, 0)
Activate.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Activate.BorderSizePixel = 0
Activate.Font = Enum.Font.GothamBold
Activate.Text = "Activate"
Activate.TextSize = 24
Activate.TextColor3 = Color3.fromRGB(0, 255, 127)
Activate.AutoButtonColor = false

local UICorner_Activate = Instance.new("UICorner", Activate)
UICorner_Activate.CornerRadius = UDim.new(0, 8)

-- ===== State & connections handling =====
local afkConnection = nil
local isActive = false
local buttonDebounce = false

-- เก็บ connections เพื่อ disconnect ตอน cleanup
local connections = {}

local function addConnection(conn)
    if conn then
        table.insert(connections, conn)
    end
end

-- ฟังก์ชันเปิดตัว Anti-AFK แบบปลอดภัย
local function enableAntiAfk()
    if isActive then return end
    isActive = true

    if afkConnection and afkConnection.Connected then
        afkConnection:Disconnect()
    end

    if LocalPlayer then
        afkConnection = LocalPlayer.Idled:Connect(function()
            pcall(function()
                -- คลิกขวาลง-ปล่อย trick
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end)
        addConnection(afkConnection)
    end

    -- อัปเดต UI
    Activate.Text = "Deactivate"
    Activate.TextColor3 = Color3.fromRGB(255, 100, 100)
    Activate.BackgroundColor3 = Color3.fromRGB(70, 30, 30)
end

local function disableAntiAfk()
    if not isActive then return end
    isActive = false

    if afkConnection and afkConnection.Connected then
        afkConnection:Disconnect()
    end
    afkConnection = nil

    Activate.Text = "Activate"
    Activate.TextColor3 = Color3.fromRGB(0, 255, 127)
    Activate.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end

-- ปุ่ม Activate/Deactivate (debounce)
local activateConn = Activate.MouseButton1Click:Connect(function()
    if buttonDebounce then return end
    buttonDebounce = true
    task.spawn(function()
        task.wait(0.12)
        buttonDebounce = false
    end)

    if isActive then
        disableAntiAfk()
    else
        enableAntiAfk()
    end
end)
addConnection(activateConn)

-- ===== Integration with external Toggle UI (preferred) =====
-- คีย์/ชื่อตัวเลือกที่จะสร้างใน Options table
local toggleKey = "ATG_AntiAFK_Toggle"
local externalToggle = nil

-- ฟังก์ชันช่วย sync ค่าไปยังระบบ Toggle/Options (ถ้ามี)
local function syncToggleState(val)
    -- ถ้ามี object Toggle ที่คืนจาก AddToggle และมี SetValue method ให้ set
    if externalToggle and type(externalToggle.SetValue) == "function" then
        pcall(function() externalToggle:SetValue(val) end)
    end

    -- ถ้ามี Options table ตามรูปแบบตัวอย่าง (Options.<key>:SetValue)
    if type(Options) == "table" and Options[toggleKey] then
        if type(Options[toggleKey].SetValue) == "function" then
            pcall(function() Options[toggleKey]:SetValue(val) end)
        else
            -- ถ้า Options.<key>.Value เป็นฟิลด์ ให้เซ็ตโดยตรง (fallback)
            pcall(function() Options[toggleKey].Value = val end)
        end
    end
end

-- พยายามเชื่อมต่อกับ Tabs.Main:AddToggle ถ้ามี
if type(Tabs) == "table" and Tabs.AFK and type(Tabs.AFK.AddToggle) == "function" then
    -- สร้าง toggle และเก็บ object ไว้สำหรับ sync (บาง UI lib คืน Toggle object, บางอันใช้ Options table)
    externalToggle = Tabs.AFK:AddToggle(toggleKey, {Title = "ATG Anti-AFK", Default = false})

    -- ถ้า UI lib ใช้ Callback OnChanged ตามตัวอย่าง
    if externalToggle and type(externalToggle.OnChanged) == "function" then
        externalToggle:OnChanged(function()
            local opened = false
            -- ถ้ามี Options table ให้ try อ่านค่า
            if type(Options) == "table" and Options[toggleKey] and Options[toggleKey].Value ~= nil then
                opened = Options[toggleKey].Value
            else
                -- ถ้า Toggle object มี property Value
                if externalToggle.Value ~= nil then
                    opened = externalToggle.Value
                end
            end

            Main.Visible = opened
        end)
    else
        -- หาก Toggle object ไม่มี OnChanged แต่คืน object ที่มี SetValue, พยายามฟัง Options table แทน
        if type(Options) == "table" and Options[toggleKey] and type(Options[toggleKey].SetValue) == "function" then
            -- ถ้ library ของคุณมีระบบ callback แยก ใส่ callback ที่ตัว library นั้นได้ที่นี่ (ไม่สามารถ generalize ได้ทั้งหมด)
            -- Fallback: initial sync
            Main.Visible = Options[toggleKey].Value or false
        end
    end

    -- ตั้งค่าเริ่มต้นเป็นปิด (ผู้ใช้สามารถแก้ Default ใน AddToggle ได้)
    if type(Options) == "table" and Options[toggleKey] then
        if type(Options[toggleKey].SetValue) == "function" then
            pcall(function() Options[toggleKey]:SetValue(false) end)
        else
            pcall(function() Options[toggleKey].Value = false end)
        end
    elseif externalToggle and type(externalToggle.SetValue) == "function" then
        pcall(function() externalToggle:SetValue(false) end)
    end
else
    -- ===== Fallback: Open/Close external button (ถ้าไม่มี Toggle UI) =====
    local OpenClose = Instance.new("TextButton")
    OpenClose.Name = "OpenClose"
    OpenClose.Parent = ATGAFK
    OpenClose.Size = UDim2.new(0, 220, 0, 36)
    OpenClose.Position = UDim2.new(0.35, 0, 0.88, 0)
    OpenClose.AnchorPoint = Vector2.new(0.5, 0.5)
    OpenClose.BackgroundColor3 = Color3.fromRGB(45,45,45)
    OpenClose.Font = Enum.Font.GothamBold
    OpenClose.Text = "Open / Close"
    OpenClose.TextSize = 14
    OpenClose.TextColor3 = Color3.fromRGB(255,255,255)

    local UICorner_Open = Instance.new("UICorner", OpenClose)
    UICorner_Open.CornerRadius = UDim.new(0, 8)

    local openConn = OpenClose.MouseButton1Click:Connect(function()
        local target = not Main.Visible
        if target then
            Main.Visible = true
            Main.Position = UDim2.new(0.35, 0, 0.38, 0)
            Main.BackgroundTransparency = 1
            TweenService:Create(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            Main.Size = UDim2.new(0, 240, 0, 120)
            TweenService:Create(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 320, 0, 130)}):Play()
        else
            local tw = TweenService:Create(Main, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
            tw:Play()
            tw.Completed:Connect(function()
                Main.Visible = false
                Main.BackgroundTransparency = 0
            end)
        end
        -- sync กับ external toggle ถ้ามี (ปลอดภัย)
        syncToggleState(Main.Visible)
    end)
    addConnection(openConn)
end

-- ===== Draggable (smooth with Tween) =====
do
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local dragTween = nil

    local titleInputBeganConn = Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    addConnection(titleInputBeganConn)

    local userInputChangedConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            if dragTween then
                pcall(function() dragTween:Cancel() end)
            end
            dragTween = TweenService:Create(Main, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos})
            dragTween:Play()
        end
    end)
    addConnection(userInputChangedConn)
end

-- ===== Cleanup on script disable / player respawn =====
local function cleanup()
    disableAntiAfk()
    -- disconnect stored connections
    for _, c in ipairs(connections) do
        if c and c.Connected then
            pcall(function() c:Disconnect() end)
        end
    end
    connections = {}
end

Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer then
        cleanup()
    end
end)


-- ============================
-- Anti-AFK
-- ============================
do
    local vu = nil
    local function enableAntiAFK(enable)
        if enable then
            if not vu then pcall(function() vu = game:GetService("VirtualUser") end) end
            if vu then
                Players.LocalPlayer.Idled:Connect(function()
                    pcall(function() vu:Button2Down(Vector2.new(0,0)); task.wait(1); vu:Button2Up(Vector2.new(0,0)) end)
                end)
            end
        end
    end

    local antiAFKToggle = Tabs.AFK:AddToggle("AntiAFKToggle", { Title = "Anti-AFK", Default = true })
    antiAFKToggle:OnChanged(function(v) enableAntiAFK(v) end)
    antiAFKToggle:SetValue(true)
    enableAntiAFK(true)
end

local Humanoid

-- ค่าเริ่มต้น
local CurrentWalkSpeed = 16
local CurrentJumpPower = 50

-- ฟังก์ชันหา Humanoid
local function getHumanoid()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:FindFirstChildWhichIsA("Humanoid")
end

-- ฟังก์ชันเซ็ต WalkSpeed
local function setWalkSpeed(v)
    CurrentWalkSpeed = v
    Humanoid = getHumanoid()
    if Humanoid then
        Humanoid.WalkSpeed = v
    end
end

-- ฟังก์ชันเซ็ต JumpPower
local function setJumpPower(v)
    CurrentJumpPower = v
    Humanoid = getHumanoid()
    if Humanoid then
        Humanoid.JumpPower = v
    end
end

-- อัปเดต Humanoid ทุกครั้งที่ตัวละครตาย/รีสปอน
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1) -- รอโหลด Humanoid ให้เสร็จ
    Humanoid = getHumanoid()
    if Humanoid then
        Humanoid.WalkSpeed = CurrentWalkSpeed
        Humanoid.JumpPower = CurrentJumpPower
    end
end)

-- Loop ย้ำค่าตลอด (กันเกมรีเซ็ต)
RunService.Stepped:Connect(function()
    Humanoid = getHumanoid()
    if Humanoid then
        if Humanoid.WalkSpeed ~= CurrentWalkSpeed then
            Humanoid.WalkSpeed = CurrentWalkSpeed
        end
        if Humanoid.JumpPower ~= CurrentJumpPower then
            Humanoid.JumpPower = CurrentJumpPower
        end
    end
end)

-- === UI Slider ===
local speedSlider = Tabs.Players:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed",
    Default = 30,
    Min = 8,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        setWalkSpeed(Value)
    end
})
speedSlider:OnChanged(setWalkSpeed)

local jumpSlider = Tabs.Players:AddSlider("JumpPowerSlider", {
    Title = "JumpPower",
    Default = 50,
    Min = 10,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        setJumpPower(Value)
    end
})
jumpSlider:OnChanged(setJumpPower)

-- -----------------------
-- Setup
-- -----------------------
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- state table
local state = {
    flyEnabled = false,
    noclipEnabled = false,
    espEnabled = false,
    espTable = {}
}

-- ใช้ Fluent:Notify แทน
local function notify(title, content, duration)
    Fluent:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3
    })
end

-- Fly & Noclip (improved, stable)
do
    state = state or {}
    state.flyEnabled = state.flyEnabled or false
    state.noclipEnabled = state.noclipEnabled or false

    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local bindName = "ATG_FlyStep"
    local fly = {
        bv = nil,
        bg = nil,
        speed = 60,           -- default speed (can be adjusted by slider)
        smoothing = 0.35,     -- lerp for velocity smoothing
        bound = false
    }
    local savedCanCollide = {} -- map part -> bool (to restore when disabling noclip)

    local function getHRP(timeout)
        local char = LocalPlayer.Character
        if not char then
            char = LocalPlayer.CharacterAdded:Wait()
        end
        timeout = timeout or 5
        local ok, hrp = pcall(function() return char:WaitForChild("HumanoidRootPart", timeout) end)
        if ok and hrp then return hrp end
        return nil
    end

    local function createForces(hrp)
        if not hrp or not hrp.Parent then return end
        if not fly.bv then
            fly.bv = Instance.new("BodyVelocity")
            fly.bv.Name = "ATG_Fly_BV"
            fly.bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            fly.bv.Velocity = Vector3.new(0,0,0)
            fly.bv.P = 1250
            fly.bv.Parent = hrp
        else
            fly.bv.Parent = hrp
        end

        if not fly.bg then
            fly.bg = Instance.new("BodyGyro")
            fly.bg.Name = "ATG_Fly_BG"
            fly.bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            fly.bg.CFrame = hrp.CFrame
            fly.bg.Parent = hrp
        else
            fly.bg.Parent = hrp
        end
    end

    local function destroyForces()
        if fly.bv then
            pcall(function() fly.bv:Destroy() end)
            fly.bv = nil
        end
        if fly.bg then
            pcall(function() fly.bg:Destroy() end)
            fly.bg = nil
        end
    end

    local function bindFlyStep()
        if fly.bound then return end
        fly.bound = true
        RunService:BindToRenderStep(bindName, Enum.RenderPriority.Character.Value + 1, function()
            if Fluent and Fluent.Unloaded then
                -- cleanup if UI unloaded
                destroyForces()
                if fly.bound then
                    pcall(function() RunService:UnbindFromRenderStep(bindName) end)
                    fly.bound = false
                end
                return
            end

            if not state.flyEnabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp or not fly.bv or not fly.bg then return end

            local cam = workspace.CurrentCamera
            if not cam then return end
            local camCF = cam.CFrame

            local moveDir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0,1,0) end

            local targetVel = Vector3.new(0,0,0)
            if moveDir.Magnitude > 0 then
                targetVel = moveDir.Unit * fly.speed
            end

            -- smooth the velocity so it's not jittery
            fly.bv.Velocity = fly.bv.Velocity:Lerp(targetVel, fly.smoothing)
            -- make gyro follow camera for natural facing
            fly.bg.CFrame = camCF
        end)
    end

    local function unbindFlyStep()
        if fly.bound then
            pcall(function() RunService:UnbindFromRenderStep(bindName) end)
            fly.bound = false
        end
    end

    -- enableFly: create forces + bind loop
    local function enableFly(enable)
        state.flyEnabled = enable and true or false

        if enable then
            local hrp = getHRP(5)
            if not hrp then
                notify("Fly", "ไม่พบ HumanoidRootPart", 3)
                state.flyEnabled = false
                return
            end
            createForces(hrp)
            bindFlyStep()
            notify("Fly", "Fly enabled", 3)
        else
            destroyForces()
            unbindFlyStep()
            notify("Fly", "Fly disabled", 2)
        end
    end

    -- ✅ Noclip เวอร์ชันอัปเกรด (Smooth + Safe)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local state = state or { noclipEnabled = false }
local savedCanCollide = {}
local noclipConn = nil

local function setNoclip(enable)
    if enable == state.noclipEnabled then return end -- ไม่ต้องทำซ้ำ
    state.noclipEnabled = enable

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChildOfClass("Humanoid") then
        warn("[Noclip] Character not ready")
        return
    end

    if enable then
        -- 🔥 เปิด Noclip
        savedCanCollide = {}

        -- ปิดการชนทุกส่วนของตัวละคร
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                savedCanCollide[part] = part.CanCollide
                part.CanCollide = false
            end
        end

        -- ทำให้ Noclip ต่อเนื่องทุกเฟรม (กันหลุด)
        noclipConn = RunService.Stepped:Connect(function()
            local c = LocalPlayer.Character
            if c then
                for _, part in ipairs(c:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)

        notify("Noclip", "✅ Enabled", 2.5)

    else
        -- 🧊 ปิด Noclip
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end

        for part, val in pairs(savedCanCollide) do
            if part and part.Parent then
                part.CanCollide = val
            end
        end
        savedCanCollide = {}
        notify("Noclip", "❌ Disabled", 2)
    end
end

-- ♻️ Auto reapply on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    if state.noclipEnabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        notify("Noclip", "Re-enabled after respawn", 2)
    end
end)


    -- Re-apply noclip and fly on respawn if toggled
    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.15) -- wait parts spawn
        if state.noclipEnabled then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = false end)
                end
            end
        end
        if state.flyEnabled then
            -- recreate forces on new HRP
            local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
            if hrp then
                createForces(hrp)
            end
            bindFlyStep()
        end
    end)

    -- UI: toggle, slider, keybind
    local flyToggle = Tabs.Players:AddToggle("FlyToggle", { Title = "Fly", Default = false })
    flyToggle:OnChanged(function(v) enableFly(v) end)

    local flySpeedSlider = Tabs.Players:AddSlider("FlySpeedSlider", {
        Title = "Fly Speed",
        Description = "ปรับความเร็วการบิน",
        Default = fly.speed,
        Min = 10,
        Max = 3500,
        Rounding = 0,
        Callback = function(v) fly.speed = v end
    })
    flySpeedSlider:SetValue(fly.speed)

    local noclipToggle = Tabs.Players:AddToggle("NoclipToggle", { Title = "Noclip", Default = false })
    noclipToggle:OnChanged(function(v) setNoclip(v) end)

    Tabs.Players:AddKeybind("FlyKey", {
        Title = "Fly Key (Toggle)",
        Mode = "Toggle",
        Default = "None",
        Callback = function(val)
            enableFly(val)
            -- sync UI toggle
            pcall(function() flyToggle:SetValue(val) end)
        end
    })

    -- cleanup if Fluent unloads (safety)
    task.spawn(function()
        while true do
            if Fluent and Fluent.Unloaded then
                -- force disable
                enableFly(false)
                setNoclip(false)
                break
            end
            task.wait(0.5)
        end
    end)
end


-- Improved ESP (no size/distance sliders)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- state init (keep previous values if exist)
state = state or {}
state.espTable = state.espTable or {}
state.espEnabled = state.espEnabled or false
state.espColor = state.espColor or Color3.fromRGB(255, 50, 50)
state.showName = (state.showName == nil) and true or state.showName
state.showHealth = (state.showHealth == nil) and true or state.showHealth
state.showDistance = (state.showDistance == nil) and true or state.showDistance

local function getHRP(pl)
    if not pl or not pl.Character then return nil end
    return pl.Character:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(char)
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function createESPForPlayer(p)
    if state.espTable[p] then return end
    local info = { billboard = nil, updateConn = nil, charConn = nil }
    state.espTable[p] = info

    local function attachToCharacter(char)
        if not state.espEnabled then return end
        if not char or not char.Parent then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        -- cleanup old if exists
        pcall(function()
            if info.updateConn then info.updateConn:Disconnect() info.updateConn = nil end
            if info.billboard then info.billboard:Destroy() info.billboard = nil end
        end)

        -- create billboard
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ATG_ESP"
        billboard.Size = UDim2.new(0, 200, 0, 36)
        billboard.StudsOffset = Vector3.new(0, 2.6, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Name = "ATG_ESP_Label"
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.Text = ""
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.TextColor3 = state.espColor
        label.TextStrokeTransparency = 0.4
        label.TextStrokeColor3 = Color3.new(0,0,0)
        label.TextWrapped = true
        label.Parent = billboard

        info.billboard = billboard

        -- live update (RenderStepped)
        info.updateConn = RunService.RenderStepped:Connect(function()
            if not state.espEnabled then return end
            if not p or not p.Character or not p.Character.Parent then
                label.Text = ""
                return
            end

            local parts = {}
            if state.showName then table.insert(parts, p.DisplayName or p.Name) end

            local hum = getHumanoid(p.Character)
            if state.showHealth and hum then
                table.insert(parts, "HP:" .. math.floor(hum.Health))
            end

            if state.showDistance then
                local myHRP = getHRP(LocalPlayer)
                local theirHRP = getHRP(p)
                if myHRP and theirHRP then
                    local d = math.floor((myHRP.Position - theirHRP.Position).Magnitude)
                    table.insert(parts, "[" .. d .. "m]")
                end
            end

            label.Text = table.concat(parts, " | ")
            label.TextColor3 = state.espColor
        end)
    end

    -- attach if character exists now
    if p.Character and p.Character.Parent then
        attachToCharacter(p.Character)
    end

    -- reconnect on respawn
    info.charConn = p.CharacterAdded:Connect(function(char)
        task.wait(0.05)
        if state.espEnabled then
            attachToCharacter(char)
        end
    end)
end

local function removeESPForPlayer(p)
    local info = state.espTable[p]
    if not info then return end
    pcall(function()
        if info.updateConn then info.updateConn:Disconnect() info.updateConn = nil end
        if info.charConn then info.charConn:Disconnect() info.charConn = nil end
        if info.billboard then info.billboard:Destroy() info.billboard = nil end
    end)
    state.espTable[p] = nil
end

-- UI: toggle/color and show options (no size/distance sliders)
local espToggle = Tabs.ESP:AddToggle("ESPToggle", { Title = "ESP", Default = state.espEnabled })
espToggle:OnChanged(function(v)
    state.espEnabled = v
    if not v then
        for pl,_ in pairs(state.espTable) do removeESPForPlayer(pl) end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then createESPForPlayer(p) end
        end
    end
end)

local espColorPicker = Tabs.ESP:AddColorpicker("ESPColor", { Title = "ESP Color", Default = state.espColor })
espColorPicker:OnChanged(function(c) state.espColor = c end)

Tabs.ESP:AddToggle("ESP_ShowName", { Title = "Show Name", Default = state.showName }):OnChanged(function(v) state.showName = v end)
Tabs.ESP:AddToggle("ESP_ShowHealth", { Title = "Show Health", Default = state.showHealth }):OnChanged(function(v) state.showHealth = v end)
Tabs.ESP:AddToggle("ESP_ShowDistance", { Title = "Show Distance", Default = state.showDistance }):OnChanged(function(v) state.showDistance = v end)

-- handle players joining/leaving
Players.PlayerAdded:Connect(function(p)
    if state.espEnabled and p ~= LocalPlayer then createESPForPlayer(p) end
end)
Players.PlayerRemoving:Connect(function(p) removeESPForPlayer(p) end)



-- -----------------------
-- Teleport to Player (Dropdown + Button)
-- -----------------------
local playerListDropdown = Tabs.Teleport:AddDropdown("TeleportToPlayerDropdown", {
    Title = "Select Player to Teleport",
    Values = {},
    Multi = false,
    Default = 1
})

local function refreshPlayerDropdown()
    local vals = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(vals, p.Name)
        end
    end
    if #vals == 0 then
        vals = {"No other players"}
        playerListDropdown:SetValues(vals)
        playerListDropdown:SetValue(vals[1])
        return
    end
    playerListDropdown:SetValues(vals)
    playerListDropdown:SetValue(vals[1])
end

-- init and update on join/leave
refreshPlayerDropdown()
Players.PlayerAdded:Connect(function(p)
    task.delay(0.5, refreshPlayerDropdown)
end)
Players.PlayerRemoving:Connect(function(p)
    task.delay(0.5, refreshPlayerDropdown)
end)

Tabs.Teleport:AddButton({
    Title = "Teleport to Selected Player",
    Description = "Teleport to the player selected in the dropdown",
    Callback = function()
        local sel = playerListDropdown.Value
        if not sel or sel == "No other players" then notify("Teleport", "No player selected", 3); return end
        local target = Players:FindFirstChild(sel)
        if not target then notify("Teleport", "Player not found", 3); return end
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                notify("Teleport", "Teleported to "..target.Name, 3)
            end
        else
            notify("Teleport", "Target character not available", 3)
        end
    end
})

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FluentScriptHub")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
Window:SelectTab(1)

Fluent:Notify({
    Title = "ATG Tools Hub",
    Content = "The script has been loaded.",
    Duration = 8
})