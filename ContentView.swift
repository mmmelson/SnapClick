import SwiftUI
import AppKit

struct ContentView: View {
    // ⚠️ 关键：使用 AppDelegate 中的共享 ViewModel，确保窗口关闭后仍然运行
    @ObservedObject private var viewModel: ClickerViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var selectedScheme: ClickScheme?
    @State private var isAddingNew = false

    init() {
        // 从 AppDelegate 获取共享的 ViewModel
        if let appDelegate = AppDelegate.shared, let vm = appDelegate.viewModel {
            self.viewModel = vm
        } else {
            // 如果 AppDelegate 还未初始化，创建临时实例（不应该发生）
            self.viewModel = ClickerViewModel()
        }
    }

    // 生成方案显示名称
    private func schemeDisplayName(for scheme: ClickScheme) -> String {
        if let index = viewModel.schemes.firstIndex(where: { $0.id == scheme.id }) {
            return L.presetName(index + 1)
        }
        return L.preset
    }

    var body: some View {
        VStack(spacing: 0) {
            // 顶部栏：语言切换
            HStack {
                Spacer()
                Picker("", selection: Binding(
                    get: { localization.currentLanguage },
                    set: { localization.currentLanguage = $0 }
                )) {
                    Text("中").tag(LocalizationManager.Language.chinese)
                    Text("EN").tag(LocalizationManager.Language.english)
                }
                .pickerStyle(.segmented)
                .frame(width: 80)
                .help(localization.currentLanguage == .chinese ? "Switch to English" : "切换到中文")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            // 主内容区
            HStack(spacing: 0) {
                // 左侧：方案列表
                leftPanel
                    .frame(width: 168)

                Divider()

                // 右侧：编辑区域
                rightPanel
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxHeight: .infinity)
        }
        .navigationTitle("SnapClick")
    }

    // MARK: - 左侧面板
    private var leftPanel: some View {
        VStack(spacing: 0) {
            // 新增按钮
            Button(action: {
                isAddingNew = true
                selectedScheme = nil
            }) {
                Image(systemName: "plus")
                    .font(.body)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .padding(.top, 8)

            // 方案列表
            ScrollView {
                LazyVStack(spacing: 6) {
                    ForEach(viewModel.schemes, id: \.id) { scheme in
                        SchemeListItem(
                            scheme: scheme,
                            displayName: schemeDisplayName(for: scheme),
                            viewModel: viewModel,
                            isSelected: selectedScheme?.id == scheme.id,
                            onSelect: {
                                selectedScheme = scheme
                                isAddingNew = false
                            }
                        )
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    // MARK: - 右侧面板
    private var rightPanel: some View {
        Group {
            // 编辑区域
            if let scheme = selectedScheme {
                SchemeEditor(
                    scheme: scheme,
                    viewModel: viewModel,
                    isAddingNew: false,
                    selectedScheme: $selectedScheme,
                    isAddingNewBinding: $isAddingNew
                )
                .id(scheme.id)  // ⚠️ 关键：使用方案ID作为视图唯一标识，确保不同方案使用独立视图实例
            } else if isAddingNew {
                SchemeEditor(
                    scheme: nil,
                    viewModel: viewModel,
                    isAddingNew: true,
                    selectedScheme: $selectedScheme,
                    isAddingNewBinding: $isAddingNew
                )
                .id("new-scheme")  // ⚠️ 新建方案使用固定ID
            } else {
                // 空状态
                VStack(spacing: 12) {
                    Image(systemName: "hand.point.up.left.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)

                    Text("选择一个方案或创建新方案")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

// MARK: - 方案列表项
struct SchemeListItem: View {
    let scheme: ClickScheme
    let displayName: String
    @ObservedObject var viewModel: ClickerViewModel
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 4) {
                // 标题和开关
                HStack {
                    Text(displayName)
                        .font(.system(size: 11))  // 从 12 改为 11
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)  // 灰色
                        .lineLimit(1)

                    Spacer(minLength: 4)

                    Toggle("", isOn: binding(for: scheme))
                        .labelsHidden()
                        .toggleStyle(AlwaysActiveToggleStyle())
                        .scaleEffect(0.7)
                }

                // 详细信息
                VStack(alignment: .leading, spacing: 4) {  // 增加行间距从 2 到 4
                    Text(L.clickDescription(
                        button: scheme.button == .left ? L.leftButton : L.rightButton,
                        count: scheme.clickCount,
                        duration: String(format: "%.1f", scheme.totalDuration)
                    ))
                        .font(.system(size: 11))  // 从 10 改为 11
                        .foregroundColor(.primary)  // 黑色

                    hotkeyDisplay
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.accentColor.opacity(0.15) : Color(nsColor: .controlBackgroundColor))
            )
        }
        .buttonStyle(.plain)
    }

    private var hotkeyDisplay: some View {
        HStack(spacing: 4) {
            Text(L.hotkey)
                .font(.system(size: 10))
                .foregroundColor(.secondary)

            HStack(spacing: 2) {
                if scheme.hotkey.modifierFlags.contains(.maskCommand) {
                    Image(systemName: "command")
                }
                if scheme.hotkey.modifierFlags.contains(.maskAlternate) {
                    Image(systemName: "option")
                }
                if scheme.hotkey.modifierFlags.contains(.maskControl) {
                    Image(systemName: "control")
                }
                if scheme.hotkey.modifierFlags.contains(.maskShift) {
                    Image(systemName: "shift")
                }
                Text(keyCodeToString(scheme.hotkey.keyCode))
            }
            .font(.system(size: 10))
            .foregroundColor(.secondary)
        }
    }

    private func binding(for scheme: ClickScheme) -> Binding<Bool> {
        Binding(
            get: { scheme.isEnabled },
            set: { newValue in
                // 检查是否配置了快捷键
                if newValue && scheme.hotkey.keyCode == 0 {
                    // 尝试启用但未配置快捷键，显示提示
                    showHotkeyRequiredAlert()
                } else {
                    viewModel.toggleScheme(scheme)
                }
            }
        )
    }

    private func showHotkeyRequiredAlert() {
        let alert = NSAlert()
        alert.messageText = "未配置快捷键"
        alert.informativeText = "请先为该方案配置快捷键后再启用"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "确定")
        alert.runModal()
    }

    private func keyCodeToString(_ keyCode: UInt16) -> String {
        let mapping: [UInt16: String] = [
            0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X",
            8: "C", 9: "V", 11: "B", 12: "Q", 13: "W", 14: "E", 15: "R",
            16: "Y", 17: "T", 31: "O", 32: "U", 34: "I", 35: "P", 37: "L",
            38: "J", 40: "K", 45: "N", 46: "M",
            18: "1", 19: "2", 20: "3", 21: "4", 22: "6", 23: "5", 24: "=", 25: "9", 26: "7",
            27: "-", 28: "8", 29: "0", 30: "]", 33: "[", 39: "'", 41: ";", 42: "\\",
            43: ",", 44: "/", 47: ".", 50: "`",
            36: "↩", 48: "⇥", 49: "Space", 51: "⌫", 53: "⎋",
            123: "←", 124: "→", 125: "↓", 126: "↑"
        ]
        return mapping[keyCode] ?? "Key\(keyCode)"
    }
}

// MARK: - 方案编辑器
struct SchemeEditor: View {
    let scheme: ClickScheme?
    @ObservedObject var viewModel: ClickerViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    let isAddingNew: Bool
    @Binding var selectedScheme: ClickScheme?
    @Binding var isAddingNewBinding: Bool

    @State private var name: String
    @State private var button: MouseButton
    @State private var clickCount: String
    @State private var totalDuration: String
    @State private var isRecordingHotkey = false
    @State private var recordedKeyCode: UInt16
    @State private var recordedCommand: Bool
    @State private var recordedOption: Bool
    @State private var recordedControl: Bool
    @State private var recordedShift: Bool
    @State private var localEventMonitor: Any?

    init(scheme: ClickScheme?, viewModel: ClickerViewModel, isAddingNew: Bool, selectedScheme: Binding<ClickScheme?>, isAddingNewBinding: Binding<Bool>) {
        self.scheme = scheme
        self.viewModel = viewModel
        self.isAddingNew = isAddingNew
        self._selectedScheme = selectedScheme
        self._isAddingNewBinding = isAddingNewBinding

        // ⚠️ 关键：为每个方案创建独立的State副本，避免数据共享
        if let scheme = scheme {
            // 编辑现有方案 - 从方案数据初始化
            let currentScheme = scheme  // 创建局部副本
            _name = State(initialValue: currentScheme.name)
            _button = State(initialValue: currentScheme.button)
            _clickCount = State(initialValue: String(currentScheme.clickCount))
            _totalDuration = State(initialValue: String(currentScheme.totalDuration))
            _recordedKeyCode = State(initialValue: currentScheme.hotkey.keyCode)
            _recordedCommand = State(initialValue: currentScheme.hotkey.modifierFlags.contains(.maskCommand))
            _recordedOption = State(initialValue: currentScheme.hotkey.modifierFlags.contains(.maskAlternate))
            _recordedControl = State(initialValue: currentScheme.hotkey.modifierFlags.contains(.maskControl))
            _recordedShift = State(initialValue: currentScheme.hotkey.modifierFlags.contains(.maskShift))
        } else {
            // 新建方案 - 使用默认值
            _name = State(initialValue: "")
            _button = State(initialValue: .left)
            _clickCount = State(initialValue: "10")
            _totalDuration = State(initialValue: "1.0")
            _recordedKeyCode = State(initialValue: 0)
            _recordedCommand = State(initialValue: true)
            _recordedOption = State(initialValue: true)
            _recordedControl = State(initialValue: false)
            _recordedShift = State(initialValue: false)
        }
    }

    private var isFormValid: Bool {
        guard let count = Int(clickCount), let duration = Double(totalDuration) else {
            return false
        }
        return count > 0 && count <= 100 &&  // 最大100次点击
               duration > 0 && duration <= 60 &&  // 最大60秒
               recordedKeyCode != 0  // 必须设置快捷键
    }

    // 检查快捷键是否已配置
    private var hasHotkey: Bool {
        recordedKeyCode != 0
    }

    // 计算当前方案的显示名称
    private var schemeDisplayName: String {
        if let scheme = scheme {
            if let index = viewModel.schemes.firstIndex(where: { $0.id == scheme.id }) {
                return L.presetName(index + 1)
            }
        }
        return L.newPreset
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 顶部标题和删除按钮
            HStack {
                Text(schemeDisplayName)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)

                Spacer()

                if !isAddingNew {
                    // 编辑模式：删除按钮在右上角
                    Button(action: deleteScheme) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.bottom, 8)

            // 鼠标按键
            VStack(alignment: .leading, spacing: 6) {
                Text(L.mouseButton)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                Picker("", selection: $button) {
                    Text(L.leftButton).tag(MouseButton.left)
                    Text(L.rightButton).tag(MouseButton.right)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            // 点击次数和完成时长并排
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        Text(L.clickCount)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        if let count = Int(clickCount), count > 100 {
                            Text("(max 100)")
                                .font(.system(size: 9))
                                .foregroundColor(.red)
                        }
                    }
                    TextField("", text: $clickCount)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: clickCount) { newValue in
                            // 限制最大值为100
                            if let count = Int(newValue), count > 100 {
                                clickCount = "100"
                            }
                        }
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        Text(L.duration)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        if let duration = Double(totalDuration), duration > 60 {
                            Text("(max 60s)")
                                .font(.system(size: 9))
                                .foregroundColor(.red)
                        }
                    }
                    TextField("", text: $totalDuration)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: totalDuration) { newValue in
                            // 限制最大值为60秒
                            if let duration = Double(newValue), duration > 60 {
                                totalDuration = "60"
                            }
                        }
                }
            }

            // 快捷键
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(L.hotkey)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)

                    if !hasHotkey {
                        Text(L.hotkeyRequired)
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                    }
                }

                HStack(spacing: 4) {
                    Button(action: { toggleHotkeyRecording() }) {
                        Text(isRecordingHotkey ? L.recording : (hasHotkey ? hotkeyDisplayText : L.clickToSet))
                            .font(.system(size: 12))
                            .foregroundColor(hasHotkey ? .primary : .secondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 24)
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                    if hasHotkey {
                        Button(action: { clearHotkey() }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .font(.system(size: 12))
                        }
                        .buttonStyle(.plain)
                        .help("清除快捷键")
                    }
                }
            }

            Spacer()

            // 底部按钮（所有模式都显示）
            HStack(spacing: 8) {
                Spacer()

                // 取消和保存按钮在右侧
                Button(action: cancelEditing) {
                    Text(L.cancel)
                        .font(.system(size: 12))  // 从 13 改为 12
                        .frame(width: 60)  // 从 70 改为 60
                        .frame(height: 26)  // 从 28 改为 26
                }
                .buttonStyle(.bordered)

                Button(action: saveScheme) {
                    Text(L.save)
                        .font(.system(size: 12))  // 从 13 改为 12
                        .frame(width: 60)  // 从 70 改为 60
                        .frame(height: 26)  // 从 28 改为 26
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onDisappear {
            stopHotkeyRecording()
        }
    }

    private var hotkeyDisplayText: String {
        var parts: [String] = []
        if recordedCommand { parts.append("⌘") }
        if recordedOption { parts.append("⌥") }
        if recordedControl { parts.append("⌃") }
        if recordedShift { parts.append("⇧") }

        parts.append(keyCodeToString(recordedKeyCode))

        return parts.joined(separator: "")
    }

    private func keyCodeToString(_ keyCode: UInt16) -> String {
        let mapping: [UInt16: String] = [
            // 字母键
            0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X",
            8: "C", 9: "V", 11: "B", 12: "Q", 13: "W", 14: "E", 15: "R",
            16: "Y", 17: "T", 31: "O", 32: "U", 34: "I", 35: "P", 37: "L",
            38: "J", 40: "K", 45: "N", 46: "M",
            // 数字键
            18: "1", 19: "2", 20: "3", 21: "4", 22: "6", 23: "5", 24: "=", 25: "9", 26: "7",
            27: "-", 28: "8", 29: "0", 30: "]", 33: "[", 39: "'", 41: ";", 42: "\\",
            43: ",", 44: "/", 47: ".", 50: "`",
            // 功能键
            36: "↩", 48: "⇥", 49: "Space", 51: "⌫", 53: "⎋",
            // 方向键
            123: "←", 124: "→", 125: "↓", 126: "↑"
        ]
        return mapping[keyCode] ?? "Key\(keyCode)"
    }


    private func cancelEditing() {
        // 取消编辑 - 关闭编辑器
        selectedScheme = nil
        isAddingNewBinding = false
    }

    private func saveScheme() {
        guard isFormValid else { return }
        guard let count = Int(clickCount), let duration = Double(totalDuration) else { return }

        let hotkey = Hotkey(
            keyCode: recordedKeyCode,
            commandKey: recordedCommand,
            optionKey: recordedOption,
            controlKey: recordedControl,
            shiftKey: recordedShift
        )

        if isAddingNew {
            // 新建方案 - 使用自动生成的名称
            let schemeName = "预设\(viewModel.schemes.count + 1)"
            let newScheme = ClickScheme(
                name: schemeName,
                button: button,
                clickCount: count,
                totalDuration: duration,
                hotkey: hotkey,
                isEnabled: false
            )
            viewModel.addScheme(newScheme)
            // 保存后关闭新增界面
            isAddingNewBinding = false
        } else if var oldScheme = scheme {
            // 更新现有方案 - 保持原有 ID 和名称
            oldScheme.button = button
            oldScheme.clickCount = count
            oldScheme.totalDuration = duration
            oldScheme.hotkey = hotkey
            // 保持 oldScheme.isEnabled 和 oldScheme.name 不变

            viewModel.updateScheme(scheme!, with: oldScheme)
            // 更新选中的方案以刷新显示
            if let index = viewModel.schemes.firstIndex(where: { $0.id == oldScheme.id }) {
                selectedScheme = viewModel.schemes[index]
            }
        }
    }

    private func deleteScheme() {
        guard let scheme = scheme else { return }
        viewModel.deleteScheme(scheme)
        // 删除后关闭编辑器
        selectedScheme = nil
    }

    private func clearHotkey() {
        recordedKeyCode = 0
        recordedCommand = false
        recordedOption = false
        recordedControl = false
        recordedShift = false
    }

    // MARK: - 快捷键录制
    private func toggleHotkeyRecording() {
        if isRecordingHotkey {
            stopHotkeyRecording()
        } else {
            startHotkeyRecording()
        }
    }

    private func startHotkeyRecording() {
        isRecordingHotkey = true

        // 暂时禁用所有方案的快捷键监听
        viewModel.pauseHotkeyMonitoring()

        // 监听修饰键变化
        let flagsMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { event in
            if self.isRecordingHotkey {
                return nil  // 录制时拦截所有修饰键事件
            }
            return event
        }

        // 监听按键事件
        let keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if self.isRecordingHotkey {
                // 记录按键和修饰键
                self.recordedKeyCode = event.keyCode
                self.recordedCommand = event.modifierFlags.contains(.command)
                self.recordedOption = event.modifierFlags.contains(.option)
                self.recordedControl = event.modifierFlags.contains(.control)
                self.recordedShift = event.modifierFlags.contains(.shift)

                // 停止录制
                self.stopHotkeyRecording()

                return nil  // 拦截事件
            }
            return event
        }

        // 保存监听器（合并到一个数组）
        localEventMonitor = [flagsMonitor, keyMonitor] as AnyObject
    }

    private func stopHotkeyRecording() {
        isRecordingHotkey = false

        // 移除事件监听器
        if let monitors = localEventMonitor as? [Any] {
            for monitor in monitors {
                NSEvent.removeMonitor(monitor)
            }
            localEventMonitor = nil
        }

        // 恢复快捷键监听
        viewModel.resumeHotkeyMonitoring()
    }
}

// MARK: - 自定义 Toggle 样式
// 确保在窗口失去焦点时仍保持清晰的开启/关闭状态颜色
struct AlwaysActiveToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack {
                // 背景
                RoundedRectangle(cornerRadius: 12)
                    .fill(configuration.isOn ? Color.green : Color.gray.opacity(0.3))
                    .frame(width: 40, height: 24)

                // 滑块
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .offset(x: configuration.isOn ? 8 : -8)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}

// 自定义语言切换Toggle样式
struct LanguageToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            // 外框（无背景色）
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                .frame(width: 60, height: 28)

            // 两个文字标签：都显示在按钮内部
            HStack(spacing: 0) {
                Text("中")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(width: 30, height: 28)

                Text("EN")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(width: 30, height: 28)
            }

            // 滑块 - 高亮显示当前选中的文字
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 28, height: 24)

                // 滑块上的文字（高亮显示）
                Text(configuration.isOn ? "EN" : "中")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.primary)
            }
            .offset(x: configuration.isOn ? 15 : -15)
            .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
        }
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}
