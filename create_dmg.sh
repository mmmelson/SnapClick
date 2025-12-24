#!/bin/bash

APP_NAME="SnapClick"
VERSION="1.0"
DMG_NAME="${APP_NAME}_v${VERSION}.dmg"

echo "📦 正在创建 DMG 安装包..."

# 删除旧的 DMG
rm -f "$DMG_NAME"

# 创建临时目录
TMP_DIR=$(mktemp -d)
cp -R "${APP_NAME}.app" "$TMP_DIR/"

# 创建 Applications 快捷方式
ln -s /Applications "$TMP_DIR/Applications"

# 创建 DMG
hdiutil create -volname "$APP_NAME" \
    -srcfolder "$TMP_DIR" \
    -ov -format UDZO \
    "$DMG_NAME"

# 清理临时目录
rm -rf "$TMP_DIR"

if [ -f "$DMG_NAME" ]; then
    echo "✅ DMG 创建成功: $DMG_NAME"
    echo "📊 文件大小: $(du -h "$DMG_NAME" | cut -f1)"
else
    echo "❌ DMG 创建失败"
    exit 1
fi
