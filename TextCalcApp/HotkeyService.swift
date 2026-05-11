import Carbon
import Foundation

struct HotkeyService {
    let defaultKeyCode: UInt32 = 17
    let defaultModifiers: UInt32 = UInt32(cmdKey | optionKey)

    func registerDefaultHotkey() -> Bool {
        let hotKeyId = EventHotKeyID(signature: OSType(0x54435854), id: 1)
        var hotKeyRef: EventHotKeyRef?
        let status = RegisterEventHotKey(
            defaultKeyCode,
            defaultModifiers,
            hotKeyId,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )
        return status == noErr && hotKeyRef != nil
    }
}
