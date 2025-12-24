#!/bin/bash

echo "🚀 开始构建 SnapClick..."
echo ""

# 清理旧的构建文件
if [ -d "SnapClick.app" ]; then
    echo "🗑️  清理旧的应用..."
    rm -rf SnapClick.app
fi

# 创建应用 Bundle 结构
echo "📦 创建应用结构..."
mkdir -p SnapClick.app/Contents/MacOS
mkdir -p SnapClick.app/Contents/Resources

# 复制 Info.plist
cp Info.plist SnapClick.app/Contents/

# 复制应用图标
if [ -f "AppIcon.icns" ]; then
    echo "🎨 复制应用图标..."
    cp AppIcon.icns SnapClick.app/Contents/Resources/
    echo "   ✅ 图标已添加"
else
    echo "   ⚠️  未找到 AppIcon.icns，应用将使用默认图标"
fi

# 编译所有 Swift 源文件
echo "🔨 编译源代码..."
swiftc \
    SnapClickApp.swift \
    ContentView.swift \
    ClickScheme.swift \
    HotkeyMonitor.swift \
    MouseClicker.swift \
    SchemeManager.swift \
    Localization.swift \
    ViewModels/ClickerViewModel.swift \
    -o SnapClick.app/Contents/MacOS/SnapClick \
    -framework Foundation \
    -framework AppKit \
    -framework CoreGraphics \
    -framework SwiftUI \
    -target $(uname -m)-apple-macos13.0 \
    -O \
    -whole-module-optimization

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ 编译失败，请检查错误信息"
    exit 1
fi

echo "   ✅ 已为 $(uname -m) 架构构建"

# 代码签名（使用 adhoc 签名保持一致性）
echo "🔐 对应用进行签名..."
codesign --force --deep --sign - SnapClick.app

if [ $? -eq 0 ]; then
    echo "   ✅ 签名完成"

    # 验证签名
    echo "🔍 验证签名..."
    codesign --verify --verbose SnapClick.app
    if [ $? -eq 0 ]; then
        echo "   ✅ 签名验证通过"
    fi
else
    echo "   ⚠️  签名失败，应用仍可使用但可能需要重新授予权限"
fi

# 显示应用信息
echo ""
echo "✅ 编译成功！"
echo ""
echo "📱 应用程序已创建："
echo "   $(pwd)/SnapClick.app"
echo ""
echo "📊 应用大小: $(du -sh SnapClick.app | cut -f1)"
echo ""
echo ""

# 只有在传入 --launch 参数时才启动应用
if [[ "$1" == "--launch" ]]; then
    echo "🚀 启动 SnapClick..."
    open SnapClick.app
else
    echo "💡 提示：使用 './build_app.sh --launch' 可在构建后自动启动应用"
fi
