# SnapClick

<div align="center">

<img src="images/icon.png" alt="SnapClick Logo" width="128" height="128">

**The easiest and most reliable auto-clicker for macOS**

[![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)](https://www.apple.com/macos/)
[![Architecture](https://img.shields.io/badge/Apple_Silicon-arm64-green.svg)](https://support.apple.com/en-us/HT211814)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[English](README.md) | [中文](README.zh-CN.md)

</div>

---

## Why SnapClick?

I recently stumbled upon the browser version of [Command & Conquer: Red Alert 2](https://game.chronodivide.com) and discovered it runs on Mac! Triggered a wave of childhood nostalgia, I quickly found myself addicted to my first "gaming enlightenment" all over again.

However, building a tank army demands rapid, repetitive clicking - especially challenging when using just a trackpad! 😅

I tried several off-the-shelf auto-clickers, but they were either locked behind a paywall or just didn't feel right.
That’s why I built SnapClick — a simple, stable auto-clicker that just works.

---

## Download
Click [**Download**](https://github.com/mmmelson/SnapClick/releases/latest)to start!
SnapClick is too intuitive; you won't need any introduction.

---
## Features

- 🎯 **Multiple Schemes** - Different click configs with custom hotkeys
- ⚡ **Global Hotkeys** - Trigger from anywhere
- 🖱️ **Left & Right Click** - Both buttons supported
- ⏱️ **Precise Control** - Set exact counts and duration
- 📊 **Background Running** - Works even when window is closed

<div align="center">

![SnapClick Screenshot](Assets/image.png)

</div>

---

## Quick Start

**Requirements**: macOS 13.0+, Apple Silicon (M1/M2/M3/M4)

### Installation

1. [**Download the latest release**](https://github.com/mmmelson/SnapClick/releases/latest)
2. Unzip and move `SnapClick.app` to Applications
3. **First time**: Right-click → "Open" → "Open" (required once for unsigned apps)
4. Grant Accessibility permission when prompted

### How to Use

1. Click "+" to create a new scheme
2. Set clicks, duration, and hotkey
3. Enable the scheme (toggle turns green ✅)
4. Press your hotkey anywhere to auto-click!

---

## Important Notes

### CPS Safety Limit

⚠️ **Maximum: 200 CPS** (Clicks Per Second)

Higher speeds can crash macOS. The app prevents unsafe configurations.

**Formula**: `CPS = Clicks ÷ Duration`

**Examples**:
- ✅ 100 clicks in 1 sec = 100 CPS (Safe)
- ❌ 100 clicks in 0.3 sec = 333 CPS (Blocked)

### Permissions

SnapClick needs **Accessibility access** to monitor hotkeys and simulate clicks.

**Grant permission**: System Settings → Privacy & Security → Accessibility → Enable SnapClick

---

## FAQ

<details>
<summary><b>Can't open the app?</b></summary>

Right-click the app → "Open" → "Open" (required once for unsigned apps)

**Or use Terminal**:
```bash
xattr -cr /Applications/SnapClick.app
open /Applications/SnapClick.app
```

</details>

<details>
<summary><b>Hotkeys not working?</b></summary>

1. Check Accessibility permission is granted
2. Verify scheme is enabled (green ✅)
3. Check for conflicting shortcuts
4. Restart the app

</details>

<details>
<summary><b>Intel Mac support?</b></summary>

Currently Apple Silicon only. Build from source to customize target architecture.

</details>

---

## Build from Source

```bash
git clone https://github.com/mmmelson/SnapClick.git
cd SnapClick
./Scripts/build_app.sh
```

---

## License

MIT License - see [LICENSE](LICENSE)

---

<div align="center">

**Enjoy using SnapClick! 🎉**

If you find it useful, please give it a ⭐️ Star

[Report Issue](https://github.com/mmmelson/SnapClick/issues) · [Request Feature](https://github.com/mmmelson/SnapClick/discussions)

</div>
