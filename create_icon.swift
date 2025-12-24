#!/usr/bin/swift

import Foundation
import AppKit

// Create a simple icon using SF Symbols
let sizes: [(String, CGFloat)] = [
    ("icon_16x16", 16),
    ("icon_16x16@2x", 32),
    ("icon_32x32", 32),
    ("icon_32x32@2x", 64),
    ("icon_128x128", 128),
    ("icon_128x128@2x", 256),
    ("icon_256x256", 256),
    ("icon_256x256@2x", 512),
    ("icon_512x512", 512),
    ("icon_512x512@2x", 1024)
]

let iconsetPath = "AppIcon.iconset"

// Create iconset directory
try? FileManager.default.createDirectory(atPath: iconsetPath, withIntermediateDirectories: true)

// Use the hand.point.up.left.fill symbol
let symbolName = "hand.point.up.left.fill"

for (filename, size) in sizes {
    let image = NSImage(size: NSSize(width: size, height: size))

    image.lockFocus()

    // Create gradient background
    let gradient = NSGradient(colors: [
        NSColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0),
        NSColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0)
    ])
    gradient?.draw(in: NSRect(x: 0, y: 0, width: size, height: size), angle: 135)

    // Draw SF Symbol
    if let symbolImage = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil) {
        let symbolSize = size * 0.6
        let symbolRect = NSRect(
            x: (size - symbolSize) / 2,
            y: (size - symbolSize) / 2,
            width: symbolSize,
            height: symbolSize
        )

        // Configure symbol color
        let config = NSImage.SymbolConfiguration(pointSize: symbolSize, weight: .medium)
        let configuredSymbol = symbolImage.withSymbolConfiguration(config)

        // Draw white symbol
        NSColor.white.set()
        configuredSymbol?.draw(in: symbolRect)
    }

    image.unlockFocus()

    // Save as PNG
    if let tiffData = image.tiffRepresentation,
       let bitmapImage = NSBitmapImageRep(data: tiffData),
       let pngData = bitmapImage.representation(using: .png, properties: [:]) {
        let filePath = "\(iconsetPath)/\(filename).png"
        try? pngData.write(to: URL(fileURLWithPath: filePath))
        print("✓ Created \(filename).png (\(Int(size))x\(Int(size)))")
    }
}

print("\n✅ Iconset created successfully!")
print("Now run: iconutil -c icns AppIcon.iconset")
