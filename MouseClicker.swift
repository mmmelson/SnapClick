import Foundation
import CoreGraphics
import AppKit

/// 鼠标点击执行器
class MouseClicker {
    private var isRunning = false
    private var currentTask: DispatchWorkItem?

    /// 执行连点方案
    func executeScheme(_ scheme: ClickScheme) {
        // 如果已有任务在运行，取消它
        if isRunning {
            currentTask?.cancel()
        }

        // 获取当前鼠标位置
        guard let location = getCurrentMouseLocation() else {
            print("❌ 无法获取鼠标位置")
            return
        }

        print("🖱️  开始执行连点: \(scheme.name) - \(scheme.clickCount)次/\(scheme.totalDuration)秒")
        print("📍 点击位置: (\(location.x), \(location.y))")

        // 播放开始音效（只播放一次）
        playStartSound()

        // 创建新任务
        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.isRunning = true

            for i in 1...scheme.clickCount {
                // 检查任务是否被取消
                guard let currentTask = self.currentTask, !currentTask.isCancelled else {
                    print("⚠️ 连点任务被取消")
                    break
                }

                // 执行点击（不播放音效）
                self.simulateClick(button: scheme.button, at: location)

                // 如果不是最后一次点击，等待间隔时间
                if i < scheme.clickCount {
                    // 使用更精确的睡眠方法，避免阻塞过久
                    let interval = scheme.clickInterval
                    if interval > 0 {
                        Thread.sleep(forTimeInterval: interval)
                    }
                }
            }

            self.isRunning = false
            print("✅ 连点完成")
        }

        currentTask = task
        DispatchQueue.global(qos: .userInitiated).async(execute: task)
    }

    /// 模拟鼠标点击
    private func simulateClick(button: MouseButton, at location: CGPoint) {
        // 获取当前鼠标位置（实时获取，允许用户移动鼠标）
        let currentLocation = getCurrentMouseLocation() ?? location

        // 创建鼠标按下事件（在当前位置点击，不强制移动鼠标）
        guard let mouseDown = CGEvent(
            mouseEventSource: nil,
            mouseType: button.downEventType,
            mouseCursorPosition: currentLocation,
            mouseButton: button == .left ? .left : .right
        ) else {
            print("❌ 无法创建鼠标按下事件")
            return
        }

        // 创建鼠标抬起事件
        guard let mouseUp = CGEvent(
            mouseEventSource: nil,
            mouseType: button.upEventType,
            mouseCursorPosition: currentLocation,
            mouseButton: button == .left ? .left : .right
        ) else {
            print("❌ 无法创建鼠标抬起事件")
            return
        }

        // 发送事件到系统
        mouseDown.post(tap: .cghidEventTap)

        // 添加极小延迟（模拟真实点击的按下-抬起过程）
        Thread.sleep(forTimeInterval: 0.001)

        mouseUp.post(tap: .cghidEventTap)
    }

    /// 获取当前鼠标位置
    private func getCurrentMouseLocation() -> CGPoint? {
        guard let event = CGEvent(source: nil) else { return nil }
        return event.location
    }

    /// 播放开始音效（只在开始时播放一次）
    private func playStartSound() {
        NSSound(named: "Tink")?.play()
    }
}
