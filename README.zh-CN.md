# SnapClick

<div align="center">

🖱️ **Mac上最易用、最稳定的鼠标连点器**

[![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)](https://www.apple.com/macos/)
[![Architecture](https://img.shields.io/badge/Apple_Silicon-arm64-green.svg)](https://support.apple.com/en-us/HT211814)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[English](README.md) | [中文](README.zh-CN.md)

</div>

---

## 为什么做 SnapClick？

最近迷上了网页版的《红警》游戏。在购买小兵、坦克等单位时，经常需要快速多次点击鼠标来批量购入或取消购入。试了GitHub上几个工具，要么不够稳定，要么只能模拟一种点击方式。

于是我做了 SnapClick：**一个简单、稳定、功能强大的鼠标连点器。**

---

## ✨ 特性

- 🎯 **多方案管理** - 创建和管理多个连点方案，每个方案独立配置
- ⚡ **快捷键触发** - 自定义全局快捷键，一键启动连点
- 🖱️ **左右键支持** - 支持左键和右键连点
- ⏱️ **精确控制** - 精确设置点击次数和总时长
- 🎨 **现代界面** - 使用 SwiftUI 构建的原生 macOS 界面
- 📊 **后台运行** - 即使窗口关闭也能保持快捷键功能
- 💾 **自动保存** - 所有更改自动保存并在重启后恢复

## 📋 系统要求

- **操作系统**: macOS 13.0 (Ventura) 或更高版本
- **处理器**: Apple Silicon (M1/M2/M3/M4)
- **权限**: 辅助功能权限（用于全局快捷键和鼠标控制）

## 📦 安装

### 方法 1：下载预编译版本（推荐）

1. 从 [Releases](https://github.com/yourusername/SnapClick/releases) 页面下载最新版本
2. 解压 `SnapClick-v2.0-arm64.zip`
3. 将 `SnapClick.app` 拖到「应用程序」文件夹
4. **重要 - 首次打开**: 右键点击应用 → 选择「打开」→ 在对话框中点击「打开」
   - 由于应用未经 Apple 公证，需要此步骤
   - 只需操作一次

### 方法 2：从源码构建

```bash
git clone https://github.com/yourusername/SnapClick.git
cd SnapClick
./build_app.sh
```

构建完成的应用将在当前目录生成 `SnapClick.app`。

## 🚀 快速开始

### 1️⃣ 创建连点方案

1. 点击「**新增**」按钮（+图标）
2. 填写方案名称（如"快速点击"）
3. 选择鼠标按键（左键或右键）
4. 设置点击次数（如 10）
5. 设置完成时长（秒，如 1.0）
6. 录制快捷键（如 Option + `）
7. 点击「**保存**」

### 2️⃣ 启用方案

1. 点击方案右侧的圆圈图标
2. 图标变为绿色 ✅ 表示已启用
3. 首次使用时会提示授予辅助功能权限

### 3️⃣ 使用方案

1. 将鼠标移动到目标位置
2. 按下设置的快捷键
3. 自动连点开始！

## 🔐 权限说明

SnapClick 需要「**辅助功能**」权限来：
- 监听全局快捷键
- 模拟鼠标点击

**授予权限步骤**：
1. 打开「**系统设置**」→「**隐私与安全性**」→「**辅助功能**」
2. 找到 SnapClick 并**勾选启用**
3. 如已启用但不工作，尝试取消勾选后重新勾选

## 💡 使用技巧

### 计算点击间隔

点击间隔 = 完成时长 ÷ 点击次数

**示例**：
- 10 次点击，1.0 秒完成 → 每次间隔 0.1 秒（100ms）
- 50 次点击，5.0 秒完成 → 每次间隔 0.1 秒（100ms）
- 20 次点击，2.0 秒完成 → 每次间隔 0.1 秒（100ms）

### 后台运行

SnapClick 在以下情况下继续工作：
- 主窗口已关闭
- 正在使用其他应用
- Mac 已锁定（快捷键仍然有效）

通过菜单栏图标随时访问应用。

### 快捷键建议

- 使用 **⌘⌥ + 字母键** 组合（如 ⌘⌥A）
- 避免与系统快捷键冲突
- 为不同场景设置不同快捷键

### 最佳实践

1. **测试方案**: 先在安全区域测试方案是否符合预期
2. **合理命名**: 使用描述性的方案名称（如"游戏-快速点击"）
3. **备份设置**: 方案数据保存在 `~/Library/Application Support/SnapClick/`
4. **及时禁用**: 不用时禁用方案，避免误触

## ⚠️ 常见问题

<details>
<summary><b>Q: 为什么应用无法打开？</b></summary>

**A**: 这是 macOS Gatekeeper 安全机制。由于应用未经 Apple 公证，需要：
1. 右键点击应用
2. 选择「打开」
3. 在对话框中点击「打开」

只需操作一次，之后可以正常双击打开。

**替代方法**：使用终端
```bash
xattr -cr /Applications/SnapClick.app
open /Applications/SnapClick.app
```

</details>

<details>
<summary><b>Q: 快捷键不响应？</b></summary>

**A**: 请检查：
1. 是否已授予「辅助功能」权限
2. 方案是否已启用（右侧显示绿色 ✅）
3. 快捷键是否与其他应用冲突
4. 尝试重启应用

</details>

<details>
<summary><b>Q: 能在 Intel Mac 上使用吗？</b></summary>

**A**: 当前版本仅支持 Apple Silicon。如需 Intel 版本，可以：
1. 等待 Universal 版本发布
2. 自行编译（需修改 `build_app.sh` 中的 target 参数）

</details>

<details>
<summary><b>Q: 如何停止正在执行的连点？</b></summary>

**A**: 连点会在完成设定次数后自动停止。要中断连点：
- 快速移动鼠标
- 按 `Esc` 键
- 点击其他位置

</details>

<details>
<summary><b>Q: 方案数据保存在哪里？</b></summary>

**A**: 所有方案保存在：
```
~/Library/Application Support/SnapClick/schemes.json
```

可以备份此文件来保留配置。

</details>

## 🛠️ 开发

### 项目结构

```
SnapClick/
├── SnapClickApp.swift          # 应用入口
├── ContentView.swift            # 主界面
├── ClickScheme.swift           # 数据模型
├── HotkeyMonitor.swift         # 快捷键监听
├── MouseClicker.swift          # 鼠标点击执行
├── SchemeManager.swift         # 数据持久化
├── Localization.swift          # 国际化支持
├── ViewModels/
│   └── ClickerViewModel.swift  # 业务逻辑
├── Info.plist                  # 应用配置
├── AppIcon.icns                # 应用图标
└── build_app.sh                # 构建脚本
```

### 构建和测试

```bash
# 构建应用
./build_app.sh

# 创建发布包
./create_distribution.sh

# 创建 DMG 安装包
./create_dmg.sh
```

### 技术栈

- **语言**: Swift 5
- **UI 框架**: SwiftUI
- **架构**: MVVM (Model-View-ViewModel)
- **最低系统**: macOS 13.0
- **目标架构**: arm64 (Apple Silicon)

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 🙏 致谢

感谢所有测试用户的反馈和建议！

---

<div align="center">

**使用愉快！ 🎉**

如果觉得有用，请给个 ⭐️ Star

[问题反馈](https://github.com/yourusername/SnapClick/issues) · [功能建议](https://github.com/yourusername/SnapClick/discussions)

</div>
