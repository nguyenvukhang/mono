import Cocoa

class Overlay: NSWindow {
    private let margin = 16.0

    init() {
        super.init(contentRect: NSMakeRect(0, 0, 0, 1), styleMask: .borderless, backing: .buffered, defer: true)
        collectionBehavior = .canJoinAllSpaces
        ignoresMouseEvents = true
        level = .screenSaver
        alphaValue = 0
    }

    /// Shows the overlay window (instant).
    func show() {
        alphaValue = 1
    }

    /// Hides the overlay window with a fade.
    func hide() {
        animateAlpha(to: 0, over: 1.0)
    }

    /// Shows then hides the overlay window.
    func flash() {
        show()
        hide()
    }
    
    func setFrameWithMargin(to rect: inout NSRect) {
        rect.origin.x -= margin
        rect.origin.y -= margin

        if frame.size.equalTo(rect.size) {
            // no re-draw required, since rect is same size
            setFrameOrigin(rect.origin)
            return
        }

        rect.size.width += margin * 2
        rect.size.height += margin * 2
        setFrame(rect, display: true)
    }
    
    private func draw(commands: () -> ()) {
        let bg = NSImage(size: frame.size)
        bg.lockFocus()
        commands()
        bg.unlockFocus()
        backgroundColor = NSColor(patternImage: bg)
    }

    /// Draws the 4 Ls around the window.
    func drawPrecisionModeArt(lineColor: NSColor, lineWidth: Double, cornerLength: Double) {
        draw {
            lineColor.set()
            let line = NSBezierPath()
            line.lineJoinStyle = .round
            line.lineWidth = lineWidth
            line.drawBounds(around: frame, length: cornerLength, margin: margin)
            line.stroke()
        }
    }
    
    /// Draws a circle in the middle of the screen.
    func drawFullscreenModeArt(lineColor: NSColor, lineWidth: Double, cornerLength _: Double) {
        draw {
            lineColor.set()
            
            var circRect = frame
            circRect.setAspectRatio(1)
            circRect.scale(by: 0.1)
            circRect.center(within: NSRect(origin: .zero, size: frame.size))

            let circ = NSBezierPath(ovalIn: circRect)
            circ.lineWidth = lineWidth
            circ.stroke()
        }
    }

    /// Changes transparency of the overlay window, with an endpoint of `alpha`
    /// and over a time interval `interval`.
    private func animateAlpha(to alpha: Double, over interval: TimeInterval) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = interval
        animator().alphaValue = alpha
        NSAnimationContext.endGrouping()
    }

    override var canBecomeKey: Bool {
        true
    }
}
