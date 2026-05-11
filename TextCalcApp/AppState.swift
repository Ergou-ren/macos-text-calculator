import Observation

@Observable
final class AppState {
    var hotkeyStatus: String = "Hotkey not initialized"
    var isBootstrapped: Bool = false

    func bootstrapIfNeeded(isUITesting: Bool) {
        guard !isBootstrapped else {
            return
        }
        isBootstrapped = true

        if isUITesting {
            hotkeyStatus = "UI testing mode; hotkey skipped"
            return
        }

        let service = HotkeyService()
        hotkeyStatus = service.registerDefaultHotkey() ? "Hotkey registered" : "Hotkey unavailable; menu bar fallback active"
    }
}
