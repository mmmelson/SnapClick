#!/bin/bash

# 创建 DMG 背景图片
# 尺寸: 600x400 像素
# 包含箭头引导，提示用户拖拽到 Applications

BACKGROUND_FILE="Assets/dmg_background.png"

echo "🎨 创建 DMG 背景图片..."

# 使用 sips 和 ImageMagick 的替代方案：使用 Swift 创建图片
cat > /tmp/create_dmg_bg.swift << 'EOF'
import Cocoa

// 创建画布
let width: CGFloat = 600
let height: CGFloat = 400
let size = NSSize(width: width, height: height)

let image = NSImage(size: size)

image.lockFocus()

// 浅色背景
NSColor.white.setFill()
NSRect(x: 0, y: 0, width: width, height: height).fill()

// 图标垂直中心位置 (图标上移，缩小上方空间)
// AppleScript 的 180 对应窗口底部往上的距离
// 在 400 高度的背景图中，图标中心上移到 y=240 位置
let iconCenterY: CGFloat = 240

// 绘制箭头字符 (从左向右，使用 → 符号，缩小尺寸)
let arrowAttributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 48, weight: .regular),
    .foregroundColor: NSColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.8)
]

let arrowText = "→" as NSString
let arrowSize = arrowText.size(withAttributes: arrowAttributes)
// 箭头垂直居中对齐图标
let arrowRect = NSRect(
    x: (width - arrowSize.width) / 2,
    y: iconCenterY - arrowSize.height / 2,
    width: arrowSize.width,
    height: arrowSize.height
)
arrowText.draw(in: arrowRect, withAttributes: arrowAttributes)

// 添加英文引导文字 (字体增大一号)
let englishAttributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 14, weight: .regular),  // 从 13 增大到 14
    .foregroundColor: NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
]

let englishText = "Drag the icon to the folder to install" as NSString
let englishSize = englishText.size(withAttributes: englishAttributes)
// 在图标下方约 100px 的位置
let englishRect = NSRect(
    x: (width - englishSize.width) / 2,
    y: 90,
    width: englishSize.width,
    height: englishSize.height
)
englishText.draw(in: englishRect, withAttributes: englishAttributes)

image.unlockFocus()

// 保存为 PNG
guard let tiffData = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiffData),
      let pngData = bitmap.representation(using: .png, properties: [:]) else {
    print("Failed to create PNG data")
    exit(1)
}

let outputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "dmg_background.png"
let url = URL(fileURLWithPath: outputPath)

do {
    try pngData.write(to: url)
    print("✅ 背景图片已创建: \(outputPath)")
} catch {
    print("❌ 保存失败: \(error)")
    exit(1)
}
EOF

# 编译并运行
swiftc /tmp/create_dmg_bg.swift -o /tmp/create_dmg_bg
/tmp/create_dmg_bg "$BACKGROUND_FILE"

# 清理
rm /tmp/create_dmg_bg.swift /tmp/create_dmg_bg

if [ -f "$BACKGROUND_FILE" ]; then
    echo "✅ DMG 背景图片创建成功"
else
    echo "❌ DMG 背景图片创建失败"
    exit 1
fi
