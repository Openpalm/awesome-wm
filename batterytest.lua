-- Design:
-- getBatteryCapacity() returns integer value from charge capacity
-- getBatteryCharge() returns false if discharging, else true
-- isDischarging() returns true if discharging, else false (convenience)
-- genBatteryStatus() returns formatted string for widget view
-- statusTimer()    will it blend? not sure if this really works. but we'll see.
--                  beats doing it through rc.lua.

--disabled during testing
--local wibox = require("wibox")
--battery_widget = wibox.widget.textbox()
--battery_widget:set_align("right")

local capacityCMD = "cat /sys/class/power_supply/BAT0/capacity"
local statusCMD = "cat /sys/class/power_supply/BAT0/status"

local function getBatteryCapacity()
    local file = io.popen(capacityCMD)
    -- capacity file has a single integer value.
    local output = file:read()
    file:close()
    return tonumber(output)
end
local function getBatteryCharge()
    -- Charge status is either Distcharging or Unknown. 
    -- (atleast on my machine)
    -- true if charging
    -- false if discharging
    local file = io.popen(statusCMD)
    local output = file:read("*all")
    file:close()
    if string.find(output,"Dis") then return false
    end
    return true
end
local function isDischarging()
    -- Novelty function for logical convenience
    return not getBatteryCharge()
end
function genBatteryStatus()
    local capacity = getBatteryCapacity()
    local power=""
    if capacity <= 20 then capacity = "<span color='orange'>" .. capacity .. "%" .. "</span>"
    else capacity = "<span color='white'>" .. capacity .. "%" .. "</span>"
    end
    if isDischarging() then power= "<span color='red'>Discharging ☹</span>"
    else power = "<span color='yellow'>Charging ☢</span>"
    end
    return (power .. " " .. capacity)
end

function updateLoop(interval) -- seconds
    os.execute("sleep " .. interval)
    updateBattery1()
    updateLoop(interval)
end

function updateBattery1()
    local battery = genBatteryStatus()
    print(battery)
end


function updateBattery(widget)
    local battery = genBatteryStatus()
    print(battery)
    widget:set_markup(battery)
end

updateLoop(1)






-- updateBattery(battery_widget)

-- mytimer = timer.get({ timeout = 0.5 })
-- mytimer:connect_signal("timeout", function () genBatteryStatus() end)
-- mytimer:start()
