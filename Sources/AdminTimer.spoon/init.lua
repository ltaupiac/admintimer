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
local DURATION = 4 * 3600  -- 4h
local updateTimer

-- 🔍 Fonction pour tester le groupe admin
local function isAdmin()
    local out = hs.execute("dseditgroup -o checkmember -m admin $(whoami)")
    return out:match("yes") ~= nil
end

-- 🕓 Update de l’icône + timer
local function updateMenu()
    if not menubar then return end
    local icon = "👤"
    local title = ""
    local now = os.time()

    if isAdmin() then
        local attr = hs.fs.attributes(timerFile)
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
        os.remove(timerFile)
    end

    menubar:setTitle(icon)
end

-- ⚡️ Action au clic
local function handleClick()
    if isAdmin() then return end
    hs.alert("Élévation admin lancée via Jamf...")

    local script = [[
open 'jamfselfservice://content?entity=policy&id=340&action=execute'
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

    hs.task.new("/bin/zsh", function()
        local f = io.open(timerFile, "w")
        if f then f:close() end
        updateMenu()
    end, { "-c", script }):start()
end

-- 🚀 Méthode d’activation
function obj:start()
    menubar = hs.menubar.new()
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