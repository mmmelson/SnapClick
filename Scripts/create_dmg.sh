#!/bin/bash

APP_NAME="SnapClick"
VERSION="3.1"
DMG_NAME="${APP_NAME}_v${VERSION}.dmg"
VOLUME_NAME="SnapClick"

echo "📦 正在创建 DMG 安装包..."

# 删除旧的 DMG
rm -f "$DMG_NAME"

# 创建临时目录
TMP_DIR=$(mktemp -d)
cp -R "${APP_NAME}.app" "$TMP_DIR/"

# 创建 Applications 快捷方式
ln -s /Applications "$TMP_DIR/Applications"

# 创建初始 DMG（可读写）
TMP_DMG="tmp_${DMG_NAME}"
hdiutil create -volname "$VOLUME_NAME" \
    -srcfolder "$TMP_DIR" \
    -ov -format UDRW \
    "$TMP_DMG"

# 挂载 DMG
echo "🔗 挂载 DMG..."
DEVICE=$(hdiutil attach -readwrite -noverify -noautoopen "$TMP_DMG" | grep "/Volumes/${VOLUME_NAME}" | awk '{print $1}')
MOUNT_DIR="/Volumes/${VOLUME_NAME}"

echo "📐 配置 DMG 外观..."

# 等待挂载完成
sleep 3

# 确认挂载成功
if [ ! -d "$MOUNT_DIR" ]; then
    echo "❌ DMG 挂载失败"
    exit 1
fi

# 复制背景图片
BG_FOLDER="$MOUNT_DIR/.background"
mkdir -p "$BG_FOLDER"
cp Assets/dmg_background.png "$BG_FOLDER/background.png"

# 使用 AppleScript 设置窗口属性和图标位置
osascript <<EOF
tell application "Finder"
    tell disk "$VOLUME_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false

        -- 设置窗口大小和位置 (更小的窗口)
        set the bounds of container window to {100, 100, 700, 500}

        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 100

        -- 设置背景图片
        set background picture of viewOptions to file ".background:background.png"

        -- 设置图标位置 (y 坐标从 180 改为 160，图标上移)
        -- SnapClick.app 在左侧 (150, 160)
        set position of item "${APP_NAME}.app" of container window to {150, 160}
        -- Applications 快捷方式在右侧 (450, 160)
        set position of item "Applications" of container window to {450, 160}

        -- 更新并关闭
        update without registering applications
        delay 2
        close
    end tell
end tell
EOF

# 同步更改
sync

# 卸载
hdiutil detach "$MOUNT_DIR" -quiet

# 转换为压缩的只读格式
echo "🗜️  压缩 DMG..."
hdiutil convert "$TMP_DMG" -format UDZO -o "$DMG_NAME"

# 清理临时文件
rm -rf "$TMP_DIR"
rm -f "$TMP_DMG"

if [ -f "$DMG_NAME" ]; then
    echo "✅ DMG 创建成功: $DMG_NAME"
    echo "📊 文件大小: $(du -h "$DMG_NAME" | cut -f1)"
else
    echo "❌ DMG 创建失败"
    exit 1
fi
