import Cocoa

class StatusBarController {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    init() {
        if let button = NSApp.mainMenu?.item(withTag: 1)?.submenu?.item(withTag: 1)?.view as? NSStatusBarButton {
            statusItem.button?.image = nil
            statusItem.button?.title = String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
            statusItem.button?.toolTip = "Timer"
            statusItem.button?.addSubview(button)
        }
    }
}
