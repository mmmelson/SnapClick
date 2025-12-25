# SnapClick

<div align="center">

<img src="images/icon.png" alt="SnapClick Logo" width="128" height="128">

🖱️ **Mac上最易用、最稳定的鼠标连点器**

[![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)](https://www.apple.com/macos/)
[![Architecture](https://img.shields.io/badge/Apple_Silicon-arm64-green.svg)](https://support.apple.com/en-us/HT211814)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[English](README.md) | [中文](README.zh-CN.md)

</div>

---

## 下载
点击[**下载**](https://github.com/mmmelson/SnapClick/releases/latest)，即可开始！

SnapClick太直观了，你不会需要任何介绍。

## 为什么做 SnapClick？

最近偶然间惊喜地发现了网页版的《红色警戒2》，在Mac端也能玩，于是和童年记忆狠狠地链接了一波，很快就重新沉迷上这款当年的启蒙游戏。
然而，组建一个坦克大军、快速重复点击同一个单位无数次，对于我这个只用触控板的玩家来说简直酸爽！😅

我开始尝试市面上现成的一些连点器工具，但他们要么需要付费，要么不够好用。

这就是SnapClick的由来，一个简单、稳定、够用的mac端鼠标连点器。

## ✨ 特性

- 🎯 **多方案管理** - 不同点击配置，自定义快捷键
- ⚡ **全局快捷键** - 任何地方触发
- 🖱️ **左右键支持** - 两个按键都支持
- ⏱️ **精确控制** - 准确设置次数和时长
- 📊 **后台运行** - 窗口关闭也能工作

<div align="center">

![SnapClick 截图](Assets/image.png)

</div>

## 🚀 快速开始

**系统要求**: macOS 13.0+, Apple Silicon (M1/M2/M3/M4)

### 安装

1. [**下载最新版本**](https://github.com/mmmelson/SnapClick/releases/latest)
2. 解压并将 `SnapClick.app` 移到「应用程序」
3. **首次打开**: 右键 → 「打开」→ 「打开」（未签名应用需要一次）
4. 授予「辅助功能」权限

### 如何使用

1. 点击「+」创建新方案
2. 设置点击次数、时长和快捷键
3. 启用方案（开关变绿 ✅）
4. 按快捷键自动连点！

## ⚠️ 重要说明

### CPS 安全限制

⚠️ **最大值：200 CPS**（每秒点击数）

更高速率可能导致 macOS 崩溃，应用会阻止不安全的配置。

**公式**: `CPS = 点击次数 ÷ 时长`

**示例**:
- ✅ 100 次点击 1 秒 = 100 CPS（安全）
- ❌ 100 次点击 0.3 秒 = 333 CPS（已阻止）

### 权限说明

SnapClick 需要「**辅助功能**」权限来监听快捷键和模拟点击。

**授予权限**: 系统设置 → 隐私与安全性 → 辅助功能 → 启用 SnapClick

## ❓ 常见问题

<details>
<summary><b>无法打开应用？</b></summary>

右键应用 → 「打开」→ 「打开」（未签名应用需要一次）

**或使用终端**:
```bash
xattr -cr /Applications/SnapClick.app
open /Applications/SnapClick.app
```

</details>

<details>
<summary><b>快捷键不响应？</b></summary>

1. 检查是否已授予「辅助功能」权限
2. 确认方案已启用（绿色 ✅）
3. 检查是否与其他快捷键冲突
4. 重启应用

</details>

<details>
<summary><b>支持 Intel Mac 吗？</b></summary>

当前仅支持 Apple Silicon。可从源码构建并自定义目标架构。

</details>

## 🛠️ 从源码构建

```bash
git clone https://github.com/mmmelson/SnapClick.git
cd SnapClick
./Scripts/build_app.sh
```

## 📄 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE)

---

<div align="center">

**使用愉快！ 🎉**

如果觉得有用，请给个 ⭐️ Star

[问题反馈](https://github.com/mmmelson/SnapClick/issues) · [功能建议](https://github.com/mmmelson/SnapClick/discussions)

</div>
