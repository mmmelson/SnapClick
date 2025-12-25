import Foundation

/// 语言管理类
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @Published var currentLanguage: Language = .english {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppLanguage")
        }
    }

    enum Language: String {
        case chinese = "zh"
        case english = "en"
    }

    private init() {
        // 从 UserDefaults 加载保存的语言设置
        if let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage"),
           let language = Language(rawValue: savedLanguage) {
            currentLanguage = language
        }
    }

    func toggleLanguage() {
        currentLanguage = currentLanguage == .chinese ? .english : .chinese
    }
}

/// 本地化字符串
struct L {
    // 预设相关
    static var preset: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "预设" : "Preset"
    }

    static var newPreset: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "新建预设" : "New Preset"
    }

    // 按钮
    static var leftButton: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "左键" : "Left"
    }

    static var rightButton: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "右键" : "Right"
    }

    static var mouseButton: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "鼠标按键" : "Mouse Button"
    }

    static var clickCount: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "点击次数" : "Click Count"
    }

    static var duration: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "完成时长 (秒)" : "Duration (sec)"
    }

    static var hotkey: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "快捷键" : "Hotkey"
    }

    static var hotkeyRequired: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "(必填)" : "(Required)"
    }

    static var clickToSet: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "点击设置" : "Click to Set"
    }

    static var recording: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "录制中..." : "Recording..."
    }

    static var clear: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "清空" : "Clear"
    }

    static var cancel: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "取消" : "Cancel"
    }

    static var save: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "保存" : "Save"
    }

    static var delete: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "删除" : "Delete"
    }

    // 空状态
    static var noPresets: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "暂无预设" : "No Presets"
    }

    static var clickAddToCreate: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "点击下方 + 按钮添加" : "Click + to add"
    }

    static var selectOrCreateScheme: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "选择一个方案或创建新方案" : "Select a scheme or create a new one"
    }

    static var cpsWarning: String {
        LocalizationManager.shared.currentLanguage == .chinese ?
            "CPS超过200可能导致崩溃！" :
            "CPS over 200 may cause crashes!"
    }

    static var currentCPS: String {
        LocalizationManager.shared.currentLanguage == .chinese ?
            "当前 CPS: %.1f" :
            "Current CPS: %.1f"
    }

    // 提示信息
    static var hotkeyNotConfigured: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "快捷键未配置" : "Hotkey Not Configured"
    }

    static var pleaseConfigureHotkey: String {
        LocalizationManager.shared.currentLanguage == .chinese ?
            "请先配置快捷键后再启用此预设" :
            "Please configure hotkey before enabling"
    }

    static var ok: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "确定" : "OK"
    }

    // 通知
    static var started: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "已启动" : "Started"
    }

    static var stopped: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "已停止" : "Stopped"
    }

    static var executing: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "执行方案" : "Executing"
    }

    static var loaded: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "已加载" : "Loaded"
    }

    static var schemes: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "个方案" : "scheme(s)"
    }

    static var clickerStopped: String {
        LocalizationManager.shared.currentLanguage == .chinese ?
            "连点器已停止运行" :
            "Clicker stopped"
    }

    // 菜单栏
    static var running: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "运行中" : "Running"
    }

    static var disabled: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "未启用" : "Disabled"
    }

    static var enabled: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "已启用" : "enabled"
    }

    static var showMainWindow: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "显示主窗口" : "Show Window"
    }

    static var quit: String {
        LocalizationManager.shared.currentLanguage == .chinese ? "退出" : "Quit"
    }

    // 预设名称生成
    static func presetName(_ index: Int) -> String {
        LocalizationManager.shared.currentLanguage == .chinese ?
            "预设\(index)" :
            "Preset \(index)"
    }

    // 点击描述
    static func clickDescription(button: String, count: Int, duration: String) -> String {
        if LocalizationManager.shared.currentLanguage == .chinese {
            return "\(button) \(count)次 \(duration)秒"
        } else {
            return "\(button) \(count)x \(duration)s"
        }
    }

    // 运行状态
    static func runningStatus(count: Int) -> String {
        if LocalizationManager.shared.currentLanguage == .chinese {
            return "运行中 · \(count) 个方案已启用"
        } else {
            return "Running · \(count) \(count == 1 ? "scheme" : "schemes") enabled"
        }
    }
}
