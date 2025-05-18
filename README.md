# AdminTimer.spoon

A Hammerspoon Spoon that shows the current admin status of the user (👤 / ⭐️), with a countdown timer (default 4h), and allows triggering elevation via Jamf Self Service.

## Features

- 👤 indicates the user is not an admin
- ⭐️ + countdown indicates admin mode is active
- Admin elevation is triggered via Jamf (self service policy)
- Admin mode timeout tracked with local file timestamp
- Automatically exits admin mode after 4h (or configurable)

## Manual installation 

1. get spoon and unzip

```bash
curl -L https://github.com/ltaupiac/AdminTimer/raw/refs/heads/main/Spoons/AdminTimer.spoon.zip -o /tmp/AdminTimer.zip
unzip -o /tmp/AdminTimer.zip -d ~/.hammerspoon/Spoons/
```
2. Config init.lua
```lua
hs.spoons.use("AdminTimer")
spoon.AdminTimer:start()
```

## Configuration with SpoonInstall

**Prerequisite :**  
SpoonInstall should be installed ([github.com/Hammerspoon/SpoonInstall](https://github.com/Hammerspoon/SpoonInstall)).

### Manual installation of SpoonInstall

```bash
curl -L https://github.com/Hammerspoon/SpoonInstall/raw/master/Spoons/SpoonInstall.spoon.zip -o /tmp/SpoonInstall.zip
unzip -o /tmp/SpoonInstall.zip -d ~/.hammerspoon/Spoons/
```

**init.lua configuration to install AdminTimer :**
1. Config init.lua
```lua
hs.loadSpoon("SpoonInstall")
Install = spoon.SpoonInstall

-- Register the repository
Install.repos["AdminTimer"] = {
  desc = "AdminTimer.spoon repository",
  url = "https://github.com/ltaupiac/admintimer"
}

-- Download, load, configure and start:
Install:andUse("AdminTimer",
    {
        repo = "AdminTimer",
        start = true,
    }
)
```
