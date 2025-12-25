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

I recently stumbled upon the browser version of [Command & Conquer: Red Alert 2](https://game.chronodivide.com) and was thrilled to discover it runs on Mac! It instantly reconnected me with my childhood memories, and I quickly found myself hooked on this game that once sparked my love for strategy games.

During gameplay, building a tank army requires rapidly and repeatedly clicking the same unit. Sometimes when you misclick, you need to right-click dozens of times to cancel. Using only a trackpad made my fingers particularly... well-exercised. 😅

I tried some auto-clicker tools on GitHub, but they were either paid or not user-friendly enough - most only supported a single fixed clicking configuration. So I decided to build my own.

**This is SnapClick: a simple, stable, and powerful auto-clicker that just works.**

---

## Features

- 🎯 **Multiple Schemes** - Create and manage multiple click configurations with different hotkeys
- ⚡ **Global Hotkeys** - Trigger clicks from anywhere with customizable keyboard shortcuts
- 🖱️ **Left & Right Click** - Support for both mouse buttons
- ⏱️ **Precise Control** - Set exact click counts and total duration
- 🎨 **Modern UI** - Native SwiftUI interface that feels right at home on macOS
- 📊 **Background Running** - Keeps working even when the app window is closed
- 💾 **Auto-Save** - All changes are automatically saved and restored on restart

<div align="center">
![alt text](image.png)
</div>

## Quick Start

### System Requirements

- **macOS**: 13.0 (Ventura) or later
- **CPU**: Apple Silicon (M1/M2/M3/M4)
- **Permissions**: Accessibility access (required for global hotkeys and mouse control)

### Installation

#### Option 1: Download Pre-built App (Recommended)

1. Download the latest release from [Releases](https://github.com/mmmelson/SnapClick/releases)
2. Unzip and move `SnapClick.app` to your Applications folder
3. **Important - First time open**: Right-click the app → Select "Open" → Click "Open" in the dialog
   - This is required because the app isn't notarized by Apple
   - You only need to do this once

#### Option 2: Build from Source

```bash
git clone https://github.com/mmmelson/SnapClick.git
cd SnapClick
./build_app.sh
```

The built app will be in the current directory as `SnapClick.app`.

### Basic Usage

1. **Create a scheme**
   - Click the "+" (New) button
   - Fill in the scheme name (e.g., "Quick Click")
   - Choose mouse button (Left or Right)
   - Set click count (e.g., 10)
   - Set duration in seconds (e.g., 1.0)
   - Record a hotkey (e.g., Option + `)
   - Click "Save"

2. **Enable the scheme**
   - Click the circle icon next to your scheme
   - It will turn green with a checkmark ✅
   - First time: Grant Accessibility permission when prompted

3. **Use it**
   - Move your mouse to the target location
   - Press your hotkey
   - Watch it click automatically!

## Permissions

SnapClick needs **Accessibility** permission to:
- Monitor global keyboard shortcuts
- Simulate mouse clicks

**To grant permission**:
1. Go to System Settings → Privacy & Security → Accessibility
2. Find SnapClick and toggle it ON
3. If already enabled but not working, try toggling it OFF then ON again

## How It Works

### Click Interval Calculation

The app automatically calculates click intervals:

```
Click Interval = Total Duration ÷ Click Count
```

**Examples**:
- 10 clicks in 1.0 second = 0.1 second (100ms) interval
- 50 clicks in 5.0 seconds = 0.1 second (100ms) interval
- 5 clicks in 2.0 seconds = 0.4 second (400ms) interval

### CPS Limitation (Important!)

**Maximum CPS: 200** (Clicks Per Second)

⚠️ **Safety Warning**: CPS rates above 200 can cause macOS to become unstable or crash. The app enforces a 200 CPS limit to protect your system. This limit is calculated as:

```
CPS = Click Count ÷ Duration
```

**Safe configurations**:
- ✅ 100 clicks in 1 second = 100 CPS (Safe)
- ✅ 200 clicks in 2 seconds = 100 CPS (Safe)
- ❌ 100 clicks in 0.5 seconds = 200 CPS (Maximum, risky)
- ❌ 100 clicks in 0.3 seconds = 333 CPS (Not allowed)

### Background Running

SnapClick continues working even when:
- The main window is closed
- You're using other apps
- Your Mac is locked (hotkeys remain active)

Access the app anytime via the menu bar icon.

## FAQ

<details>
<summary><b>Why can't I open the app?</b></summary>

This is macOS Gatekeeper security. The app isn't notarized by Apple, so you need to:
1. Right-click the app
2. Select "Open"
3. Click "Open" in the dialog

You only need to do this once. After that, you can open it normally.

**Alternative**: Use Terminal
```bash
xattr -cr /Applications/SnapClick.app
open /Applications/SnapClick.app
```

</details>

<details>
<summary><b>Hotkeys aren't working?</b></summary>

Check these things:
1. Is Accessibility permission granted? (System Settings → Privacy & Security → Accessibility)
2. Is your scheme enabled? (Green checkmark ✅ next to the scheme)
3. Does the hotkey conflict with another app or system shortcut?
4. Try restarting SnapClick

</details>

<details>
<summary><b>Can I use this on Intel Mac?</b></summary>

The current release is Apple Silicon only. For Intel support:
- Wait for a universal binary release
- Or build from source with modified target architecture in `build_app.sh`

</details>

<details>
<summary><b>How do I stop clicking once it starts?</b></summary>

The clicks will automatically stop after completing the configured count. To interrupt:
- Move your mouse quickly
- Press `Esc` key
- Click elsewhere

</details>

<details>
<summary><b>Where is my data stored?</b></summary>

All schemes are saved to:
```
~/Library/Application Support/SnapClick/schemes.json
```

You can back up this file to preserve your configurations.

</details>

## Development

### Project Structure

```
SnapClick/
├── SnapClickApp.swift          # App entry point and AppDelegate
├── ContentView.swift            # Main UI
├── ClickScheme.swift           # Data models
├── HotkeyMonitor.swift         # Global hotkey listener
├── MouseClicker.swift          # Click execution
├── SchemeManager.swift         # Data persistence
├── Localization.swift          # i18n support
├── ViewModels/
│   └── ClickerViewModel.swift  # Business logic
├── Info.plist                  # App configuration
├── AppIcon.icns                # App icon
└── build_app.sh                # Build script
```

### Building

```bash
# Standard build
./build_app.sh

# Create distribution package
./create_distribution.sh

# Create DMG installer
./create_dmg.sh
```

### Tech Stack

- **Language**: Swift 5
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **Minimum OS**: macOS 13.0
- **Target**: arm64 (Apple Silicon)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Thanks to everyone who tested and provided feedback!

---

<div align="center">

**Enjoy using SnapClick! 🎉**

If you find it useful, please give it a ⭐️ Star

[Report Issue](https://github.com/mmmelson/SnapClick/issues) · [Request Feature](https://github.com/mmmelson/SnapClick/discussions)

</div>
