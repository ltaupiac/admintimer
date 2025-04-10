# AdminTimer.spoon

A Hammerspoon Spoon that shows the current admin status of the user (👤 / ⭐️), with a countdown timer (default 4h), and allows triggering elevation via Jamf Self Service.

## Features

- 👤 indicates the user is not an admin
- ⭐️ + countdown indicates admin mode is active
- Admin elevation is triggered via Jamf (self service policy)
- Admin mode timeout tracked with local file timestamp
- Automatically exits admin mode after 4h (or configurable)

## Installation

1. Clone this repo into your Spoons directory:

```bash
git clone https://github.com/ltaupiac/AdminTimer.spoon ~/.hammerspoon/Spoons/AdminTimer.spoon
```

## Configuration

```lua
hs.loadSpoon("AdminTimer")
spoon.AdminTimer:start()
```
