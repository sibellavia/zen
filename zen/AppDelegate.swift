import Cocoa
import SwiftUI
import Combine
import AppKit

class MainApp: ObservableObject {
    @StateObject var appDelegate = AppDelegate()
}

@main
struct zenApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {}
    }
}


class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    
    var timerMenuItem: NSMenuItem?
    
    @Published var timeRemaining = 1500 {
        didSet {
            if let timerMenuItem = timerMenuItem {
                timerMenuItem.title = "Timer: \(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60))"
            }
        }
    }
    
    var window: NSWindow!
    
    func showAppWindow() {
        NSApp.activate(ignoringOtherApps: true)
        if let window = NSApplication.shared.windows.first {
            window.makeKeyAndOrderFront(nil)
        }
    }
    
    @objc func statusItemClicked(_ sender: Any?) {
        if NSApp.isActive {
            NSApp.hide(nil)
        } else {
            showAppWindow()
        }
    }
    
    @objc func openAppWindow(_ sender: Any?) {
        showAppWindow()
    }
    
    @objc func hideApp(_ sender: Any?) {
        NSApp.hide(nil)
    }
    
    @objc func setTimerDuration(_ sender: NSMenuItem) {
        if let durationTitle = sender.title.components(separatedBy: " ").first,
           let duration = Int(durationTitle) {
            timeRemaining = duration * 60
        }
    }
    
    @objc func setCustomTimerDuration(_ sender: NSMenuItem) {
        let alert = NSAlert()
        alert.messageText = "Enter custom timer duration (minutes)"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")

        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        textField.placeholderString = "Duration in minutes"
        alert.accessoryView = textField

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            let durationText = textField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if let duration = Int(durationText) {
                timeRemaining = duration * 60
            }
        }
    }
    
    var statusItem: NSStatusItem?
    var cancellables = Set<AnyCancellable>()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Crea una nuova finestra senza cornice e senza barra del titolo
        let styleMask: NSWindow.StyleMask = [.borderless, .fullSizeContentView, .closable, .miniaturizable, .resizable]
        window = NSWindow(contentRect: NSMakeRect(0, 0, 350, 200),
                          styleMask: styleMask,
                          backing: .buffered,
                          defer: false)
        
        // Imposta le dimensioni della finestra e disabilita il ridimensionamento
        window.setFrame(NSRect(x: 0, y: 0, width: 350, height: 200), display: true)
        window.isReleasedWhenClosed = false
        window.isMovableByWindowBackground = true
        window.minSize = NSSize(width: 350, height: 200)
        window.maxSize = NSSize(width: 350, height: 200)
        
        window.center()
        
        // Imposta il contenuto della finestra
        window.contentView = NSHostingView(rootView: ContentView(appDelegate: self))
        
        // Imposta lo sfondo della finestra trasparente e non opaco
        window.backgroundColor = NSColor.clear
        window.isOpaque = false
        
        // Mostra la finestra e rendila la chiave principale
        window.makeKeyAndOrderFront(nil)
        
        // Create the status item and assign an image
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.image = NSImage(named: "zenIcon")
        statusItem?.button?.image?.size = NSSize(width: 16, height: 16)
        statusItem?.length = 18 // Imposta la lunghezza della NSStatusItem
        statusItem?.button?.imagePosition = .imageLeft // Imposta l'allineamento dell'icona
        statusItem?.button?.font = NSFont.systemFont(ofSize: 12, weight: .regular)
        statusItem?.button?.toolTip = "Timer"
        
        // opening the application
        statusItem?.button?.action = #selector(AppDelegate.statusItemClicked(_:))
        
        statusItem?.button?.title = "Timer: \(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60))"
        
        // Add a menu to the status item
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Timer: 25:00", action: nil, keyEquivalent: ""))
        timerMenuItem = menu.item(at: 0)
        $timeRemaining
            .map { timeRemaining in
                "Timer: \(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60))"
            }
            .assign(to: \.title, on: timerMenuItem!)
            .store(in: &cancellables)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Open", action: #selector(openAppWindow(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Hide", action: #selector(hideApp(_:)), keyEquivalent: "h")
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(NSMenuItem.separator())
        let timerOptions = NSMenu(title: "Timer Options")
        timerOptions.addItem(withTitle: "25 minutes", action: #selector(setTimerDuration(_:)), keyEquivalent: "")
        timerOptions.addItem(withTitle: "50 minutes", action: #selector(setTimerDuration(_:)), keyEquivalent: "")
        timerOptions.addItem(withTitle: "90 minutes", action: #selector(setTimerDuration(_:)), keyEquivalent: "")
        timerOptions.addItem(withTitle: "Custom...", action: #selector(setCustomTimerDuration(_:)), keyEquivalent: "")
        menu.addItem(withTitle: "Timer Options", action: nil, keyEquivalent: "").submenu = timerOptions
        
        statusItem?.menu = menu
        
        // Start the application
        NSApp.run()
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // tearing down the application
    }
    
}

extension NSImage {
    func withProgress(_ progress: CGFloat) -> NSImage {
        let imageWidth: CGFloat = 2
        let imageHeight: CGFloat = 2
        let circleWidth: CGFloat = 4.0
        let circleMargin: CGFloat = 2.0
        let circleRadius = (min(imageWidth, imageHeight) - circleWidth - circleMargin) / 2.0
        
        let image = NSImage(size: NSSize(width: imageWidth, height: imageHeight), flipped: false) { rect in
            let context = NSGraphicsContext.current?.cgContext
            context?.setFillColor(NSColor.clear.cgColor)
            context?.fill(rect)
            
            context?.setLineWidth(circleWidth)
            context?.setLineCap(.round)
            context?.setStrokeColor(NSColor.white.cgColor)
            context?.addArc(center: CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0),
                            radius: circleRadius,
                            startAngle: -CGFloat.pi / 2.0,
                            endAngle: -CGFloat.pi / 2.0 + 2.0 * CGFloat.pi * progress,
                            clockwise: false)
            context?.strokePath()
            
            return true
        }
        
        return image
    }
}
