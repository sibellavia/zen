import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the status item and assign an image
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.image = NSImage(named: "zenIcon")
        statusItem?.button?.image?.size = NSSize(width: 16, height: 16)
        statusItem?.length = 18 // Imposta la lunghezza della NSStatusItem
        statusItem?.button?.imagePosition = .imageLeft // Imposta l'allineamento dell'icona
        statusItem?.button?.font = NSFont.systemFont(ofSize: 12, weight: .regular)
        statusItem?.button?.toolTip = "Timer"
        
        // Add a menu to the status item
        let menu = NSMenu()
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        statusItem?.menu = menu
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


