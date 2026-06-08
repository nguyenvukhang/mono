import Cocoa

/// A binary enum that just has better readability.
enum Mode {
    case precision
    case fullscreen

    mutating func next() {
        self = switch self {
        case .precision: .fullscreen
        case .fullscreen: .precision
        }
    }
}

/// Wraps Wacom with Helium's app state.
/// This includes preferences and running-state variables such as last-used tablet.
class Helium {
    let overlay = Overlay()
    var lastUsedTablet: Int32 = 0 // initialize with invalid tablet ID

    var penInProximity: Bool = false {
        didSet {
            if !penInProximity {
                return overlay.hide()
            }
            if mode == .precision {
                overlay.show()
            }
        }
    }

    var mode: Mode = .fullscreen {
        didSet {
            switch mode {
            case .fullscreen: setFullScreenMode()
            case .precision: setPrecisionMode()
            }
        }
    }

    func preview() {
        switch mode {
        case .precision: if penInProximity {
                overlay.show()
            } else {
                overlay.flash()
            }
        case .fullscreen: overlay.flash()
        }
    }

    /// Make the tablet cover the area around the cursor's current location.
    private func setPrecisionMode() {
        var frame = NSScreen.current().frame
        frame = frame.precisionModeFrame(at: NSEvent.mouseLocation, scale: SCALE, aspectRatio: ASPECT_RATIO)
        setTabletMapArea(to: frame)
        overlay.setFrameWithMargin(to: &frame)
        overlay.drawPrecisionModeArt(lineColor: LINE_COLOR, lineWidth: LINE_WIDTH, cornerLength: CORNER_LENGTH)
    }

    /// Make the tablet cover the whole screen that contains the user's cursor.
    private func setFullScreenMode() {
        var frame = NSScreen.current().frame
        if FULLSCREEN_KEEP_ASPECT_RATIO {
            frame.centerWithRatio(ASPECT_RATIO)
        }
        setTabletMapArea(to: frame)
        overlay.setFrame(frame, display: true)
        overlay.drawFullscreenModeArt(lineColor: LINE_COLOR, lineWidth: LINE_WIDTH, cornerLength: CORNER_LENGTH)
    }

    /// Sends a WacomTabletDriver API call to override tablet map area.
    private func setTabletMapArea(to rect: NSRect) {
        ObjCWacom.setScreenMapArea(rect, tabletId: lastUsedTablet)
    }

    /// Reset screen map area to current screen. For use upon exiting.
    func reset() {
        ObjCWacom.setScreenMapArea(NSScreen.current().frame, tabletId: lastUsedTablet)
    }
}
