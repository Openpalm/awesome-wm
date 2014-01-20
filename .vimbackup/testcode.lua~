local function getPid(pName)
    -- get pName's pid from pgrep
    if pName == nil then return false
    else
        local fpid = io.popen("pgrep -u " .. os.getenv("USER") .. " -o " .. pName)
        local pid = fpid:read()
        fpid:close()
        return pid
    end
    return true
end

local function run(pName)
    if not getPid(pName) then
        print("executing " .. pName)
        os.execute(pName .. " &")
        return true
    end
    print("process already running.")
    return false
end

-- local p = "xterm"
-- local exe = os.execute("pgrep -u " .. os.getenv("USER") .. " -o " .. p)
-- local pid = getPid(p)

run("xterm")
