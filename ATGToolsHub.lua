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

-- ATG ESP (optimized) — patched version (UI sync + Reset fixes)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- state + config (เก็บค่า default ที่เหมาะสม)
local state = state or {}
state.espTable = state.espTable or {}
state.pools = state.pools or {billboards = {}, highlights = {}}
state.config = state.config or {
    enabled = false,
    updateRate = 10,
    maxDistance = 250,
    maxVisibleCount = 60,
    showName = true,
    showHealth = true,
    showDistance = true,
    espColor = Color3.fromRGB(255, 50, 50),
    labelScale = 1,
    alwaysOnTop = false,
    smartHideCenter = true,
    centerHideRadius = 0.12,
    raycastOcclusion = false,
    raycastInterval = 0.6,
    highlightEnabled = false,
    highlightFillTransparency = 0.3,
    highlightOutlineTransparency = 0.3,
    teamCheck = true,
    ignoreLocalPlayer = true,
}

-- Helpers: pooling...
local function borrowBillboard()
    local pool = state.pools.billboards
    if #pool > 0 then
        return table.remove(pool)
    else
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ATG_ESP"
        billboard.Size = UDim2.new(0, 150, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 2.6, 0)
        billboard.Adornee = nil
        billboard.AlwaysOnTop = state.config.alwaysOnTop
        billboard.ResetOnSpawn = false

        local label = Instance.new("TextLabel")
        label.Name = "ATG_ESP_Label"
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.Text = ""
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 0.4
        label.TextStrokeColor3 = Color3.new(0,0,0)
        label.TextWrapped = true
        label.Parent = billboard

        return {billboard = billboard, label = label}
    end
end

local function returnBillboard(obj)
    if not obj or not obj.billboard then return end
    pcall(function()
        obj.label.Text = ""
        obj.billboard.Parent = nil
        obj.billboard.Adornee = nil
    end)
    table.insert(state.pools.billboards, obj)
end

local function borrowHighlight()
    local pool = state.pools.highlights
    if #pool > 0 then
        return table.remove(pool)
    else
        local hl = Instance.new("Highlight")
        hl.Name = "ATG_ESP_Highlight"
        hl.Enabled = false
        return hl
    end
end

local function returnHighlight(hl)
    if not hl then return end
    pcall(function()
        hl.Enabled = false
        hl.Adornee = nil
        hl.Parent = nil
    end)
    table.insert(state.pools.highlights, hl)
end

-- util
local function getHRP(player)
    if not player or not player.Character then return nil end
    return player.Character:FindFirstChild("HumanoidRootPart")
end
local function getHumanoid(char)
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end
local function isSameTeam(a,b)
    if not a or not b then return false end
    if a.Team and b.Team and a.Team == b.Team then return true end
    return false
end

-- entries
local function ensureEntryForPlayer(p)
    if not p then return end
    local uid = p.UserId
    if state.espTable[uid] then return state.espTable[uid] end

    local info = {
        player = p,
        billboardObj = nil,
        highlightObj = nil,
        lastVisible = false,
        lastScreenPos = Vector2.new(0,0),
        lastDistance = math.huge,
        lastRaycast = -999,
        connected = true,
        charConn = nil
    }

    info.charConn = p.CharacterAdded:Connect(function(char)
        task.wait(0.05)
        if info.billboardObj and info.billboardObj.billboard then
            local head = char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
            if head then info.billboardObj.billboard.Adornee = head end
        end
        if info.highlightObj then info.highlightObj.Adornee = char end
    end)

    state.espTable[uid] = info
    return info
end

local function cleanupEntry(uid)
    local info = state.espTable[uid]
    if not info then return end
    pcall(function()
        if info.charConn then info.charConn:Disconnect() info.charConn = nil end
        if info.billboardObj then returnBillboard(info.billboardObj) info.billboardObj = nil end
        if info.highlightObj then returnHighlight(info.highlightObj) info.highlightObj = nil end
    end)
    state.espTable[uid] = nil
end

