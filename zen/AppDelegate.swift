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
        window.contentView = NSHostingView(rootView: ContentView())
        
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
        
        // Add a menu to the status item
        let menu = NSMenu()
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
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
