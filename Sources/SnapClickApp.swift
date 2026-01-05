import SwiftUI
import AppKit

@main
struct SnapClickApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.viewModel)
                .frame(width: 251, height: 365)  // 宽度缩小15%
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        .defaultSize(width: 251, height: 387)  // 相应调整默认大小
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    // ⚠️ 关键：在 AppDelegate 中持有 ViewModel，确保窗口关闭后仍然运行
    // 使用 lazy var 确保只初始化一次
    static var shared: AppDelegate?
    lazy var viewModel: ClickerViewModel = {
        return ClickerViewModel()
    }()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // ⚠️ 关键：只创建菜单栏图标，不检查权限
        // 权限检查会在真正需要时（启用方案时）进行
        AppDelegate.shared = self
        // 强制初始化 viewModel
        _ = viewModel
        setupMenuBarIcon()
    }

    func setupMenuBarIcon() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "hand.point.up.left.fill", accessibilityDescription: "SnapClick")
            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    @objc func togglePopover() {
        if let popover = popover, popover.isShown {
            popover.close()
        } else {
            showPopover()
        }
    }

    func showPopover() {
        guard let button = statusItem?.button else { return }

        let popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 200)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: MenuBarView().environmentObject(viewModel))

        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        self.popover = popover
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false // 关闭窗口不退出应用
    }
}

// 菜单栏弹出视图
struct MenuBarView: View {
    @EnvironmentObject private var viewModel: ClickerViewModel

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "hand.point.up.left.fill")
                .font(.system(size: 32))
                .foregroundColor(.blue)

            Text("SnapClick")
                .font(.headline)

            // 显示运行状态
            if viewModel.isRunning {
                let enabledCount = viewModel.schemes.filter { $0.isEnabled }.count
                Text(L.runningStatus(count: enabledCount))
                    .font(.caption)
                    .foregroundColor(.green)
            } else {
                Text(L.disabled)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider()

            Button(L.showMainWindow) {
                NSApplication.shared.activate(ignoringOtherApps: true)
                NSApplication.shared.windows.first?.makeKeyAndOrderFront(nil)
            }
            .buttonStyle(.borderedProminent)

            Button(L.quit) {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