-- visibility
local function shouldShowFor(info)
    if not info or not info.player then return false end
    local p = info.player
    if not p.Character or not p.Character.Parent then return false end
    if state.config.ignoreLocalPlayer and p == LocalPlayer then return false end
    if state.config.teamCheck and isSameTeam(p, LocalPlayer) then return false end

    local myHRP = getHRP(LocalPlayer)
    local theirHRP = getHRP(p)
    if not myHRP or not theirHRP then return false end

    local dist = (myHRP.Position - theirHRP.Position).Magnitude
    if dist > state.config.maxDistance then return false end

    local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("UpperTorso") or theirHRP
    if not head then return false end
    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
    if not onScreen then return false end

    if state.config.smartHideCenter then
        local sx = screenPos.X / Camera.ViewportSize.X
        local sy = screenPos.Y / Camera.ViewportSize.Y
        local dx = sx - 0.5
        local dy = sy - 0.5
        local d = math.sqrt(dx*dx + dy*dy)
        if d < state.config.centerHideRadius then return false end
    end

    if state.config.raycastOcclusion then
        local now = tick()
        if now - info.lastRaycast >= state.config.raycastInterval then
            info.lastRaycast = now
            local origin = Camera.CFrame.Position
            local direction = (head.Position - origin)
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            local r = workspace:Raycast(origin, direction, rayParams)
            if r and r.Instance and not r.Instance:IsDescendantOf(p.Character) then return false end
        end
    end

    return true
end

-- label text
local function buildLabelText(p)
    local parts = {}
    if state.config.showName then table.insert(parts, p.DisplayName or p.Name) end
    local hum = getHumanoid(p.Character)
    if state.config.showHealth and hum then table.insert(parts, "HP:" .. math.floor(hum.Health)) end
    if state.config.showDistance then
        local myHRP = getHRP(LocalPlayer)
        local theirHRP = getHRP(p)
        if myHRP and theirHRP then
            local d = math.floor((myHRP.Position - theirHRP.Position).Magnitude)
            table.insert(parts, "[" .. d .. "m]")
        end
    end
    return table.concat(parts, " | ")
end

-- centralized updater
local accumulator = 0
local updateInterval = 1 / math.max(1, state.config.updateRate)
local lastVisibleCount = 0

