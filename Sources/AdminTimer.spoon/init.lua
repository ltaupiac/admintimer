local obj = {}
obj.__index = obj

-- 🔧 Nom affiché dans la console Hammerspoon
obj.name = "AdminTimer"
obj.version = "1.0"
obj.author = "Laurent Taupiac"
obj.license = "MIT"
obj.homepage = "https://github.com/ltaupiac/AdminTimer.spoon"

-- 🧠 Variables internes
local menubar
local timerFile = os.getenv("HOME") .. "/.admin_timer_start"
local DURATION
local updateTimer
local log
local username
local jamfScriptUrl

-- 🔍 Fonction pour tester le groupe admin
local function isAdmin()
    local out = hs.execute("dseditgroup -o checkmember admin " .. username)
    return out:match("yes") ~= nil
end

-- 🕓 Update de l’icône + timer
local function updateMenu()
    log.d("Update menu")
    if not menubar then return end
    log.d("Admin status analyze")
    local icon = "👤"
    local title = ""
    local now = os.time()

    if isAdmin() then
        log.d("In admin group")
        local attr = hs.fs.attributes(timerFile)
        hs.inspect(attr)
        if attr then
            local created = attr.creation
            local remaining = DURATION - (now - created)
            if remaining <= 0 then
                icon = "⭐️ Expired"
                os.remove(timerFile)
            else
                local h = math.floor(remaining / 3600)
                local m = math.floor((remaining % 3600) / 60)
                icon = string.format("⭐️ %d:%02d", h, m)
            end
        else
            icon = "⭐️"
        end
    else
        log.d("Not in admin group")
        os.remove(timerFile)
    end

    menubar:setTitle(icon)
end

-- ⚡️ Action au clic
local function handleClick()
    log.i("Click")
    if isAdmin() then return end
    log.d("Not in admin groupe, require priviledge with JAMF script")
    -- En attendant de savoir pourquoi le script ne fonctionne pas@
    hs.alert("Admin elevation initiated via Jamf...")

    local base = [[
open '%s'
MAX_WAIT=20
while ! pgrep -x "jamfHelper" >/dev/null && (( MAX_WAIT > 0 )); do
    sleep 1
    ((MAX_WAIT--))
done
if pgrep -x "jamfHelper" >/dev/null; then
    sudo pkill -x jamfHelper
fi
if pgrep -x "Self Service" >/dev/null; then
    osascript -e 'quit app "Self Service"'
fi
]]
    local script = string.format(base, jamfScriptUrl)
    
    hs.task.new("/bin/zsh", function()
        local f = io.open(timerFile, "w")
        if f then f:close() end
        updateMenu()
    end, { "-c", script }):start()
end

-- 🚀 Méthode d’activation
function obj:start(opts)
    opts = opts or {}
    print("--------------------Admin Timer Start--------------------")
    local logLevel = opts.logLevel or "info"
    local defaultDuration = 4 * 3600

    DURATION = opts.duration or defaultDuration
    jamfScriptUrl = opts.jamfScriptUrl or "jamfselfservice://content?entity=policy&id=340&action=execute"

    print("AdminTimer parameters")
    print("logLevel:", logLevel)
    print("jamfScriptUrl:", jamfScriptUrl)
    print("duration:", DURATION, "seconds")
    print("--------------------/Admin Timer Start--------------------")
    
    log = hs.logger.new("AdminMode", logLevel)
    log.d("timerFile", timerFile)
    menubar = hs.menubar.new()
    username = hs.execute("whoami")
    menubar:setClickCallback(handleClick)
    updateMenu()
    updateTimer = hs.timer.doEvery(60, updateMenu)
end

-- 🧹 Méthode de nettoyage
function obj:stop()
    if menubar then menubar:delete() end
    if updateTimer then updateTimer:stop() end
end

return obj
