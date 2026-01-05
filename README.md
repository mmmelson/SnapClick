# SnapClick

<div align="center">

<img src="images/icon.png" alt="SnapClick Logo" width="128" height="128">

**The easiest and most handy auto-clicker for Mac**

[![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)](https://www.apple.com/macos/)
[![Architecture](https://img.shields.io/badge/Apple_Silicon-arm64-green.svg)](https://support.apple.com/en-us/HT211814)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[English](README.md) | [中文](README.zh-CN.md)

</div>

## Download
Click [**Download**](https://github.com/mmmelson/SnapClick/releases/download/v3.1/SnapClick_v3.1.dmg) to start!

SnapClick is too intuitive; you won't need any introduction.

### First Time Setup

When you first open SnapClick, macOS will show a security dialog since it's not from the App Store. Follow these steps:

<div align="center">

<img src="images/notice1-en.png" alt="Security Dialog Step 1" width="45%">
<img src="images/notice2-en.png" alt="Security Dialog Step 2" width="45%">

</div>

1. **Click "Done"** when the first dialog appears (don't move to trash!)
2. Go to **System Settings** → **Privacy & Security**
3. Scroll down and click **"Open Anyway"**
4. SnapClick will now launch successfully

## Why SnapClick?

I recently stumbled upon the browser version of [Command & Conquer: Red Alert 2](https://game.chronodivide.com) and discovered it runs on Mac! Triggered a wave of childhood nostalgia, I quickly found myself addicted to my first "gaming enlightenment" all over again.

However, building a tank army demands rapid, repetitive clicking - especially challenging when using just a trackpad! 😅
I tried several off-the-shelf auto-clickers, but they were either locked behind a paywall or just didn't feel right.

That's why I built SnapClick — a simple, stable auto-clicker that just works.

<div align="center">

<img src="images/image.png" alt="SnapClick Screenshot" width="60%">

</div>

## Features

- 🎯 **Multiple Schemes** - Different click configs with custom hotkeys
- ⚡ **Global Hotkeys** - Trigger from anywhere
- 🖱️ **Left & Right Click** - Both buttons supported
- ⏱️ **Precise Control** - Set exact counts and duration
- 📊 **Background Running** - Works even when window is closed

## FAQ

<details>
<summary><b>What are the system requirements?</b></summary>

- **macOS**: 13.0 (Ventura) or later
- **CPU**: Apple Silicon (M1/M2/M3/M4)
- **Permissions**: Accessibility access (required for global hotkeys and mouse control)

</details>

<details>
<summary><b>Can't open the app?</b></summary>

**macOS will show a security warning because this app is not notarized.** This is normal for open-source apps without Apple Developer membership.

**Option 1: Right-click to open (Recommended)**

<div align="center">
<img src="images/security-warning.png" alt="Security Warning" width="45%">
</div>

Right-click the app → **Open** → **Open** (required once for unsigned apps)

**Option 2: System Settings**

<div align="center">
<img src="images/security-settings.png" alt="Privacy & Security" width="60%">
</div>

Go to **System Settings** → **Privacy & Security** → Click **Open Anyway**

**Option 3: Terminal**
```bash
xattr -cr /Applications/SnapClick.app
open /Applications/SnapClick.app
```

</details>

<details>
<summary><b>How do I grant Accessibility permission?</b></summary>

Go to **System Settings** → **Privacy & Security** → **Accessibility** → Enable SnapClick

If already enabled but not working, try toggling it OFF then ON again.

</details>

<details>
<summary><b>What's the CPS limit?</b></summary>

⚠️ **Maximum: 200 CPS** (Clicks Per Second)

Higher speeds can crash macOS. The app prevents unsafe configurations.

**Formula**: `CPS = Clicks ÷ Duration`

**Examples**:
- ✅ 100 clicks in 1 sec = 100 CPS (Safe)
- ❌ 100 clicks in 0.3 sec = 333 CPS (Blocked)

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

<details>
<summary><b>How to build from source?</b></summary>

```bash
git clone https://github.com/mmmelson/SnapClick.git
cd SnapClick
./Scripts/build_app.sh
```

</details>

## Changelog

### v3.1 - 2026-01-05 (Latest)
- 🐛 **Fixed critical bug**: Schemes no longer execute multiple times after app restart
- ✨ **Hotkey conflict detection**: App now prevents duplicate hotkeys and shows clear warnings
- 🎁 **Default schemes**: First-time users get two preset schemes (Left Click ⌥1, Right Click ⌥2)
- 🧹 **Code cleanup**: Removed debug logging for better performance
- 🏗️ **Architecture improvement**: Single ViewModel instance using `@EnvironmentObject`

### v3.0 - 2025-12-28
- 🎨 Redesigned scheme card interaction: entire card clickable for editing
- 🎯 Moved toggle to right side with proper vertical centering
- 🏷️ Added "Hotkey" label in scheme preview cards
- ➕ Added "Add" label to new scheme button with icon
- 🔤 Improved font consistency across all UI elements
- 🐛 Fixed text overflow issues in scheme preview cards
- 🐛 Fixed scheme editor title display issue
- ✨ Enhanced layout spacing and padding throughout

### v2.0 - 2024-12-26
- 🐛 Fixed click count accumulation bug when updating schemes
- 🐛 Fixed app crash on hotkey trigger
- ✨ Enhanced global hotkey reliability across all apps
- 📦 Added custom DMG installer with visual guide

### v1.0 - 2024-12-25
- 🎉 Initial release

## License

MIT License - see [LICENSE](LICENSE)

---

<div align="center">

**Enjoy using SnapClick! 🎉**

If you find it useful, please give it a ⭐️ Star

[Report Issue](https://github.com/mmmelson/SnapClick/issues) · [Request Feature](https://github.com/mmmelson/SnapClick/discussions)

</div>
