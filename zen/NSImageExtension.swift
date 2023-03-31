import AppKit

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
