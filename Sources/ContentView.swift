import SwiftUI
import AppKit

struct ContentView: View {
    // ⚠️ 关键：使用 AppDelegate 中的共享 ViewModel，确保窗口关闭后仍然运行
    @ObservedObject private var viewModel: ClickerViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var schemeToEdit: ClickScheme?
    @State private var showingEditor = false
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

            // 主内容区：只显示方案列表
            mainPanel
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("SnapClick")
        .sheet(isPresented: $showingEditor) {
            SchemeEditorSheet(
                scheme: schemeToEdit,
                viewModel: viewModel,
                isAddingNew: isAddingNew,
                isPresented: $showingEditor
            )
        }
    }

    // MARK: - 主面板（方案列表）
    private var mainPanel: some View {
        VStack(spacing: 0) {
            // 方案列表
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.schemes, id: \.id) { scheme in
                        SchemeCard(
                            scheme: scheme,
                            displayName: schemeDisplayName(for: scheme),
                            viewModel: viewModel,
                            onEdit: {
                                schemeToEdit = scheme
                                isAddingNew = false
                                showingEditor = true
                            }
                        )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 6)
                .padding(.bottom, 6)
            }

            // 新增按钮 - 图标化（移到下面）
            Button(action: {
                isAddingNew = true
                schemeToEdit = nil
                showingEditor = true
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 11.8))
                    Text(L.add)
                        .font(.system(size: 11.8))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 30)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 10)
        }
        .frame(maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

// MARK: - 方案卡片
struct SchemeCard: View {
    let scheme: ClickScheme
    let displayName: String
    @ObservedObject var viewModel: ClickerViewModel
    let onEdit: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            // 左侧：可点击区域
            Button(action: onEdit) {
                VStack(alignment: .leading, spacing: 6) {
                    // 顶部：标题
                    Text(displayName)
                        .font(.system(size: 12.6, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // 详细信息
                    VStack(alignment: .leading, spacing: 5) {
                        // 点击信息
                        HStack(spacing: 3) {
                            Image(systemName: scheme.button == .left ? "cursorarrow.click" : "cursorarrow.click.2")
                                .font(.system(size: 11.8))
                                .foregroundColor(.secondary)
                            Text(L.clickDescription(
                                button: scheme.button == .left ? L.leftButton : L.rightButton,
                                count: scheme.clickCount,
                                duration: String(format: "%.1f", scheme.totalDuration)
                            ))
                            .font(.system(size: 11.8))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                        }

                        // 快捷键信息
                        hotkeyDisplay
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // 右侧：开关（垂直居中）
            Toggle("", isOn: binding(for: scheme))
                .labelsHidden()
                .toggleStyle(AlwaysActiveToggleStyle())
                .scaleEffect(0.65)
                .padding(.trailing, 10)
                .padding(.leading, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: scheme.isEnabled ? Color.accentColor.opacity(0.4) : Color.black.opacity(0.08), radius: scheme.isEnabled ? 6 : 3, x: 0, y: 2)
        )
    }

    private var hotkeyDisplay: some View {
        HStack(spacing: 3) {
            // 快捷键标签
            Text(L.hotkey)
                .font(.system(size: 11.8))
                .foregroundColor(.secondary)

            // 快捷键组合
            HStack(spacing: 1) {
                if scheme.hotkey.modifierFlags.contains(.maskCommand) {
                    Text("⌘")
                }
                if scheme.hotkey.modifierFlags.contains(.maskAlternate) {
                    Text("⌥")
                }
                if scheme.hotkey.modifierFlags.contains(.maskControl) {
                    Text("⌃")
                }
                if scheme.hotkey.modifierFlags.contains(.maskShift) {
                    Text("⇧")
                }
                Text(keyCodeToString(scheme.hotkey.keyCode))
            }
            .font(.system(size: 11.8, weight: .medium))
            .foregroundColor(.primary)
        }
    }

    private func binding(for scheme: ClickScheme) -> Binding<Bool> {
        Binding(
            get: { scheme.isEnabled },
            set: { newValue in
                if newValue && scheme.hotkey.keyCode == 0 {
                    showHotkeyRequiredAlert()
                } else {
                    viewModel.toggleScheme(scheme)
                }
            }
        )
    }

    private func showHotkeyRequiredAlert() {
        let alert = NSAlert()
        alert.messageText = L.hotkeyRequired
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

// MARK: - 方案编辑器弹窗
struct SchemeEditorSheet: View {
    let scheme: ClickScheme?
    @ObservedObject var viewModel: ClickerViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    let isAddingNew: Bool
    @Binding var isPresented: Bool

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

    init(scheme: ClickScheme?, viewModel: ClickerViewModel, isAddingNew: Bool, isPresented: Binding<Bool>) {
        self.scheme = scheme
        self.viewModel = viewModel
        self.isAddingNew = isAddingNew
        self._isPresented = isPresented

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
        let cps = Double(count) / duration
        return count > 0 &&  // 点击次数大于0
               duration > 0 && duration <= 60 &&  // 最大60秒
               cps <= 200 &&  // 最大200 CPS (Clicks Per Second)
               recordedKeyCode != 0  // 必须设置快捷键
    }

    // 计算当前的CPS
    private var currentCPS: Double {
        guard let count = Int(clickCount), let duration = Double(totalDuration), duration > 0 else {
            return 0
        }
        return Double(count) / duration
    }

    // 检查快捷键是否已配置
    private var hasHotkey: Bool {
        recordedKeyCode != 0
    }

    // 计算当前方案的显示名称
    private var schemeDisplayName: String {
        if isAddingNew {
            return L.newPreset
        }

        if let scheme = scheme {
            // 根据方案在列表中的索引生成名称，忽略数据库中保存的name
            if let index = viewModel.schemes.firstIndex(where: { $0.id == scheme.id }) {
                return L.presetName(index + 1)
            }
            // 如果找不到索引，使用默认的预设名称
            return L.preset
        }
        return L.newPreset
    }

    var body: some View {
        VStack(spacing: 0) {
            // 顶部标题栏 - 压缩间距
            HStack {
                Text(schemeDisplayName)
                    .font(.system(size: 14.3, weight: .semibold))

                Spacer()

                if !isAddingNew {
                    // 编辑模式：删除按钮 - 图标化
                    Button(action: deleteScheme) {
                        Image(systemName: "trash")
                            .font(.system(size: 12.5))
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                    .help(L.delete)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            // 编辑表单 - 大幅压缩间距
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    // 鼠标按键
                    VStack(alignment: .leading, spacing: 5) {
                        Text(L.mouseButton)
                            .font(.system(size: 10.7, weight: .medium))
                            .foregroundColor(.secondary)
                        Picker("", selection: $button) {
                            Text(L.leftButton).font(.system(size: 10.7)).tag(MouseButton.left)
                            Text(L.rightButton).font(.system(size: 10.7)).tag(MouseButton.right)
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }

                    // 点击次数和完成时长
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(L.clickCount)
                                .font(.system(size: 10.7, weight: .medium))
                                .foregroundColor(.secondary)
                            TextField("", text: $clickCount)
                                .textFieldStyle(.roundedBorder)
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text(L.duration)
                                .font(.system(size: 10.7, weight: .medium))
                                .foregroundColor(.secondary)
                            TextField("", text: $totalDuration)
                                .textFieldStyle(.roundedBorder)
                                .onChange(of: totalDuration) { newValue in
                                    if let duration = Double(newValue), duration > 60 {
                                        totalDuration = "60"
                                    }
                                }
                            if let duration = Double(totalDuration), duration > 60 {
                                Text("(max 60s)")
                                    .font(.system(size: 8.9))
                                    .foregroundColor(.red)
                            }
                        }
                    }

                    // CPS 提示
                    if currentCPS > 200 {
                        HStack(spacing: 5) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 9.8))
                            Text(L.cpsWarning)
                                .font(.system(size: 9.8))
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(6)
                    } else if currentCPS > 0 {
                        Text(String(format: L.currentCPS, currentCPS))
                            .font(.system(size: 9.8))
                            .foregroundColor(.secondary)
                    }

                    // 快捷键
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(L.hotkey)
                                .font(.system(size: 10.7, weight: .medium))
                                .foregroundColor(.secondary)

                            if !hasHotkey {
                                Text("(\(L.hotkeyRequired))")
                                    .font(.system(size: 8.9))
                                    .foregroundColor(.red)
                            }
                        }

                        HStack(spacing: 6) {
                            Button(action: { toggleHotkeyRecording() }) {
                                Text(isRecordingHotkey ? L.recording : (hasHotkey ? hotkeyDisplayText : L.clickToSet))
                                    .font(.system(size: 10.7))
                                    .foregroundColor(hasHotkey ? .primary : .secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                            }
                            .buttonStyle(.bordered)

                            if hasHotkey {
                                Button(action: { clearHotkey() }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: 13.4))
                                }
                                .buttonStyle(.plain)
                                .help("清除快捷键")
                            }
                        }
                    }
                }
                .padding(18)
            }

            Divider()

            // 底部按钮 - 移除固定宽度
            HStack(spacing: 10) {
                Button(action: cancelEditing) {
                    Text(L.cancel)
                        .font(.system(size: 10.7))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.bordered)
                .keyboardShortcut(.cancelAction)

                Button(action: saveScheme) {
                    Text(L.save)
                        .font(.system(size: 10.7))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
                .keyboardShortcut(.defaultAction)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(Color(nsColor: .controlBackgroundColor))
        }
        .frame(width: 210, height: 331)  // 高度增加20%: 276 * 1.2 = 331
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
        // 取消编辑 - 关闭弹窗
        isPresented = false
    }

    private func saveScheme() {
        guard isFormValid else { return }
        guard let count = Int(clickCount), let duration = Double(totalDuration) else { return }

        // 取消所有焦点，移出光标
        NSApp.keyWindow?.makeFirstResponder(nil)

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
        } else if let oldScheme = scheme {
            // 更新现有方案 - 创建新的方案对象，保持原有 ID、名称和启用状态
            var updatedScheme = oldScheme
            updatedScheme.button = button
            updatedScheme.clickCount = count
            updatedScheme.totalDuration = duration
            updatedScheme.hotkey = hotkey
            // ⚠️ 关键：保持 isEnabled 状态不变
            // updatedScheme.isEnabled 和 updatedScheme.name 已经从 oldScheme 继承

            viewModel.updateScheme(oldScheme, with: updatedScheme)
        }

        // 保存后关闭弹窗
        isPresented = false
    }

    private func deleteScheme() {
        guard let scheme = scheme else { return }
        viewModel.deleteScheme(scheme)
        // 删除后关闭弹窗
        isPresented = false
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