local function performUpdate(dt)
    accumulator = accumulator + dt
    updateInterval = 1 / math.max(1, state.config.updateRate)
    if accumulator < updateInterval then return end
    accumulator = accumulator - updateInterval

    local visibleCount = 0
    local players = Players:GetPlayers()
    for _, p in ipairs(players) do
        if p ~= LocalPlayer or not state.config.ignoreLocalPlayer then ensureEntryForPlayer(p) end
    end

    for uid, info in pairs(state.espTable) do
        local p = info.player
        if not p or not p.Parent then
            cleanupEntry(uid)
        else
            local canShow = state.config.enabled and shouldShowFor(info)
            if canShow and visibleCount >= state.config.maxVisibleCount then canShow = false end

            if canShow then
                visibleCount = visibleCount + 1
                if not info.billboardObj then
                    local obj = borrowBillboard()
                    local head = p.Character and (p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("UpperTorso") or getHRP(p))
                    if head then
                        obj.billboard.Parent = head
                        obj.billboard.Adornee = head
                        obj.billboard.AlwaysOnTop = state.config.alwaysOnTop
                        info.billboardObj = obj
                    else
                        returnBillboard(obj)
                        info.billboardObj = nil
                    end
                end

                if state.config.highlightEnabled and not info.highlightObj then
                    local hl = borrowHighlight()
                    hl.Adornee = p.Character
                    hl.Parent = p.Character
                    hl.Enabled = true
                    hl.FillColor = state.config.espColor
                    hl.FillTransparency = state.config.highlightFillTransparency
                    hl.OutlineColor = state.config.espColor
                    hl.OutlineTransparency = state.config.highlightOutlineTransparency
                    info.highlightObj = hl
                elseif (not state.config.highlightEnabled) and info.highlightObj then
                    returnHighlight(info.highlightObj)
                    info.highlightObj = nil
                end

                if info.billboardObj and info.billboardObj.label then
                    local txt = buildLabelText(p)
                    if info.billboardObj.label.Text ~= txt then info.billboardObj.label.Text = txt end
                    if info.billboardObj.label.TextColor3 ~= state.config.espColor then info.billboardObj.label.TextColor3 = state.config.espColor end
                    info.billboardObj.billboard.Size = UDim2.new(0, math.clamp(120 + (#txt * 4), 100, 280), 0, math.clamp(16 * state.config.labelScale, 12, 48))
                    info.billboardObj.billboard.AlwaysOnTop = state.config.alwaysOnTop
                end
            else
                if info.billboardObj then returnBillboard(info.billboardObj) info.billboardObj = nil end
                if info.highlightObj then returnHighlight(info.highlightObj) info.highlightObj = nil end
            end
        end
    end

    lastVisibleCount = visibleCount
end

-- connect heartbeat
if state._espHeartbeatConn then pcall(function() state._espHeartbeatConn:Disconnect() end) state._espHeartbeatConn = nil end
state._espHeartbeatConn = RunService.Heartbeat:Connect(performUpdate)

-- cleanup on leave
Players.PlayerRemoving:Connect(function(p) if not p then return end cleanupEntry(p.UserId) end)

-- UI sync helpers (รองรับหลายไลบรารี)
local uiRefs = {} -- store widgets by key

local function trySetWidgetValue(widget, val)
    if not widget then return end
    pcall(function()
        -- common APIs across various UI libs
        if widget.SetValue then widget:SetValue(val) end
        if widget.Set then widget:Set(val) end
        if widget.SetState then widget:SetState(val) end
        if widget.SetValueNoCallback then widget:SetValueNoCallback(val) end
        -- some libs store .Value property
        if widget.Value ~= nil then widget.Value = val end
    end)
end

-- function to apply config to runtime (and update visuals immediately)
local function applyConfigToState(cfg)
    -- shallow copy allowed (cfg is a table)
    for k, v in pairs(cfg) do state.config[k] = v end

    -- immediate side-effects
    updateInterval = 1 / math.max(1, state.config.updateRate)

    -- update existing billboards / highlights
    for uid, info in pairs(state.espTable) do
        if info.billboardObj and info.billboardObj.billboard then
            local bb = info.billboardObj.billboard
            local label = info.billboardObj.label
            label.TextColor3 = state.config.espColor
            bb.AlwaysOnTop = state.config.alwaysOnTop
            bb.Size = UDim2.new(0, math.clamp(120 + (#label.Text * 4), 100, 280), 0, math.clamp(16 * state.config.labelScale, 12, 48))
        end
        if info.highlightObj then
            local hl = info.highlightObj
            hl.FillColor = state.config.espColor
            hl.FillTransparency = state.config.highlightFillTransparency
            hl.OutlineColor = state.config.espColor
            hl.OutlineTransparency = state.config.highlightOutlineTransparency
            hl.Enabled = state.config.highlightEnabled
            if not state.config.highlightEnabled then
                returnHighlight(hl)
                info.highlightObj = nil
            end
        end
    end
end

-- Exposed API
local ESP_API = {}

function ESP_API.ToggleEnabled(v)
    state.config.enabled = v
    if not v then
        for uid,info in pairs(state.espTable) do
            if info.billboardObj then returnBillboard(info.billboardObj) info.billboardObj = nil end
            if info.highlightObj then returnHighlight(info.highlightObj) info.highlightObj = nil end
        end
    end
end

function ESP_API.SetColor(c)
    state.config.espColor = c
    -- live update
    for _,info in pairs(state.espTable) do
        if info.billboardObj and info.billboardObj.label then info.billboardObj.label.TextColor3 = c end
        if info.highlightObj then
            info.highlightObj.FillColor = c
            info.highlightObj.OutlineColor = c
        end
    end
end

function ESP_API.SetShowName(v) state.config.showName = v end
function ESP_API.SetShowHealth(v) state.config.showHealth = v end
function ESP_API.SetShowDistance(v) state.config.showDistance = v end
function ESP_API.SetUpdateRate(v)
    state.config.updateRate = math.clamp(math.floor(v), 1, 60)
    updateInterval = 1 / state.config.updateRate
end
function ESP_API.SetMaxDistance(v) state.config.maxDistance = math.max(20, v) end
function ESP_API.SetLabelScale(v)
    state.config.labelScale = math.clamp(v, 0.5, 3)
    -- apply to existing labels
    for _,info in pairs(state.espTable) do
        if info.billboardObj and info.billboardObj.label and info.billboardObj.billboard then
            local label = info.billboardObj.label
            info.billboardObj.billboard.Size = UDim2.new(0, math.clamp(120 + (#label.Text * 4), 100, 280), 0, math.clamp(16 * state.config.labelScale, 12, 48))
        end
    end
end
function ESP_API.SetAlwaysOnTop(v)
    state.config.alwaysOnTop = v
    for _,info in pairs(state.espTable) do
        if info.billboardObj and info.billboardObj.billboard then info.billboardObj.billboard.AlwaysOnTop = v end
    end
end
function ESP_API.SetHighlightEnabled(v)
    state.config.highlightEnabled = v
    -- toggle highlights on existing entries
    for _,info in pairs(state.espTable) do
        if v and not info.highlightObj and info.player and info.player.Character then
            local hl = borrowHighlight()
            hl.Adornee = info.player.Character
            hl.Parent = info.player.Character
            hl.Enabled = true
            hl.FillColor = state.config.espColor
            hl.FillTransparency = state.config.highlightFillTransparency
            hl.OutlineColor = state.config.espColor
            hl.OutlineTransparency = state.config.highlightOutlineTransparency
            info.highlightObj = hl
        elseif (not v) and info.highlightObj then
            returnHighlight(info.highlightObj)
            info.highlightObj = nil
        end
    end
end
function ESP_API.SetHighlightFillTrans(v) state.config.highlightFillTransparency = math.clamp(v, 0, 1) end
function ESP_API.SetHighlightOutlineTrans(v) state.config.highlightOutlineTransparency = math.clamp(v, 0, 1) end

function ESP_API.ResetConfig()
    local defaults = {
        enabled = false,
        updateRate = 10,
        maxDistance = 250,
        maxVisibleCount = 60,
        showName = true,
        showHealth = true,
        showDistance = true,
        espColor = Color3.fromRGB(255, 50, 50),
        labelScale = 1,
        alwaysOnTop = false,
        smartHideCenter = true,
        centerHideRadius = 0.12,
        raycastOcclusion = false,
        raycastInterval = 0.6,
        highlightEnabled = false,
        highlightFillTransparency = 0.3,
        highlightOutlineTransparency = 0.3,
        teamCheck = true,
        ignoreLocalPlayer = true,
    }
    -- replace state.config
    state.config = defaults
    -- apply runtime changes
    applyConfigToState(state.config)
    -- update UI elements if present
    -- try to update known widgets in uiRefs
    pcall(function()
        trySetWidgetValue(uiRefs.ESPToggle, state.config.enabled)
        trySetWidgetValue(uiRefs.ESPColor, state.config.espColor)
        trySetWidgetValue(uiRefs.ESP_Name, state.config.showName)
        trySetWidgetValue(uiRefs.ESP_Health, state.config.showHealth)
        trySetWidgetValue(uiRefs.ESP_Distance, state.config.showDistance)
        trySetWidgetValue(uiRefs.ESP_Highlight, state.config.highlightEnabled)
        trySetWidgetValue(uiRefs.ESP_HighlightFill, state.config.highlightFillTransparency)
        trySetWidgetValue(uiRefs.ESP_HighlightOutline, state.config.highlightOutlineTransparency)
        trySetWidgetValue(uiRefs.ESP_Rate, state.config.updateRate)
        trySetWidgetValue(uiRefs.ESP_MaxDist, state.config.maxDistance)
        trySetWidgetValue(uiRefs.ESP_LabelScale, state.config.labelScale)
        trySetWidgetValue(uiRefs.ESP_AlwaysOnTop, state.config.alwaysOnTop)
    end)
end

-- expose API
_G.ATG_ESP_API = ESP_API

-- UI hookup (store refs and ensure OnChanged hooks update state)
if Tabs and Tabs.ESP then
    -- store ref for safe-set on Reset
    uiRefs.ESPToggle = Tabs.ESP:AddToggle("ESPToggle", { Title = "ESP", Default = state.config.enabled })
    if uiRefs.ESPToggle then uiRefs.ESPToggle:OnChanged(function(v) ESP_API.ToggleEnabled(v) end) end

    uiRefs.ESPColor = Tabs.ESP:AddColorpicker("ESPColor", { Title = "ESP Color", Default = state.config.espColor })
    if uiRefs.ESPColor then uiRefs.ESPColor:OnChanged(function(c) ESP_API.SetColor(c) end) end

    uiRefs.ESP_Name = Tabs.ESP:AddToggle("ESP_Name", { Title = "Show Name", Default = state.config.showName })
    if uiRefs.ESP_Name then uiRefs.ESP_Name:OnChanged(function(v) ESP_API.SetShowName(v) end) end

    uiRefs.ESP_Health = Tabs.ESP:AddToggle("ESP_Health", { Title = "Show Health", Default = state.config.showHealth })
    if uiRefs.ESP_Health then uiRefs.ESP_Health:OnChanged(function(v) ESP_API.SetShowHealth(v) end) end

    uiRefs.ESP_Distance = Tabs.ESP:AddToggle("ESP_Distance", { Title = "Show Distance", Default = state.config.showDistance })
    if uiRefs.ESP_Distance then uiRefs.ESP_Distance:OnChanged(function(v) ESP_API.SetShowDistance(v) end) end

    uiRefs.ESP_Highlight = Tabs.ESP:AddToggle("ESP_Highlight", { Title = "Highlight", Default = state.config.highlightEnabled })
    if uiRefs.ESP_Highlight then uiRefs.ESP_Highlight:OnChanged(function(v) ESP_API.SetHighlightEnabled(v) end) end

    uiRefs.ESP_HighlightFill = Tabs.ESP:AddSlider("ESP_HighlightFill", { Title = "Highlight Fill Transparency", Default = state.config.highlightFillTransparency, Min = 0, Max = 1, Rounding = 2 })
    if uiRefs.ESP_HighlightFill then uiRefs.ESP_HighlightFill:OnChanged(function(v) ESP_API.SetHighlightFillTrans(v) end) end

    uiRefs.ESP_HighlightOutline = Tabs.ESP:AddSlider("ESP_HighlightOutline", { Title = "Highlight Outline Transparency", Default = state.config.highlightOutlineTransparency, Min = 0, Max = 1, Rounding = 2 })
    if uiRefs.ESP_HighlightOutline then uiRefs.ESP_HighlightOutline:OnChanged(function(v) ESP_API.SetHighlightOutlineTrans(v) end) end

    uiRefs.ESP_Rate = Tabs.ESP:AddSlider("ESP_Rate", { Title = "Update Rate (per sec)", Default = state.config.updateRate, Min = 1, Max = 60, Rounding = 1 })
    if uiRefs.ESP_Rate then uiRefs.ESP_Rate:OnChanged(function(v) ESP_API.SetUpdateRate(v) end) end

    uiRefs.ESP_MaxDist = Tabs.ESP:AddSlider("ESP_MaxDist", { Title = "Max Distance", Default = state.config.maxDistance, Min = 250, Max = 10000, Rounding = 1 })
    if uiRefs.ESP_MaxDist then uiRefs.ESP_MaxDist:OnChanged(function(v) ESP_API.SetMaxDistance(v) end) end

    uiRefs.ESP_LabelScale = Tabs.ESP:AddSlider("ESP_LabelScale", { Title = "Label Scale", Default = state.config.labelScale, Min = 0.5, Max = 4, Rounding = 0.1 })
    if uiRefs.ESP_LabelScale then uiRefs.ESP_LabelScale:OnChanged(function(v) ESP_API.SetLabelScale(v) end) end

    uiRefs.ESP_AlwaysOnTop = Tabs.ESP:AddToggle("ESP_AlwaysOnTop", { Title = "AlwaysOnTop", Default = state.config.alwaysOnTop })
    if uiRefs.ESP_AlwaysOnTop then uiRefs.ESP_AlwaysOnTop:OnChanged(function(v) ESP_API.SetAlwaysOnTop(v) end) end

    Tabs.ESP:AddButton({
        Title = "Reset ESP Config",
        Description = "Reset to sane defaults",
        Callback = function()
            ESP_API.ResetConfig()
            print("ESP config reset. UI should be synced.")
        end
    })
end

-- end

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
