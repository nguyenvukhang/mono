import Cocoa

extension NSScreen {
    /// Gets the screen that contains the user's cursor.
    static func current() -> NSScreen {
        NSScreen.screens.first { s in NSPointInRect(NSEvent.mouseLocation, s.frame) }!
    }
}

extension NSRect {
    /// Sets aspect ratio. Result will always be smaller than the start state.
    mutating func setAspectRatio(_ ratio: Double) {
        size.width = min(height * ratio, width)
        size.height = width / ratio
    }

    /// Scales a rect. Origin is invariant.
    mutating func scale(by x: Double) {
        size.width *= x
        size.height *= x
    }

    /// Constrained inside of NSRect `screen`, minimize the distance from the
    /// center of the rect to NSPoint `point`.
    mutating func moveCenter(to point: NSPoint, within screen: NSRect) {
        origin.x = min(max(screen.origin.x, point.x - width / 2),
                       screen.maxX - width)
        origin.y = min(max(screen.origin.y, point.y - height / 2),
                       screen.maxY - height)
    }

    /// Center self within a `parent` rect.
    mutating func center(within parent: NSRect) {
        origin.x = parent.midX - width / 2
        origin.y = parent.midY - height / 2
    }

    /// Make rect at most as large as previous state, with aspect ratio of `ratio`,
    /// and centered within its old state.
    mutating func centerWithRatio(_ ratio: Double) {
        let midX = midX, midY = midY
        setAspectRatio(ratio)
        origin.x = midX - width / 2
        origin.y = midY - height / 2
    }

    /// Creates the `NSRect` which precision mode will be set to.
    func precisionModeFrame(at point: NSPoint, scale: Double, aspectRatio: Double) -> NSRect {
        var rect = self
        rect.setAspectRatio(aspectRatio)
        rect.scale(by: scale)
        rect.moveCenter(to: point, within: self)
        return rect
    }
}

extension NSBezierPath {
    /// take a (bottom-left) path and add it 4 times in all 4 flipped states
    ///                        ┌─       ─┐
    ///
    ///      · (0,0)       →        · (0,0)
    ///
    /// └─                     └─       ─┘
    func addAll4Orientations(path u: NSBezierPath) {
        let v = u.copy() as! NSBezierPath
        v.transform(using: AffineTransform(scaleByX: -1, byY: 1))
        u.append(v)
        append(u)
        u.transform(using: AffineTransform(scaleByX: 1, byY: -1))
        append(u)
    }

    /// Draws 4 Ls at each corner of the rect.
    func drawBounds(around rect: NSRect, length: Double, margin: Double) {
        // px that the drawing will exceed the frame
        let exceed = lineWidth / 2
        let pad = margin - exceed
        let originToCenter = AffineTransform(translationByX: rect.width / 2,
                                             byY: rect.height / 2)
        let length = min(length, (rect.width - margin) / 2, (rect.height - margin) / 2)

        // Draw an L
        let l = NSBezierPath()
        l.move(to: NSPoint(x: 0, y: length))
        l.line(to: NSPoint(x: 0, y: 0))
        l.line(to: NSPoint(x: length, y: 0))
        l.transform(using: AffineTransform(translationByX: pad, byY: pad))

        // Draw all 4 orientations
        l.transform(using: originToCenter.inverted()!)
        addAll4Orientations(path: l)
        transform(using: originToCenter)
    }
}
